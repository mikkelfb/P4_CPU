library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;


Entity Instruction_Decoder is 
	port(
			instructionCode 			: in STD_LOGIC_VECTOR(14 downto 0);
			clk 							: in STD_LOGIC;
			EnID							: in STD_LOGIC;
			EnWr							: in STD_LOGIC;
			addrSRAM						: out STD_LOGIC_VECTOR(6 downto 0);
			opCode						: out STD_LOGIC_VECTOR(4 DOWNTO 0);
			addrRegA						: out STD_LOGIC_VECTOR(2 downto 0);
			addrRegB						: out STD_LOGIC_VECTOR(2 downto 0);
			addrRegC						: out STD_LOGIC_VECTOR(2 downto 0);
			addrPC						: out STD_LOGIC_VECTOR(6 downto 0)
	);
end Instruction_Decoder;
			
			
architecture Behavioral of Instruction_Decoder is
signal opCodeIntern: STD_LOGIC_VECTOR(4 downto 0);
signal currentInstruction: STD_LOGIC_VECTOR(14 downto 0);

begin 
opCodeIntern <= currentInstruction(4 downto 0);
process(opCodeIntern, currentInstruction, EnID)
	begin
		if(EnID = '1') then
			case opCodeIntern is
				when "00001" => 
					addrRegC <= currentInstruction(7 downto 5);
					addrSRAM <= currentInstruction(14 downto 8);
					addrRegA <= "ZZZ";
					addrRegB <= "ZZZ";
					addrPC <= "ZZZZZZZ";
				when "00010" =>
					addrRegA <= currentInstruction(7 Downto 5);
					addrSRAM <= currentInstruction(14 downto 8);
					addrRegB <= "ZZZ";
					addrRegC <= "ZZZ";
					addrPC <= "ZZZZZZZ";
				when "00011" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
					addrSRAM <= "ZZZZZZZ";
					addrPC <= "ZZZZZZZ";
				When "00100" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
					addrSRAM <= "ZZZZZZZ";
					addrPC <= "ZZZZZZZ";
				when "00101" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
					addrSRAM <= "ZZZZZZZ";
					addrPC <= "ZZZZZZZ";
				when "00110" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
					addrSRAM <= "ZZZZZZZ";
					addrPC <= "ZZZZZZZ";
				when "00111" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
					addrSRAM <= "ZZZZZZZ";
					addrPC <= "ZZZZZZZ";
				when "01000" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
					addrSRAM <= "ZZZZZZZ";
					addrPC <= "ZZZZZZZ";
				when "01001" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
					addrSRAM <= "ZZZZZZZ";
					addrPC <= "ZZZZZZZ";
				when "01010" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
					addrSRAM <= "ZZZZZZZ";
					addrPC <= "ZZZZZZZ";
				when "01011" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
					addrSRAM <= "ZZZZZZZ";
					addrPC <= "ZZZZZZZ";
				when "01100" =>
					addrPC <= currentInstruction(14 downto 8);
					addrRegA <= "ZZZ";
					addrRegB <= "ZZZ";
					addrRegC <= "ZZZ";	
					addrSRAM <= "ZZZZZZZ";
				when "01101" =>
					addrRegC <= currentInstruction(7 downto 5);
					addrSRAM <= "ZZZZZZZ";
					addrRegA <= "ZZZ";
					addrRegB <= "ZZZ";	
					addrPC <= "ZZZZZZZ";
				when "01110" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrSRAM <= "ZZZZZZZ";
					addrRegB <= "ZZZ";
					addrRegC <= "ZZZ";	
					addrPC <= "ZZZZZZZ";
				when "01111" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrSRAM <= "ZZZZZZZ";
					addrRegB <= "ZZZ";
					addrRegC <= "ZZZ";	
					addrPC <= "ZZZZZZZ";
				when "10000" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrSRAM <= "ZZZZZZZ";
					addrRegB <= "ZZZ";
					addrRegC <= "ZZZ";	
					addrPC <= "ZZZZZZZ";
				when "10001" =>
					addrPC <= currentInstruction(14 downto 8);
					addrRegA <= "ZZZ";
					addrRegB <= "ZZZ";
					addrRegC <= "ZZZ";	
					addrSRAM <= "ZZZZZZZ";
				when others =>
					addrRegA <= "ZZZ";
					addrRegB <= "ZZZ";
					addrRegC <= "ZZZ";	
					addrSRAM <= "ZZZZZZZ";
					addrPC <= "ZZZZZZZ";
			end case;
		else  	
			addrRegA <= "ZZZ";
			addrRegB <= "ZZZ";
			addrRegC <= "ZZZ";	
			addrSRAM <= "ZZZZZZZ";
			addrPC <= "ZZZZZZZ";
		end if;
end process;

process (clk, EnWr)
	begin
		if(Rising_edge(clk)) then 
			if(EnWr ='1') then
			currentInstruction <= instructionCode;
			end if;
		end if;
end process;
				


opCode <= currentInstruction(4 downto 0) when EnID ='1' else (others => 'Z');		
				

end Behavioral; 