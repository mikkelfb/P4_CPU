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
			EN							: in STD_LOGIC;
			EN_Latch					: in STD_LOGIC;
			PC_Control 				: out STD_LOGIC
	);
end component;

signal CarryFlag 					: STD_LOGIC;
signal ZeroFlag 					: STD_LOGIC;
signal EN							: STD_LOGIC;
signal EN_Latch					: STD_LOGIC;
signal PC_Control 				: STD_LOGIC;

begin 

	uut: Branching_Control port map(
		CarryFlag  => CarryFlag,
		ZeroFlag   => ZeroFlag,
		EN			  => EN, 
		EN_Latch	  => EN_Latch,
		PC_Control => PC_Control
	);
	
	process 
	begin 
		EN <= '1';
		EN_Latch <= '1';
		ZeroFlag <= '1';
		wait for 10 ns;
		EN_Latch <= '0';
		wait for 10 ns;
		ZeroFlag <= '0';
		wait for 10 ns;
		EN <= '0';
		wait for 10 ns;
		ZeroFlag <= '0';
		EN <= '1';
		EN_Latch <= '1';
		wait for 10 ns;
	end process;
end Behavioral; 
