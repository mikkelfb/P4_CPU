library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

entity ALU is
	port (
		opCode						:	in STD_LOGIC_VECTOR(4 downto 0);
		ALUA							:	in STD_LOGIC_VECTOR(15 downto 0);
		ALUB							:	in STD_LOGIC_VECTOR(15 downto 0);
		ALUOut						:	out STD_LOGIC_VECTOR(15 downto 0);
		EnAlu							: 	in STD_LOGIC
		--carryFlag, zeroFlag		: 	out STD_LOGIC
	);
end ALU;

architecture Behavioral of ALU is
	signal aluRes	: std_logic_vector(15 downto 0);
begin

process (EnAlu, opCode, ALUA , ALUB)
	begin
		if(EnAlu = '1') then
			case opCode is
				when "00010" => --Write to SRAMC:\intelFPGA_lite\18.1\modelsim_ase\win32aloem
					aluRes <= (ALUA);
				when "00011" => -- A Bigger then B
					if(ALUA > ALUB) then 
						aluRes <= x"0001";
					else
						aluRes <= x"0000";
					end if;
				when "00100" => -- A smaller then B
					if(ALUA < ALUB) then
						aluRes <= x"0001";
					else
						aluRes <= x"0000";
					end if;
				when "00101" => -- A equal B
					if(ALUA = ALUB) then
						aluRes <= x"0001";
					else
						aluRes <= x"0000";
					end if;
				when "00110" => -- A bitwise AND B
					aluRes <= ALUA AND ALUB;
				when "00111" => -- A bitwise OR B
					aluRes <= ALUA OR ALUB;
				when "01000" =>  -- A + B
					aluRes <= std_logic_vector(to_unsigned(( to_integer(unsigned(ALUA)) + to_integer(unsigned(ALUB))), 16)); --OLD: ALUA + ALUB;
				when "01001" =>  -- A - B
					aluRes <= std_logic_vector(to_unsigned(( to_integer(unsigned(ALUA)) - to_integer(unsigned(ALUB))), 16)); --OLD: ALUA - ALUB;
				when "01010" =>  -- A / B
					aluRes <= std_logic_vector(to_unsigned(( to_integer(unsigned(ALUA)) / to_integer(unsigned(ALUB))), 16));
				when "01011" => -- A * B
					aluRes <= std_logic_vector(to_unsigned(( to_integer(unsigned(ALUA)) * to_integer(unsigned(ALUB))), 16));
				when "01110" => --Write to UART
					aluRes <= (ALUA);
				when "01111" => --Write to 7-segment
					aluRes <= (ALUA);
				when "10000" => --Write to SD
					aluRes <= (ALUA);
				when others =>
					aluRes <= x"0000";
			end case;
		else
			aluRes <= "ZZZZZZZZZZZZZZZZ";
		end if;
end process;

ALUOut <= aluRes;

end Behavioral;
