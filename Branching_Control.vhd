library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

Entity Branching_Control is 
	port(
			CarryFlag 				: in STD_LOGIC;
			ZeroFlag 				: in STD_LOGIC;
			EN							: in STD_LOGIC;
			EN_Latch					: in STD_LOGIC;
			PC_Control 				: out STD_LOGIC
	);
end Branching_Control;


architecture Behavioral of Branching_Control is 
signal Last_ZF: STD_LOGIC;
signal Last_CF: STD_LOGIC;

begin 
process(EN, CarryFlag, ZeroFlag)
	begin 
		if(EN = '1' AND EN_Latch = '1') then 
			Last_ZF <= ZeroFlag;
			Last_CF <= CarryFlag;
		end if;
end process;

PC_Control <= Last_ZF WHEN EN = '1' ELSE 'Z';
end Behavioral; 