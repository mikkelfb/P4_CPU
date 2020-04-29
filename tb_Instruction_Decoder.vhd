library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

entity tb_Instruction_Decoder is 
end tb_instruction_Decoder;

architecture Behavioral of tb_Instruction_Decoder is
component Instruction_Decoder 
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
end component;

constant T: time := 20 ns; 

signal Instruction_Code 		:  STD_LOGIC_VECTOR(14 downto 0);
signal clk 							:  STD_LOGIC;
signal EN_ID						:  STD_LOGIC;
signal En_Wr						:  STD_LOGIC;
signal SRAM_Addr					:  STD_LOGIC_VECTOR(6 downto 0);
signal Op_Code						:  STD_LOGIC_VECTOR(4 DOWNTO 0);
signal Reg_Addr_A					:  STD_LOGIC_VECTOR(2 downto 0);
signal Reg_Addr_B					:  STD_LOGIC_VECTOR(2 downto 0);
signal Reg_Addr_C					:  STD_LOGIC_VECTOR(2 downto 0);
			-- Test signalos -- 
signal Test_Reg_A					:  STD_LOGIC_VECTOR(2 downto 0);
signal Test_Reg_B					:  STD_LOGIC_VECTOR(2 downto 0);
signal Test_Reg_C					:  STD_LOGIC_VECTOR(2 downto 0);
signal Test_SRAM					:  STD_LOGIC_VECTOR(6 downto 0);
signal Test_Op_Counter			:  STD_LOGIC_VECTOR(4 downto 0):="00011";

begin 

	uut: Instruction_Decoder port map(
		Instruction_Code 	=> Instruction_Code,		
		clk 					=> clk, 		
		EN_ID					=>	EN_ID,
		En_Wr					=>	En_Wr,	
		SRAM_Addr			=>	SRAM_Addr,	
		Op_Code				=>	Op_Code,	
		Reg_Addr_A			=>	Reg_Addr_A,	
		Reg_Addr_B			=>	Reg_Addr_B,	
		Reg_Addr_C			=> Reg_Addr_C
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
		EN_ID <= '1';
		Instruction_Code <= "000000000000000";
		En_Wr <= '1';
		wait until rising_edge(clk);
		En_Wr <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		En_Wr <= '1';
		Instruction_Code <= Test_SRAM & Test_Reg_A & "00001";
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		Instruction_Code <= Test_SRAM & Test_Reg_A & "00010";
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		for i in 0 to 12 loop 
			Instruction_Code <= Test_Reg_C & "0" & Test_Reg_B & Test_Reg_A & Test_Op_Counter;
			wait until rising_edge(clk);
			wait until rising_edge(clk);
			Test_Op_Counter <= Test_Op_Counter + "00001";
		end loop;
		wait until rising_edge(clk);
		Test_Op_counter <= "10000";
		wait until rising_edge(clk);
		Instruction_Code <= "111111100110000";
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		En_Wr <= '0';
		EN_ID <= '0';
		wait until rising_edge(clk);
		wait until rising_edge(clk);
	end process;
end Behavioral;
		
