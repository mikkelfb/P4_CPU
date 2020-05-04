library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

Entity Branching_Control is 
	port(
			CarryFlag 				: in STD_LOGIC;
			ZeroFlag 				: in STD_LOGIC;
			En							: in STD_LOGIC;
			EnLatch					: in STD_LOGIC;
			PCControl 				: out STD_LOGIC
	);
End Branching_Control;


architecture Behavioral of Branching_Control is 
signal Last_ZF: STD_LOGIC;
signal Last_CF: STD_LOGIC;

begin 
process(En, CarryFlag, ZeroFlag)
	begin 
		if(En = '1' AND EnLatch = '1') thEn 
			Last_ZF <= ZeroFlag;
			Last_CF <= CarryFlag;
		End if;
End process;

PCControl <= Last_ZF WHEn En = '1' ELSE 'Z';
End Behavioral; 