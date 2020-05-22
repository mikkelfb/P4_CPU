LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.all;


Entity tb_ALU IS
END tb_ALU;

Architecture behavior of tb_ALU IS

	COMPONENT ALU
	PORT(
		opCode						:	in STD_LOGIC_VECTOR(4 downto 0);
		ALUA							:	in STD_LOGIC_VECTOR(15 downto 0);
		ALUB							:	in STD_LOGIC_VECTOR(15 downto 0);
		ALUOut						:	out STD_LOGIC_VECTOR(15 downto 0);
		zeroFlag, carryFlag		: 	out STD_LOGIC
	);
	END COMPONENT;
	
	signal ALUA 					: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
   signal ALUB 					: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
   signal opCode 					: STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
	signal carryFlag, zeroFlag	: STD_LOGIC;
	

  --Outputs
   signal ALUOut : STD_LOGIC_VECTOR(15 downto 0);
	
	BEGIN
	
	uut: ALU PORT MAP(
		ALUA 			=> ALUA,
		ALUB 			=> ALUB,
		ALUOut 		=> ALUOut,
		opCode 		=> opCode,
		carryFlag	=> carryFlag,
		zeroFlag		=> zeroFlag
	);
	
	process
	begin
		
		-- Test OPCODE 00010 -> letting A pass 
		ALUA <= x"00AA";
		ALUB <= x"00BB";
		opCode <= "00010";
		wait for 10 ns;
		
		-- Test OPCODE 00011 -> A > B -> 1
		ALUA <= x"00AA";
		ALUB <= x"0011";
		opCode <= "00011";
		wait for 10 ns;
		
		-- Test OPCODE 00011 -> A > B -> 0
		ALUA <= x"0011";
		ALUB <= x"00BB";
		opCode <= "00011";
		wait for 10 ns;
		
		-- Test OPCODE 00100 -> A < B -> 1
		ALUA <= x"0011";
		ALUB <= x"00BB";
		opCode <= "00100";
		wait for 10 ns;
		
		-- Test OPCODE 00100 -> A < B -> 0
		ALUA <= x"00AA";
		ALUB <= x"0011";
		opCode <= "00100";
		wait for 10 ns;
		
		
		-- Test OPCODE 00101 -> A = B -> 1
		ALUA <= x"0011";
		ALUB <= x"0011";
		opCode <= "00101";
		wait for 10 ns;
		
		-- Test OPCODE 00101 -> A = B -> 0
		ALUA <= x"00AA";
		ALUB <= x"0011";
		opCode <= "00101";
		wait for 10 ns;
		
		-- Test OPCODE 00110 -> A bitwise AND B
		ALUA <= x"00FF";
		ALUB <= x"FFFF";
		opCode <= "00110";
		wait for 10 ns;
		
		-- Test OPCODE 00111 -> A bitwise OR B
		ALUA <= x"0F0F";
		ALUB <= x"F00F";
		opCode <= "00111";
		wait for 10 ns;
		
		-- Test OPCODE 01000 -> addition 1 + 1 (HALLO WORLD!)
		ALUA <= x"0001";
		ALUB <= x"0001";
		opCode <= "01000";
		wait for 10 ns;
		
		-- Test OPCODE 01000 -> addition 0xFFFF + 0x0001 = 0x0001 + carry
		ALUA <= x"FFFF";
		ALUB <= x"0001";
		opCode <= "01000";
		wait for 10 ns;
		
		-- Test OPCODE 01001 -> subtraction 2 - 1 
		ALUA <= x"0005";
		ALUB <= x"0001";
		opCode <= "01001";
		wait for 10 ns;
		
		-- Test OPCODE 01010 -> division 6 / 2 = 3
		ALUA <= x"0006";
		ALUB <= x"0002";
		opCode <= "01010";
		wait for 10 ns;
		
		-- Test OPCODE 01011 -> multiplication 6 * 2 = 12
		ALUA <= x"0006";
		ALUB <= x"0002";
		opCode <= "01011";
		wait for 10 ns;
		
		-- Test OPCODE 01110 -> Write to UART let A through
		ALUA <= x"0006";
		ALUB <= x"0002";
		opCode <= "01110";
		wait for 10 ns;
		
		-- Test OPCODE 01111 -> Write to 7-segment let A through
		ALUA <= x"0006";
		ALUB <= x"0002";
		opCode <= "01111";
		wait for 10 ns;
	end process;
end behavior;