library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;


Entity Instruction_Decoder is 
	port(
			instructionCode 			: in STD_LOGIC_VECTOR(14 downto 0);
			clk 							: in STD_LOGIC;
			reset							: in STD_LOGIC;
			EnWr							: in STD_LOGIC;
			addrSRAM						: out STD_LOGIC_VECTOR(6 downto 0);
			opCodeALU					: out STD_LOGIC_VECTOR(4 DOWNTO 0);
			opCodeCU						: out STD_LOGIC_VECTOR(4 DOWNTO 0);
			addrRegA						: out STD_LOGIC_VECTOR(2 downto 0);
			addrRegB						: out STD_LOGIC_VECTOR(2 downto 0);
			addrRegC						: out STD_LOGIC_VECTOR(2 downto 0);
			addrPC						: out STD_LOGIC_VECTOR(6 downto 0)
	);
end Instruction_Decoder;
			
			
architecture Behavioral of Instruction_Decoder is
	signal opCodeIntern: STD_LOGIC_VECTOR(4 downto 0);
	signal currentInstruction: STD_LOGIC_VECTOR(14 downto 0) := (others=>'0');
	signal internAddrSRAM	: STD_LOGIC_VECTOR(6 downto 0) := (others=>'0');
begin 
	opCodeIntern <= currentInstruction(4 downto 0);
	
	opCodeCU <= instructionCode(4 downto 0) when EnWr = '1' else (others=>'0'); --sends Opcode directly to CU in Decode state
	addrSRAM <= instructionCode(14 downto 8) when EnWr = '1' else internAddrSRAM; --Makes sure to set addr for SRAM so it is ready for execute state
	
	opCodeALU <= currentInstruction(4 downto 0);	
	process(opCodeIntern, currentInstruction)
		begin
			addrRegA <= (others=>'0');
			addrRegB <= (others=>'0');
			addrRegC <= (others=>'0');
			internAddrSRAM <= (others=>'0');
			addrPC 	<= (others=>'0');

			case opCodeIntern is
				when "00001" => 
					addrRegC <= currentInstruction(7 downto 5);
					internAddrSRAM <= currentInstruction(14 downto 8);
				when "00010" =>
					addrRegA <= currentInstruction(7 Downto 5);
					internAddrSRAM <= currentInstruction(14 downto 8);
				when "00011" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
				When "00100" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
				when "00101" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
				when "00110" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
				when "00111" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
				when "01000" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
				when "01001" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
				when "01010" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
				when "01011" =>
					addrRegA <= currentInstruction(7 downto 5);
					addrRegB <= currentInstruction(10 downto 8);
					addrRegC <= currentInstruction(14 downto 12);
				when "01100" =>
					addrPC <= currentInstruction(14 downto 8);
				when "01101" =>
					addrRegC <= currentInstruction(7 downto 5);
				when "01110" =>
					addrRegA <= currentInstruction(7 downto 5);
				when "01111" =>
					addrRegA <= currentInstruction(7 downto 5);
				when "10000" =>
					addrRegA <= currentInstruction(7 downto 5);
				when "10001" =>
					addrPC <= currentInstruction(14 downto 8);
				when "10010" =>
					addrPC <= currentInstruction(14 downto 8);
				when others =>
			end case;
	end process;

	process (clk, EnWr, reset)
		begin
			if(reset = '1') then
				currentInstruction <= (others=>'0');
			elsif(Rising_edge(clk)) then 
				if(EnWr ='1') then
					currentInstruction <= instructionCode;
				end if;
			end if;
	end process;

end Behavioral; 