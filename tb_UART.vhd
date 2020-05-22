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
		remDataRxBuf			: 	in std_logic; 
		wrUart					:	in std_Logic; --Set if we wnt to read or write from UART module 
		txFull, rxEmpty		: 	out std_logic; --Set according to FIFO bufferes
		dataIn					: 	in std_logic_vector(15 downto 0);
		dataOut					: 	out std_logic_vector(15 downto 0)
	);
end component;

constant T: time 			:= 20 ns;	
constant baudTime: time := 52 us;

signal clk 						: std_logic;
signal reset 					: std_logic := '0';
signal rx 						: std_logic;
signal tx 						: std_logic;
signal dataIn 					: std_logic_vector(15 downto 0);
signal dataOut					: std_logic_vector(15 downto 0);
signal wrUart 					: std_logic := '0';
signal txFull 					: std_logic;
signal rxEmpty 				: std_logic;
signal remDataRxBuf			: std_logic :='0';

begin

	uut: UART port map(
		clk => clk,
		reset => reset,
		rx => rx,
		tx => tx,
		dataIn => dataIn,
		dataOut => dataOut,
		wrUart => wrUart,
		txFull => txFull,
		rxEmpty => rxEmpty,
		remDataRxBuf => remDataRxBuf
	);
	
	process
	begin
		clk <= '0';
		wait for T/2;
		clk <= '1';
		wait for T/2;
	end process;
	
	process
	begin
		reset <= '1';
		wait until falling_edge(clk);
		reset <= '0';
		wait until falling_edge(clk);
		wrUart <= '1';
		dataIn <= x"F00F";
		wait until falling_edge(clk);
		wrUart <= '0';
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
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		remDataRxBuf <= '1';
		wait until falling_edge(clk);
		remDataRxBuf <= '0';
		wait for baudTime;
	end process;
	
	
end Behavioral;