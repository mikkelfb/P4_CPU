library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;


entity SRAMVHead is
	port (
			clk 					: in std_logic;
			EnWrite				: in std_logic;
			SRAMaddrControl	: in std_logic; -- 0 = ID, 1 = PC
			addrFromID			: in std_logic_vector(6 downto 0);
			addrFromPC			: in std_logic_vector(6 downto 0);
			dataIn				: in std_logic_vector(15 downto 0);
			dataout				: out std_logic_vector(15 downto 0);
			InstructionOut		: out std_logic_vector(14 downto 0)
	);
end SRAMVHead;


architecture Behavioral of SRAMVHead is
	signal addrSRAM : std_logic_vector(6 downto 0);
	signal dataInSRAM : std_logic_vector(15 downto 0);
	signal dataOutSRAM : std_logic_vector(15 downto 0);
begin
	--Get IP component
	SRAMIPUnit	: entity work.SRAM(SYN)
		port map(
			address 	=> addrSRAM, 	--address
			clock 	=> clk, 			--clock
			data 		=> dataIn, 		--datain
			wren 		=> EnWrite, 	--write enable
			q 			=> dataOutSRAM --dataout
		);
	
	
	InstructionOut <= dataOutSRAM(14 downto 0);
	dataout 			<= dataOutSRAM;
	
	addrSRAM <= addrFromPC when  SRAMaddrControl= '1' else
					addrFromID;
end Behavioral;