library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

entity tb_Branching_Control is 
end tb_Branching_Control;

architecture Behavioral of tb_Branching_Control is 
component Branching_Control
	port(
			CarryFlag 				: in STD_LOGIC;
			ZeroFlag 				: in STD_LOGIC;
			En							: in STD_LOGIC;
			EnLatchALU				: in STD_LOGIC;
			EnUart					: in std_logic;
			PCControl 				: out STD_LOGIC;
			UartBranch				: in std_logic
	);
end component;

signal CarryFlag 					: STD_LOGIC;
signal ZeroFlag 					: STD_LOGIC := '0';
signal EN							: STD_LOGIC := '0';
signal EnLatchALU					: STD_LOGIC := '0';
signal EnUart						: std_Logic := '0';
signal PCControl 					: STD_LOGIC := '0';
signal UartBranch					: std_Logic := '0';

begin 

	uut: Branching_Control port map(
		CarryFlag  	=> CarryFlag,
		ZeroFlag   	=> ZeroFlag,
		EN			  	=> EN, 
		EnLatchALU	=> EnLatchALU,
		PCControl 	=> PCControl,
		UartBranch	=> UartBranch,
		EnUart		=> EnUart
	);
	
	process 
	begin 
		EnLatchALU <= '1';
		ZeroFlag <= '1';
		wait for 10 ns;
		EnLatchALU <= '0';
		ZeroFlag <= '0';
		EN <= '1';
		wait for 10 ns;
		EN <= '0';
		wait for 10 ns;
		UartBranch <= '0';
		EnUart <= '1';
		wait for 10 ns;
	end process;
end Behavioral; 
