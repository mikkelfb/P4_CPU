LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity tb_baudGenerator is
end tb_baudGenerator;

Architecture behavioral of tb_baudGenerator is

	component baudGenerator 
		port (
			clk, reset		:	in std_logic;
			maxTick			:	out std_logic;
			q					:	out std_logic_vector(7 downto 0)
	);
	end component;
	
	constant T: time := 20 ns;											-- Used to simulate a 50 MHz clock cycle
	
	signal clk			:	std_logic;									-- Create a signal for the clock
	signal reset		:	std_logic;
	signal maxTick		:	std_logic;
	signal q				:	std_logic_vector(7 downto 0);
	
	begin
	
	uut: baudGenerator port map(
		clk		=> clk,
		reset		=> reset,
		maxTick	=> maxTick,
		q			=>	q
	);
	
	reset <= '0';
	
	process
	begin
		clk <= '0';
		wait for T/2;
		clk <= '1';
		wait for T/2;
	end process;
end behavioral;