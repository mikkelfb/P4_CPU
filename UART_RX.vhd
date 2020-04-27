LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity uartRx is

	generic (
		DBIT: 	integer := 8;		-- Number of data bits
		SB_TICK: integer := 16		-- Numbers of ticks for stop bits
	);
	
	port (
		clk, reset	: in std_logic;
		rx				: in std_logic;
		sTick			: in std_logic;
		rxDoneTick	: out std_logic;
		dataOut		: out std_logic_vector(DBIT-1 downto 0)
	);
	
end uartRx;

architecture behavioral of uartRx is
