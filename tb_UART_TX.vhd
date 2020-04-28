LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity tb_UART_TX is
end tb_UART_TX;


Architecture behavioral of tb_UART_TX is

	component UART_TX
	port (
		clk, reset			: 	in std_logic;									
		tx_start				: 	in std_logic;									
		--sTick				: 	in std_logic;									
		txDoneTick			: 	out std_logic;									
		dataIn				: 	in std_logic_vector(7 downto 0);	
		tx						:	out std_logic
	);
	end component;
	
	constant T: time := 20 ns;											-- Used to simulate a 50 MHz clock cycle
	constant baudTime: time := 52 us;								-- Used to simulate unput, set for a baudrate at 19200
	
	
	signal clk			:	std_logic;									-- Create a signal for the clock
	signal tx			:	std_logic;									-- Create a signal that carries the bits
	--signal sTick		:	std_logic;									-- Create a signal for the enable tick from the baud generator
	signal dataIn		:	std_logic_vector(7 downto 0);			-- Create a signal that contains the test data bit string
	signal reset		:	std_logic;
	signal txDoneTick	: 	std_logic;
	signal tx_start	: 	std_logic;
	
begin
	
		uut: UART_TX port map (
			clk			=> clk,
			reset			=> reset,
			tx				=> tx,
			--sTick			=> sTick
			txDoneTick 	=> txDoneTick,
			dataIn		=> dataIn,
			tx_start		=> tx_start
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
	
	dataIn <= "10101010"; --Sets simulated sending byte to 10101010 0xAA
	
	process
	begin
	
		--waits one baudTime before starting
		wait for baudTime;
		tx_start <= '1';
		wait for baudTime;
		tx_start <= '0'; -- sets tx_start to 0
		--Waits for 10 times baudtime to be sure transmition is done as it should take 1bit Start + 8bit data + 1 bit stop = 10
		for i in 0 to 10 loop
			wait for baudTime;
		end loop;
		
	end process;
	
end behavioral;