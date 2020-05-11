library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

Entity Branching_Control is 
	port(
			CarryFlag 				: in STD_LOGIC;
			ZeroFlag 				: in STD_LOGIC;
			En							: in STD_LOGIC;
			EnLatchALU				: in STD_LOGIC;
			EnUart					: in std_logic;
			PCControl 				: out STD_LOGIC;
			UartBranch				: in std_logic
	);
End Branching_Control;


architecture Behavioral of Branching_Control is 
	signal Last_ZF: STD_LOGIC;
	signal Last_CF: STD_LOGIC;

begin 
	process(EnLatchALU, En, CarryFlag, ZeroFlag)
		begin 
			if(EnLatchALU = '1') then 
				Last_ZF <= ZeroFlag;
				Last_CF <= CarryFlag;
			End if;
	End process;

	PCControl <= 	Last_ZF When (En = '1' and EnUart = '0') else
						UartBranch when (EnUart = '1' and En = '0')
						else '0';
End Behavioral; 