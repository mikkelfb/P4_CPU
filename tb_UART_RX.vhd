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
		--sTick					:	in std_logic;
		rxDoneTick			:	out std_logic;
		dataOut				:	out std_logic_vector(7 downto 0)
	);
	end component;
	
	
	constant T: time := 20 ns;											-- Used to simulate a 50 MHz clock cycle
	constant baudTime: time := 52 us;								-- Used to simulate unput, set for a baudrate at 19200
	
	
	signal clk			:	std_logic;									-- Create a signal for the clock
	signal rx			:	std_logic;									-- Create a signal that carries the bits
	--signal sTick		:	std_logic;									-- Create a signal for the enable tick from the baud generator
	signal testData	:	std_logic_vector(7 downto 0);			-- Create a signal that contains the test data bit string
	signal reset		:	std_logic;
	signal rxDoneTick	: 	std_logic;
	signal dataOut		: 	std_logic_vector(7 downto 0);
	
	begin
	
		uut: UART_RX port map (
			clk			=> clk,
			reset			=> reset,
			rx				=> rx,
			--sTick			=> sTick
			rxDoneTick 	=> rxDoneTick,
			dataOut		=> dataOut
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
		rx <= '0';					-- Sets rx to 0 generate start signal
		wait for baudTime;
		
		for i in 0 to 7 loop
			rx <= not rx;			-- set rx to shift between 1 and 0 for 8 bits
			wait for baudTime;
		end loop;
		
		rx <= '1';					-- set rx to 1 and waits for to baudTime to generate stop signal
		wait for baudTime;
		wait for baudTime;
		
	end process;
	
end behavioral;