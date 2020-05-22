library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

entity tb_Instruction_Decoder is 
end tb_instruction_Decoder;

architecture Behavioral of tb_Instruction_Decoder is
component Instruction_Decoder 
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
end component;

constant T: time := 20 ns; 

signal instructionCode 			: STD_LOGIC_VECTOR(14 downto 0);
signal clk 							: STD_LOGIC;
signal reset						: STD_LOGIC;
signal EnWr							: STD_LOGIC;
signal addrSRAM					: STD_LOGIC_VECTOR(6 downto 0);
signal opCodeALU					: STD_LOGIC_VECTOR(4 DOWNTO 0);
signal opCodeCU					: STD_LOGIC_VECTOR(4 DOWNTO 0);
signal addrRegA					: STD_LOGIC_VECTOR(2 downto 0);
signal addrRegB					: STD_LOGIC_VECTOR(2 downto 0);
signal addrRegC					: STD_LOGIC_VECTOR(2 downto 0);
signal addrPC						: STD_LOGIC_VECTOR(6 downto 0);
			-- Test signalos -- 
signal Test_Reg_A					:  STD_LOGIC_VECTOR(2 downto 0);
signal Test_Reg_B					:  STD_LOGIC_VECTOR(2 downto 0);
signal Test_Reg_C					:  STD_LOGIC_VECTOR(2 downto 0);
signal Test_SRAM					:  STD_LOGIC_VECTOR(6 downto 0);
signal Test_Op_Counter			:  STD_LOGIC_VECTOR(4 downto 0):="00011";

begin 

	uut: Instruction_Decoder port map(
		instructionCode => instructionCode,
		clk => clk,
		reset => reset,
		EnWr => EnWr,
		addrSRAM => addrSRAM,
		opCodeALU => opCodeALU,
		opCodeCU => opCodeCU,
		addrRegA => addrRegA,
		addrRegB => addrRegB,
		addrRegC => addrRegC,
		addrPC => addrPC
	);
	
	-- Create a process that simulates the rising and falling edge of a clock
	process
	begin
		clk <= '1';
		wait for T/2;
		clk <= '0';
		wait for T/2;
	end process;
	
	Test_Reg_A <= "001";
	Test_Reg_B <= "010";
	Test_Reg_C <= "011";
	Test_SRAM  <= "1111111";
	
	process 
	begin
		Test_Op_Counter <= "00011";
		instructionCode <= "000000000000000";
		EnWr <= '1';
		wait until rising_edge(clk);
		EnWr <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		EnWr <= '1';
		instructionCode <= Test_SRAM & Test_Reg_A & "00001";
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		instructionCode <= Test_SRAM & Test_Reg_A & "00010";
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		for i in 0 to 12 loop 
			instructionCode <= Test_Reg_C & "0" & Test_Reg_B & Test_Reg_A & Test_Op_Counter;
			wait until rising_edge(clk);
			wait until rising_edge(clk);
			Test_Op_Counter <= Test_Op_Counter + "00001";
		end loop;
		wait until rising_edge(clk);
		Test_Op_counter <= "10000";
		wait until rising_edge(clk);
		instructionCode <= "111111100110000";
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		EnWr <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
	end process;
end Behavioral;
		
