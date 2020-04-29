library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;


Entity Instruction_Decoder is 
	port(
			Instruction_Code 			: in STD_LOGIC_VECTOR(14 downto 0);
			clk 							: in STD_LOGIC;
			EN_ID							: in STD_LOGIC;
			En_Wr							: in STD_LOGIC;
			SRAM_Addr					: out STD_LOGIC_VECTOR(6 downto 0);
			Op_Code						: out STD_LOGIC_VECTOR(4 DOWNTO 0);
			Reg_Addr_A					: out STD_LOGIC_VECTOR(2 downto 0);
			Reg_Addr_B					: out STD_LOGIC_VECTOR(2 downto 0);
			Reg_Addr_C					: out STD_LOGIC_VECTOR(2 downto 0)
	);
end Instruction_Decoder;
			
			
architecture Behavioral of Instruction_Decoder is
signal Opcode_Intern: STD_LOGIC_VECTOR(4 downto 0);
signal Current_Instruction: STD_LOGIC_VECTOR(14 downto 0);

begin 
Opcode_Intern <= Current_Instruction(4 downto 0);
process(Opcode_Intern, Current_Instruction, EN_ID)
	begin
		if(EN_ID = '1') then
			case Opcode_Intern is
				when "00001" => 
					Reg_Addr_C <= Current_Instruction(7 downto 5);
					SRAM_Addr <= Current_Instruction(14 downto 8);
					Reg_Addr_A <= "ZZZ";
					Reg_Addr_B <= "ZZZ";	
				when "00010" =>
					Reg_Addr_A <= Current_Instruction(7 Downto 5);
					SRAM_Addr <= Current_Instruction(14 downto 8);
					Reg_Addr_B <= "ZZZ";
					Reg_Addr_C <= "ZZZ";
				when "00011" =>
					Reg_Addr_A <= Current_Instruction(7 downto 5);
					Reg_Addr_B <= Current_Instruction(10 downto 8);
					Reg_Addr_C <= Current_Instruction(14 downto 12);
					SRAM_Addr <= "ZZZZZZZ";
				When "00100" =>
					Reg_Addr_A <= Current_Instruction(7 downto 5);
					Reg_Addr_B <= Current_Instruction(10 downto 8);
					Reg_Addr_C <= Current_Instruction(14 downto 12);
					SRAM_Addr <= "ZZZZZZZ";
				when "00101" =>
					Reg_Addr_A <= Current_Instruction(7 downto 5);
					Reg_Addr_B <= Current_Instruction(10 downto 8);
					Reg_Addr_C <= Current_Instruction(14 downto 12);
					SRAM_Addr <= "ZZZZZZZ";
				when "00110" =>
					Reg_Addr_A <= Current_Instruction(7 downto 5);
					Reg_Addr_B <= Current_Instruction(10 downto 8);
					Reg_Addr_C <= Current_Instruction(14 downto 12);
					SRAM_Addr <= "ZZZZZZZ";
				when "00111" =>
					Reg_Addr_A <= Current_Instruction(7 downto 5);
					Reg_Addr_B <= Current_Instruction(10 downto 8);
					Reg_Addr_C <= Current_Instruction(14 downto 12);
					SRAM_Addr <= "ZZZZZZZ";
				when "01000" =>
					Reg_Addr_A <= Current_Instruction(7 downto 5);
					Reg_Addr_B <= Current_Instruction(10 downto 8);
					Reg_Addr_C <= Current_Instruction(14 downto 12);
					SRAM_Addr <= "ZZZZZZZ";
				when "01001" =>
					Reg_Addr_A <= Current_Instruction(7 downto 5);
					Reg_Addr_B <= Current_Instruction(10 downto 8);
					Reg_Addr_C <= Current_Instruction(14 downto 12);
					SRAM_Addr <= "ZZZZZZZ";
				when "01010" =>
					Reg_Addr_A <= Current_Instruction(7 downto 5);
					Reg_Addr_B <= Current_Instruction(10 downto 8);
					Reg_Addr_C <= Current_Instruction(14 downto 12);
					SRAM_Addr <= "ZZZZZZZ";
				when "01011" =>
					Reg_Addr_A <= Current_Instruction(7 downto 5);
					Reg_Addr_B <= Current_Instruction(10 downto 8);
					Reg_Addr_C <= Current_Instruction(14 downto 12);
					SRAM_Addr <= "ZZZZZZZ";
				when "01101" =>
					Reg_Addr_C <= Current_Instruction(7 downto 5);
					SRAM_Addr <= "ZZZZZZZ";
					Reg_Addr_A <= "ZZZ";
					Reg_Addr_B <= "ZZZ";	
				when "01110" =>
					Reg_Addr_A <= Current_Instruction(7 downto 5);
					SRAM_Addr <= "ZZZZZZZ";
					Reg_Addr_B <= "ZZZ";
					Reg_Addr_C <= "ZZZ";	
				when "01111" =>
					Reg_Addr_A <= Current_Instruction(7 downto 5);
					SRAM_Addr <= "ZZZZZZZ";
					Reg_Addr_B <= "ZZZ";
					Reg_Addr_C <= "ZZZ";	
				when "10000" =>
					Reg_Addr_A <= Current_Instruction(7 downto 5);
					SRAM_Addr <= "ZZZZZZZ";
					Reg_Addr_B <= "ZZZ";
					Reg_Addr_C <= "ZZZ";	
				when others =>
					Reg_Addr_A <= "ZZZ";
					Reg_Addr_B <= "ZZZ";
					Reg_Addr_C <= "ZZZ";	
					SRAM_Addr <= "ZZZZZZZ";
			end case;
		else  	
			Reg_Addr_A <= "ZZZ";
			Reg_Addr_B <= "ZZZ";
			Reg_Addr_C <= "ZZZ";	
			SRAM_Addr <= "ZZZZZZZ";
		end if;
end process;

process (clk, En_Wr)
	begin
		if(Rising_edge(clk)) then 
			if(En_Wr ='1') then
			Current_Instruction <= Instruction_Code;
			end if;
		end if;
end process;
				


Op_Code <= Current_Instruction(4 downto 0) when EN_ID ='1' else (others => 'Z');		
				

end Behavioral; 