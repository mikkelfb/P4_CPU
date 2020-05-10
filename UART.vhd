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
		--rData					: 	out std_logic_vector(7 downto 0); --Data received from UART
		--wData					: 	in std_logic_vector(7 downto 0); --Data to send with UART
		rx							: 	in std_logic; -- Port for rx connector
		tx							: 	out std_logic; --Port for tx connector
		remDataRxBuf			: 	in std_logic; 
		wrUart					:	in std_Logic; --Set if we wnt to read or write from UART module 
		txFull, rxEmpty		: 	out std_logic; --Set according to FIFO bufferes
		dataIn					: 	in std_logic_vector(15 downto 0);
		dataOut					: 	out std_logic_vector(15 downto 0)
	);

end UART;

architecture behavioral of UART is
	signal tick						: std_logic; --signal for mapping tick from baud generator to the TX and RX
	signal rxDoneTick				: std_logic; --Is set when RX is done is mapped to RX fifo write, so the FIFO stores the RX signal when it is done.
	signal txFifoOut				: std_logic_vector(7 downto 0); --Signal used to map FIFO_TX output to TX data input
	signal rxDataOut				: std_logic_vector(7 downto 0); --Signal used to map RX data output to FIFO_RX input
	signal txEmpty 				: std_logic; --Signal for TX empty, used to generate a start signal to TX -> TX start when NOT empty
	signal txFifoNotEmpty 		: std_logic; -- see above
	signal txDoneTick				: std_logic; -- Signal for when TX is done, is used to "delete" latest data in TX FIFO buffer
	signal rData					: std_logic_vector(7 downto 0); --Data received from UART
	signal wData					: std_logic_vector(7 downto 0); --Data to send with UART
	
	signal barrelReg				: std_logic_vector(15 downto 0); --Barrel register for TX as we can only send 8 bit, and we want to send 16 bit numbers.
	signal internWrUart			: std_logic :='0'; --Used with barrelReg, is set for the TX FIFO buffer when data  is in barrelReg
	signal barrelRegCounter		: std_logic_vector(1 downto 0); --Counter used with barrelReg to determine state
	signal barrelRegCounterNext	: std_logic_vector(1 downto 0); --Next state used with counter
	
begin
	--Baud generator entity
	baudGenerator_unit: entity work.baudGenerator(behavioral) --import baudGenerator sets it output to tick signal to use in other Uart modules
		port map(clk=>clk , reset=>reset , q=>open , maxTick=>tick);

	--RX entities
	UART_RX_Unit: entity work.UART_RX(behavioral)
		port map(clk=>clk, reset=>reset, rx => rx , rxDoneTick =>rxDoneTick , dataOut => rxDataOut , sTick => tick);
		
	Fifo_RX_unit: entity work.FIFO(behavioral)
		port map(clk=>clk , reset=>reset, rd=>remDataRxBuf , wr=>rxDoneTick, 
		wData => rxDataOut, empty => rxEmpty , full => open , rData=>rData);
	
	--TX entities
	UART_TX_unit: entity work.UART_TX(behavioral)
		port map(clk=>clk, reset=>reset, tx => tx, txStart=>txFifoNotEmpty , 
					dataIn =>txFifoOut , txDoneTick => txDoneTick, sTick => tick);
	
	Fifo_TX_unit: entity work.FIFO(behavioral)
		port  map(clk => clk, reset=>reset, rd=>txDoneTick , wr=>internWrUart, 
		wData => wData , empty=>txEmpty , full=>txFull , rData=>txFifoOut);
	
	txFifoNotEmpty <= not txEmpty;

	
	--sets output to 0 if you are not reading from UART, and concartenate rData with zeroes such that the output is 16-bit long for databus
	dataOut <="00000000" & rData;

	--Logic for writing data to UART
	process(clk , wrUart)	
	begin
		if(rising_edge(clk)) then
			if(wrUart = '1') then
				barrelReg <= dataIn; --Sets input to barrel registor as, the FIFO buffer is only 8 bit long
			end if;
			barrelRegCounter <= barrelRegCounterNext; -- Sets next state for barrelcounter
		end if;
	end process;
	--Sets the next for barrelcounter
	barrelRegCounterNext <= "00" when wrUart = '1' else --"Reset" the counter when there is a wrUart signal
									  "01" when barrelRegCounter = "00" else --Sets next state
									  "10" when barrelRegCounter = "01" else --sets next state "10" is idle state
										barrelRegCounter; --Set state to itself when in idle state
	
	--sets data according to what barrelreg is
	wData <= barrelReg(15 downto 8) when barrelRegCounter = "00" else --sets output from barrelreg to the left 8 bits, when barrelReg is in "00" state
				 barrelReg(7 downto 0); --sets output from barrelreg to the left 8 bits, when barrelReg is in other states
	
	--Sets intern write, which determine whether the FIFO should read data from barrelreg
	internWrUart <= '1' when barrelRegCounter = "00" else
							'1' when barrelRegCounter = "01" else
							'0';
end behavioral;
