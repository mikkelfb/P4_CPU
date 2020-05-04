LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity tb_UART is
end tb_UART;

architecture Behavioral of tb_UART is 

component UART
	port(
		clk, reset				: 	in std_logic;
		rx							: 	in std_logic; -- Port for rx connector
		tx							: 	out std_logic; --Port for tx connector
		rd_uart, wr_uart		:	in std_Logic; --Set if we wnt to read or write from UART module 
		tx_full, rx_empty		: 	out std_logic; --Set according to FIFO bufferes
		dataInOut				: 	inout std_logic_vector(15 downto 0);
		removedata_RX_buf		:	in std_logic
	);
end component;

constant T: time 			:= 20 ns;	
constant baudTime: time := 52 us;

signal clk 						: std_logic;
signal reset 					: std_logic;
signal rx 						: std_logic;
signal tx 						: std_logic;
signal rd_uart 				: std_logic;
signal wr_uart 				: std_logic;
signal tx_full 				: std_logic;
signal rx_empty 				: std_logic;
signal dataInOut 				: std_logic_vector(15 downto 0);
signal removedata_RX_buf	: std_logic;

signal testDataToTX			: std_logic_vector(15 downto 0);
begin

	uut: UART port map(
		clk => clk,
		reset => reset,
		rx => rx,
		tx => tx,
		rd_uart => rd_uart,
		wr_uart => wr_uart,
		tx_full => tx_full,
		rx_empty => rx_empty,
		dataInOUt => dataInOUt,
		removedata_RX_buf => removedata_RX_buf
	);
	
	process
	begin
		clk <= '0';
		wait for T/2;
		clk <= '1';
		wait for T/2;
	end process;
	
	dataInOut <= testDataToTX when (wr_uart = '1' and rd_uart = '0') else (others => 'Z');
	
	process
	begin
		removedata_RX_buf <= '0';
		rd_uart <= '0';
		reset <= '1';
		wait until falling_edge(clk);
		reset <= '0';
		wait until falling_edge(clk);
		wr_uart <= '1';
		testDataToTX <= x"F00F";
		wait until falling_edge(clk);
		wr_uart <= '0';
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		for i in 0 to 25 loop
			wait for baudTime;
		end loop;
		
		rx <= '0';					-- Sets rx to 0 generate start signal
		wait for baudTime;
		
		for i in 0 to 7 loop
			rx <= not rx;			-- set rx to shift between 1 and 0 for 8 bits
			wait for baudTime;
		end loop;
		
		rx <= '1';					-- set rx to 1 and waits for to baudTime to generate stop signal
		wait for baudTime;
		wait for baudTime;
		wait for baudTime;
		wait until falling_edge(clk);
		rd_uart <= '1';
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		rd_uart <= '0';
		removedata_RX_buf <= '1';
		wait until falling_edge(clk);
		removedata_RX_buf <= '0';
		wait for baudTime;
	end process;
	
	
end Behavioral;