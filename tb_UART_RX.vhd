LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity tb_UART_RX is
end tb_UART_RX;


Architecture of tb_UART_RX is

	component UART_RX
	port (
		clk, reset			: 	in std_logic;
		rx 					:	in std_logic;
		sTick					:	in std_logic;
		rxDoneTick			:	out std_logic;
		dataOut				:	out std_logic_vector(7 downto 0)
	);
	
	
	