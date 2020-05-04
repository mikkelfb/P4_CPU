-- This file is inspired by "FPGA PRototyping by VHDL Examples Xilinx Spartan 3"
-- By Pong P. Chu
-- It is an adobtion from listing 7.4

LIBRARY ieee;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;


entity UART is
	port (
		clk, reset				: 	in std_logic;
		--r_data					: 	out std_logic_vector(7 downto 0); --Data received from UART
		--w_data					: 	in std_logic_vector(7 downto 0); --Data to send with UART
		rx							: 	in std_logic; -- Port for rx connector
		tx							: 	out std_logic; --Port for tx connector
		removedata_RX_buf		: 	in std_logic; 
		rd_uart					: 	in std_logic;
		wr_uart					:	in std_Logic; --Set if we wnt to read or write from UART module 
		tx_full, rx_empty		: 	out std_logic; --Set according to FIFO bufferes
		dataInOut				: 	inout std_logic_vector(15 downto 0)
	);

end UART;

architecture behavioral of UART is
	signal tick						: std_logic; --signal for mapping tick from baud generator to the TX and RX
	signal rx_done_tick			: std_logic; --Is set when RX is done is mapped to RX fifo write, so the FIFO stores the RX signal when it is done.
	signal tx_fifo_out			: std_logic_vector(7 downto 0); --Signal used to map FIFO_TX output to TX data input
	signal rx_data_out			: std_logic_vector(7 downto 0); --Signal used to map RX data output to FIFO_RX input
	signal tx_empty 				: std_logic; --Signal for TX empty, used to generate a start signal to TX -> TX start when NOT empty
	signal tx_fifo_not_empty 	: std_logic; -- see above
	signal tx_done_tick			: std_logic; -- Signal for when TX is done, is used to "delete" latest data in TX FIFO buffer
	signal r_data					: std_logic_vector(7 downto 0); --Data received from UART
	signal w_data					: std_logic_vector(7 downto 0); --Data to send with UART
	
	signal barrelReg				: std_logic_vector(15 downto 0); --Barrel register for TX as we can only send 8 bit, and we want to send 16 bit numbers.
	signal intern_Wr_uart		: std_logic :='0'; --Used with barrelReg, is set for the TX FIFO buffer when data  is in barrelReg
	signal barrelReg_counter		: std_logic_vector(1 downto 0); --Counter used with barrelReg to determine state
	signal barrelReg_counter_next	: std_logic_vector(1 downto 0); --Next state used with counter
	
begin
	--Baud generator entity
	baudGenerator_unit: entity work.baudGenerator(behavioral) --import baudGenerator sets it output to tick signal to use in other Uart modules
		port map(clk=>clk , reset=>reset , q=>open , maxTick=>tick);

	--RX entities
	UART_RX_Unit: entity work.UART_RX(behavioral)
		port map(clk=>clk, reset=>reset, rx => rx , rxDoneTick =>rx_done_tick , dataOut => rx_data_out , sTick => tick);
		
	Fifo_RX_unit: entity work.FIFO(behavioral)
		port map(clk=>clk , reset=>reset, rd=>removedata_RX_buf , wr=>rx_done_tick, 
		wData => rx_data_out, empty => rx_empty , full => open , rData=>r_data);
	
	--TX entities
	UART_TX_unit: entity work.UART_TX(behavioral)
		port map(clk=>clk, reset=>reset, tx => tx, tx_start=>tx_fifo_not_empty , 
					dataIn =>tx_fifo_out , txDoneTick => tx_done_tick, sTick => tick);
	
	Fifo_TX_unit: entity work.FIFO(behavioral)
		port  map(clk => clk, reset=>reset, rd=>tx_done_tick , wr=>intern_Wr_uart, 
		wData => w_data , empty=>tx_empty , full=>tx_full , rData=>tx_fifo_out);
	
	tx_fifo_not_empty <= not tx_empty;

	
	--sets output to high impedanse if you are not reading from UART, and concartenate r_data with zeroes such that the output is 16-bit long for databus
	dataInOut <="00000000" & r_data  when (rd_uart = '1' and wr_uart = '0') else (others=>'Z');
		

	--Logic for writing data to UART
	process(clk , wr_uart , dataInOut)	
	begin
		if(rising_edge(clk)) then
			if(wr_uart = '1') then
				barrelReg <= dataInOut; --Sets input to barrel registor as, the FIFO buffer is only 8 bit long
			end if;
			barrelReg_counter <= barrelReg_counter_next; -- Sets next state for barrelcounter
		end if;
	end process;
	--Sets the next for barrelcounter
	barrelReg_counter_next <= "00" when wr_uart = '1' else --"Reset" the counter when there is a wr_uart signal
									  "01" when barrelReg_counter = "00" else --Sets next state
									  "10" when barrelReg_counter = "01" else --sets next state "10" is idle state
										barrelReg_counter; --Set state to itself when in idle state
	
	--sets data according to what barrelreg is
	w_data <= barrelReg(15 downto 8) when barrelReg_counter = "00" else --sets output from barrelreg to the left 8 bits, when barrelReg is in "00" state
				 barrelReg(7 downto 0); --sets output from barrelreg to the left 8 bits, when barrelReg is in other states
	
	--Sets intern write, which determine whether the FIFO should read data from barrelreg
	intern_Wr_uart <= '1' when barrelReg_counter = "00" else
							'1' when barrelReg_counter = "01" else
							'0';
end behavioral;
