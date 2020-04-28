LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity tb_UART_RX is
end tb_UART_RX;


Architecture behavioral of tb_UART_RX is

	component UART_RX
	port (
		clk, reset			: 	in std_logic;
		rx 					:	in std_logic;
		sTick					:	in std_logic;
		rxDoneTick			:	out std_logic;
		dataOut				:	out std_logic_vector(7 downto 0)
	);
	end component;
	
	
	constant T: time := 20 ns;											-- Used to simulate a 50 MHz clock cycle
	
	signal clk			:	std_logic;									-- Create a signal for the clock
	signal rx			:	std_logic;									-- Create a signal that carries the bits
	signal sTick		:	std_logic;									-- Create a signal for the enable tick from the baud generator
	signal testData	:	std_logic_vector(7 downto 0);			-- Create a signal that contains the test data bit string
	signal reset		:	std_logic;
	
	begin
	
		uut: UART_RX port map (
			clk			=> clk,
			reset			=> reset,
			rx				=> rx,
			sTick			=> sTick
			--rxDoneTick 	=> rxDoneTick,
			--dataOut		=> dataOut
		);
		
		reset <= '0';
		
	-- Create a process that simulates the rising and falling edge of a clock
	process
	begin
		clk <= '1';
		wait for T/2;
		clk <= '0';
		wait for T/2;
	end process;
	
	
	
	process
	begin
		rx <= '0';
		
		wait until falling_edge(clk);
		
		for i in 0 to 7 loop
			wait until falling_edge(clk);
		end loop;
		
		rx <= '1';
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		
	end process;
	
end behavioral;
	
	
	
	
	
	
	
	
	
		