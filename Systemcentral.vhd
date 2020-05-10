LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity systemcentral is 
	port(
		inPutclk	: in std_logic;
		--WE should make port connections for UART and screen here
		--Uart connections
		UARTRX : in std_logic;
		UARTTX : out std_logic;
		clkOut : out std_logic;
		debugLightOut	: out std_logic_vector(8 downto 0);
		debugSwitchIn	: in std_Logic_vector(9 downto 0);

		
		SevenSegHex0		: out std_logic_vector(7 downto 0);
		SevenSegHex1		: out std_logic_vector(7 downto 0);
		SevenSegHex2		: out std_logic_vector(7 downto 0);
		SevenSegHex3		: out std_logic_vector(7 downto 0);
		SevenSegHex4		: out std_logic_vector(7 downto 0);
		SevenSegHex5		: out std_logic_vector(7 downto 0)
	);
end systemcentral;


Architecture behavioral of systemcentral is
	--reset
	signal reset : std_logic;
	
	--Opcode line
	signal opCode											: std_logic_vector(4 downto 0);
	
	
	--InstructionCode line
	signal instructionCode								: std_logic_vector(14 downto 0);
	
	--Enable lines
	signal SRAMEnWr										: std_logic;
	signal PCEn												: std_logic;
	signal BranchEn, BranchEnLatch					: std_logic;
	signal BranchUartEn									: std_logic;
	signal IDEn, IDEnWr									: std_logic;
	signal GPREnWr											: std_logic;
	signal EnALU											: std_logic;
	signal EnSSEG											: std_logic;
	
	signal SRAMCtr											: std_logic;
	
	signal loadPC											: std_logic;
	signal rxEmpty											: std_logic;
	
	
	signal UARTEnREAD										: std_logic;
	signal UARTEnRemoveRxBuf							: std_logic;
	signal UARTEnWrite									: std_logic;
	
	signal debugState										: std_logic_vector(1 downto 0);
	
	--address lines
	signal addrRegA										: std_logic_vector(2 downto 0);
	signal addrRegB										: std_logic_vector(2 downto 0);
	signal addrRegC										: std_logic_vector(2 downto 0);
	signal addrNewPC										: std_logic_vector(6 downto 0);
	signal addrSRAMPC										: std_logic_vector(6 downto 0);
	signal addrSRAMID										: std_logic_vector(6 downto 0);
	
	
	--Data flags (ALU)
	signal carryFlag										: std_logic;
	signal zeroFlag										: std_logic;
	
	--Data line
	signal dataLineIn										: std_logic_vector(15 downto 0);
	signal dataSRAMOut									: std_logic_vector(15 downto 0);
	
	
	signal dataALUA										: std_logic_vector(15 downto 0);
	signal dataALUB										: std_logic_vector(15 downto 0);
	
	
	--Seven segment connections
	signal sevenSegCon			:  std_logic_vector(7 downto 0);
	signal sevenSegAnodeCon		:  std_logic_vector(5 downto 0);
	
	
	signal clk : std_logic;
	signal clkCounter : unsigned(24 downto 0) := (others=>'0');
	
begin
	process(clk , inPutclk)
	begin
		if(rising_edge(inPutclk)) then
			clkCounter <= clkCounter + 1;
		end if;
	end process;
	clk <=	'1' when clkCounter(24) = '1' else
				'0'; 
	
	PCUnit : entity work.PC(Behavioral)
		port map(
			clk 		=> clk,
			reset 	=> reset,
			load 		=> loadPC,
			enPc 		=> PCEn,
			sramAddr => addrSRAMPC,
			branchIn => addrNewPC);
	
	SRAMUnit : entity work.SRAMVHead(Behavioral)
		port map(
			clk => clk,
			EnWrite => SRAMEnWr,
			SRAMaddrControl => SRAMCtr,
			addrFromID => addrSRAMID,
			addrFromPC => addrSRAMPC,
			dataIn => dataLineIn,
			dataout => dataSRAMOut,
			InstructionOut => instructionCode);
	
	debugLightOut(7 downto 0) <= dataSRAMOut(7 downto 0);
	PCEn <= debugSwitchIn(0);
	
	
	--SevenSegHex0	<= "11111111";
	--SevenSegHex1	<= "00000000";
	--SevenSegHex2	<= "00000000";
	--SevenSegHex3	<= "00000000";
	--SevenSegHex4	<= "00000000";
	--SevenSegHex5	<= "00000000";
	
--	SevenSegHex0 <=  sevenSegCon when sevenSegAnodeCon = "111110" else (others=>'1');
--	SevenSegHex1 <=  sevenSegCon when sevenSegAnodeCon = "111101" else (others=>'1');
--	SevenSegHex2 <=  sevenSegCon when sevenSegAnodeCon = "111011" else (others=>'1');
--	SevenSegHex3 <=  sevenSegCon when sevenSegAnodeCon = "110111" else (others=>'1');
--	SevenSegHex4 <=  sevenSegCon when sevenSegAnodeCon = "101111" else (others=>'1');
--	SevenSegHex5 <=  sevenSegCon when sevenSegAnodeCon = "011111" else (others=>'1');
	clkOut <= clk;
end behavioral;