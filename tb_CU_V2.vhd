LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity tb_CU_V2 is
end tb_CU_V2;

Architecture behavioral of tb_CU_V2 is
	component CU
	port (
		state					: 	out std_logic_vector(2 downto 0);
		clk					:	in std_logic;
		opCode				:	in std_logic_vector(4 downto 0);
		SRAMaddrCtr			:	out std_logic;
		SRAMEnWr				:	out std_logic;
		EnPC					:	out std_logic;
		loadFromCU			:	out std_logic;
		loadFromBranch		: 	out std_logic;
		BranchEn				:	out std_logic;
		BranchUartEn		: 	out std_logic;
		BranchEnLatch		:	out std_logic;
		IDEnWr				:	out std_logic;
		GPREnWr				:	out std_logic;
		EnSSEG				:	out std_logic;
		UARTRemoveRxBuf	: 	out std_logic; 
		UARTEnWrite			:  out std_logic;
		resetIn				: 	in std_logic;
		resetOut				: 	out std_logic;
		DataBusCtr			:  out std_logic_vector(1 downto 0)
	);
	end component;
	
	signal state				: 	std_logic_vector(2 downto 0);
	signal clk					:	std_logic;
	signal opCode				:	std_logic_vector(4 downto 0);
	signal SRAMaddrCtr		:	std_logic;
	signal SRAMEnWr			:	std_logic;
	signal EnPC					:	std_logic;
	signal loadFromCU			:	std_logic;
	signal loadFromBranch	: 	std_logic;
	signal BranchEn			:	std_logic;
	signal BranchUartEn		: 	std_logic;
	signal BranchEnLatch		:	std_logic;
	signal IDEnWr				:	std_logic;
	signal GPREnWr				:	std_logic;
	signal EnSSEG				:	std_logic;
	signal UARTRemoveRxBuf	: 	std_logic; 
	signal UARTEnWrite		:  std_logic;
	signal resetIn				: 	std_logic:='0';
	signal resetOut			: 	std_logic;
	signal DataBusCtr			:  std_logic_vector(1 downto 0);
	
	constant T: time := 20 ns;
	
begin
	
	uut: CU port map (
		state => state,
		clk => clk,
		opCode => opCode,
		SRAMaddrCtr => SRAMaddrCtr,
		SRAMEnWr => SRAMEnWr,
		EnPC => EnPC,
		loadFromCU => loadFromCU,
		loadFromBranch => loadFromBranch,
		BranchEn => BranchEn,
		BranchUartEn => BranchUartEn,
		BranchEnLatch => BranchEnLatch,
		IDEnWr => IDEnWr,
		GPREnWr => GPREnWr,
		EnSSEG => EnSSEG,
		UARTRemoveRxBuf => UARTRemoveRxBuf,
		UARTEnWrite => UARTEnWrite,
		resetIn => resetIn,
		resetOut => resetOut,
		DataBusCtr =>DataBusCtr
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
		opCode <= "00000";
		for i in 0 to 18 loop
			wait until rising_edge(clk);
			wait until rising_edge(clk);
			wait until rising_edge(clk);
			wait until rising_edge(clk);
			opcode <= opcode + "00001";
		end loop;
	end process;
	
end behavioral;

		