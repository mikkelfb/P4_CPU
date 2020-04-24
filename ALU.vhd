library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

-- Implementation of ALU
--
-- The ALU entity have 4 inputs and 3 outputs. The operation which the ALU carryout is determine by the OPCODE
--
--	PARAM[IN] ALUA 16 bit operand
-- PARAM[IN] ALUB 16 bit operand
-- PARAM[IN] opCode 5 bit opcode to determine operation of ALU
-- PARAM[IN] EnAlu 1 bit to determine if ALU should output result
-- PARAM[OUT] ALUOut 16 bit result
-- PARAM[OUT] ZeroFlag 1 if result (ALUOUT) is equal to 0x0000 else 0
-- PARAM[OUT] CarryFlad 1 if addition result in a carry


entity ALU is
	port (
		opCode						:	in STD_LOGIC_VECTOR(4 downto 0);
		ALUA							:	in STD_LOGIC_VECTOR(15 downto 0);
		ALUB							:	in STD_LOGIC_VECTOR(15 downto 0);
		ALUOut						:	out STD_LOGIC_VECTOR(15 downto 0);
		EnAlu							: 	in STD_LOGIC;
		zeroFlag, carryFlag		: 	out STD_LOGIC
	);
end ALU;

architecture Behavioral of ALU is 									-- Implementation of ALU
	signal aluRes	: std_logic_vector(15 downto 0);				-- Signal which holds the result of operation until set to the ALUOut
	signal tempForCarry	: std_logic_vector(16 downto 0);		-- Signal used for carry flag
begin

process (EnAlu, opCode, ALUA , ALUB) 	-- Process takes in EnAlu, opCode, ALUA , ALUB as parameters such that they don't create latches.
	begin
		if(EnAlu = '1') then					-- Checks if the ALU is enabled or not
			case opCode is						-- Case for switching the opcode
				when "00010" => 				-- Write to SRAM
					aluRes <= (ALUA);
				when "00011" => 				-- A Bigger then B
					if(ALUA > ALUB) then 
						aluRes <= x"0001";
					else
						aluRes <= x"0000";
					end if;
				when "00100" => 				-- A smaller then B
					if(ALUA < ALUB) then
						aluRes <= x"0001";
					else
						aluRes <= x"0000";
					end if;
				when "00101" => 				-- A equal B
					if(ALUA = ALUB) then
						aluRes <= x"0001";
					else
						aluRes <= x"0000";
					end if;
				when "00110" => 				-- A bitwise AND B
					aluRes <= ALUA AND ALUB;
				when "00111" => 				-- A bitwise OR B
					aluRes <= ALUA OR ALUB;
				when "01000" =>  				-- A + B
					aluRes <= std_logic_vector(to_unsigned(( to_integer(unsigned(ALUA)) + to_integer(unsigned(ALUB))), 16)); --OLD: ALUA + ALUB;
				when "01001" =>  -- A - B
					aluRes <= std_logic_vector(to_unsigned(( to_integer(unsigned(ALUA)) - to_integer(unsigned(ALUB))), 16)); --OLD: ALUA - ALUB;
				when "01010" =>  				-- A / B
					aluRes <= std_logic_vector(to_unsigned(( to_integer(unsigned(ALUA)) / to_integer(unsigned(ALUB))), 16));
				when "01011" => 				-- A * B
					aluRes <= std_logic_vector(to_unsigned(( to_integer(unsigned(ALUA)) * to_integer(unsigned(ALUB))), 16));
				when "01110" => 				-- Write to UART
					aluRes <= (ALUA);
				when "01111" => 				-- Write to 7-segment
					aluRes <= (ALUA);
				when "10000" => 				-- Write to SD
					aluRes <= (ALUA);
				when others =>					-- All opcodes which the ALU should do nothing. 
					aluRes <= x"0000";
			end case;
		else
			aluRes <= "ZZZZZZZZZZZZZZZZ";	-- Sets the output as a high impedanse if the ALU is disabled.
		end if;	
end process;

zeroFlag <= '1' when aluRes = x"0000" else -- Checks if output is equal to zero and sets zeroflag accordingly
				'0';
ALUOut <= aluRes; 

tempForCarry <= ('0' & ALUA) + ('0' & ALUB);		-- Checks if there is a carry by concarnating ALUA and ALUB with zero and outputs the sum.
carryFlag <= tempForCarry(16); 						-- Makes the carry flag the 16th bit of the above addition


end Behavioral;
