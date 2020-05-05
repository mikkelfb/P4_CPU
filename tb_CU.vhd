LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity tb_CU is
end tb_CU;

Architecture behavioral of tb_CU is

	component CU
	port (
		clk, reset		:	in std_logic;
		opCode			:	in std_logic_vector(4 downto 0);
		SRAMEnInstr		:	out std_logic;
		SRAMEn			:	out std_logic;
		SRAMEnWr			:	out std_logic;
		EnPC				:	out std_logic;
		BranchEn			:	out std_logic;
		BranchEnLatch	:	out std_logic;
		IDEn				:	out std_logic;
		IDEnWr			:	out std_logic;
		GPREnWr			:	out std_logic;
		EnALU				:	out std_logic;
		EnSSEG			:	out std_logic
	);
	end component;
	
	signal	clk, reset		: std_logic;
	signal	opCode			: std_logic_vector(4 downto 0);
	signal	SRAMEnInstr		: std_logic;
	signal	SRAMEn			: std_logic;
	signal	SRAMEnWr			: std_logic;
	signal	EnPC				: std_logic;
	signal	BranchEn			: std_logic;
	signal	BranchEnLatch	: std_logic;
	signal	IDEn				: std_logic;
	signal	IDEnWr			: std_logic;
	signal	GPREnWr			: std_logic;
	signal	EnALU				: std_logic;
	signal	EnSSEG			: std_logic;
	
	constant T: time := 20 ns;
	
	begin
	
	uut: CU port map (
		clk => clk,
		reset => reset,
		opCode => opCode,
		SRAMEnInstr => SRAMEnInstr,
		SRAMEn => SRAMEn,
		SRAMEnWr => SRAMEnWr,
		EnPC => EnPC,
		BranchEn => BranchEn,
		BranchEnLatch => BranchEnLatch,
		IDEn => IDEn,
		IDEnWr => IDEnWr,
		GPREnWr => GPREnWr,
		EnALU => EnALU,
		EnSSEG => EnSSEG
	);
	
	process
	begin
		clk <= '0';
		wait for T/2;
		clk <= '1';
		wait for T/2;
	end process;
	
	process
	begin
		opCode <= "01010";
		for i in 0 to 3 loop
			wait until rising_edge(clk);
			wait until rising_edge(clk);
			wait until rising_edge(clk);
			opcode <= opcode + "00001";
		end loop;
	end process;
	
end behavioral;

		