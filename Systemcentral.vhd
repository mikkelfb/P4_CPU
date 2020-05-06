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
		stateOut : out std_logic_vector(1 downto 0);
		opCodeOut : out std_logic_vector(4 downto 0);
		
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
	signal SRAMEnInstr, SRAMEn, SRAMEnWr			: std_logic;
	signal EnPC												: std_logic;
	signal BranchEn, BranchEnLatch					: std_logic;
	signal BranchUartEn									: std_logic;
	signal IDEn, IDEnWr									: std_logic;
	signal GPREnWr											: std_logic;
	signal EnALU											: std_logic;
	signal EnSSEG											: std_logic;
	
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
	signal addrSRAM										: std_logic_vector(6 downto 0);
	signal addrSRAMInstruction							: std_logic_vector(6 downto 0);
	
	
	--Data flags (ALU)
	signal carryFlag										: std_logic;
	signal zeroFlag										: std_logic;
	
	--Data line
	signal dataLine										: std_logic_vector(15 downto 0);
	
	signal dataALUA										: std_logic_vector(15 downto 0);
	signal dataALUB										: std_logic_vector(15 downto 0);
	
	
	--Seven segment connections
	signal sevenSegCon			:  std_logic_vector(7 downto 0);
	signal sevenSegAnodeCon		:  std_logic_vector(5 downto 0);
	
	
	signal clk : std_logic;
	signal clkCounter : unsigned(22 downto 0) := (others=>'0');
	
begin
	--Control unit
	CUUnit : entity work.CU(behavioral)
		port map(	clk => clk , reset=> reset , opCode =>opCode ,
						SRAMEnInstr => SRAMEnInstr , SRAMEn => SRAMEn , SRAMEnWr => SRAMEnWr,
						EnPC => EnPC , BranchEn => BranchEn , BranchEnLatch => BranchEnLatch, BranchUartEn => BranchUartEn,
						IDEn => IDEn , IDEnWr => IDEnWr , GPREnWr => GPREnWr , 
						EnALU => EnALU , EnSSEG => EnSSEG, PCLoadEn => loadPC ,
						UARTEnREAD => UARTEnREAD , UARTEnWrite => UARTEnWrite , UARTEnRemoveRxBuf => UARTEnRemoveRxBuf ,
						state=> debugState , resetOut=>reset);

	--Instruction decoder
	IDunit : entity work.Instruction_Decoder(Behavioral)
		port map(	clk => clk , instructionCode => instructionCode , EnID => IDEn , 
						EnWr => IDEnWr , addrSRAM => addrSRAM , opCode => opCode ,
						addrRegA => addrRegA , addrRegB => addrRegB ,
						addrRegC => addrRegC , addrPC => addrNewPC);
						
	--SRAM
	SRAMunit : entity work.SRAM(Behavioral)
		port map( 	clk => clk , addr => addrSRAM , Instruction => instructionCode ,
						addrPC => addrSRAMInstruction , dataInOut => dataLine ,
						En => SRAMEn , EnInstruction => SRAMEnInstr , EnWr => SRAMEnWr);
						
	--Program counter
	PCunit 	: entity work.PC(Behavioral)
		port map( 	clk => clk, reset => reset , synClr => '0' , 
						load => loadPC , branchIn => addrNewPC , enPc => EnPC ,
						sramAddr => addrSRAMInstruction);-- Quartus Prime VHDL Template
	
	--GPR
	GPRUnit	: entity work.GPR(Behavioral)
		port map(	clk => clk , EnWr => GPREnWr , 
						addrA => addrRegA , addrB => addrRegB , addrC => addrRegC ,
						dataIn => dataLine , ALUA => dataALUA , ALUB => dataALUB);
	
	--ALU
	ALUUnit	: entity work.ALU(Behavioral)
		port map(	EnALU => EnALU , opCode => opCode ,
						ALUA => dataALUA , ALUB => dataALUB ,
						ALUOut => dataLine , zeroFlag => zeroFlag , 
						carryFlag => carryFlag);
	
	--7-segment display
	dispHexMuxUnit	: entity work.dispHexMux(arch)
		port map(	clk => clk , reset => reset,
						dpIn => "000000" , binIn => dataLine ,
						en => EnSSEG , sseg => sevenSegCon, an => sevenSegAnodeCon);
	
	--Branching control
	BranchingControlUnit : entity work.Branching_Control(Behavioral)
		port map(	CarryFlag => carryFlag , ZeroFlag => zeroFlag,
						En => BranchEn , EnLatchALU => BranchEnLatch ,
						PCControl => loadPC , EnUart => BranchUartEn ,UartBranch => rxEmpty);
	
	--UART
	UARTUnit : entity work.UART(behavioral)
		port map(	clk => clk , reset => reset ,
						rx => UARTRX , tx => UARTTX , remDataRxBuf => UARTEnRemoveRxBuf ,
						rdUart => UARTEnREAD , wrUart => UARTEnWrite , dataInOut => dataLine , rxEmpty => rxEmpty);
	
	
	
	process(clk , inPutclk)
	begin
		if(rising_edge(inPutclk)) then
			clkCounter <= clkCounter + 1;
		end if;
	end process;
	clk <=	'1' when clkCounter(22) = '1' else
				'0'; 
	
	
	--SevenSegHex0	<= "11111111";
	--SevenSegHex1	<= "00000000";
	--SevenSegHex2	<= "00000000";
	--SevenSegHex3	<= "00000000";
	--SevenSegHex4	<= "00000000";
	--SevenSegHex5	<= "00000000";
	
	SevenSegHex0 <=  sevenSegCon when sevenSegAnodeCon = "111110" else (others=>'1');
	SevenSegHex1 <=  sevenSegCon when sevenSegAnodeCon = "111101" else (others=>'1');
	SevenSegHex2 <=  sevenSegCon when sevenSegAnodeCon = "111011" else (others=>'1');
	SevenSegHex3 <=  sevenSegCon when sevenSegAnodeCon = "110111" else (others=>'1');
	SevenSegHex4 <=  sevenSegCon when sevenSegAnodeCon = "101111" else (others=>'1');
	SevenSegHex5 <=  sevenSegCon when sevenSegAnodeCon = "011111" else (others=>'1');
	clkOut <= clk;
	stateOut <= debugState;
	opCodeOut <= opCode;
end behavioral;

--	clk, reset				: 	in std_logic;
--	rx							: 	in std_logic; -- Port for rx connector
--	tx							: 	out std_logic; --Port for tx connector
--	remDataRxBuf			: 	in std_logic; 
--	rdUart					: 	in std_logic;
--	wrUart					:	in std_Logic; --Set if we wnt to read or write from UART module 
--	txFull, rxEmpty		: 	out std_logic; --Set according to FIFO bufferes
--	dataInOut				: 	inout std_logic_vector(15 downto 0)

--	CarryFlag 				: in STD_LOGIC;
--	ZeroFlag 				: in STD_LOGIC;
--	En							: in STD_LOGIC;
--	EnLatch					: in STD_LOGIC;
--	PCControl 				: out STD_LOGIC

--	clk, reset: in std_logic;
--	dpIn: in std_logic_vector (5 downto 0);
--	binIN: in std_logic_vector(15 downto 0);
--	en:	in std_logic;
--	sseg : out std_logic_vector ( 7 downto 0)

-- ALU:
--	xopCode						:	in STD_LOGIC_VECTOR(4 downto 0);
--	xALUA							:	in STD_LOGIC_VECTOR(15 downto 0);
--	xALUB							:	in STD_LOGIC_VECTOR(15 downto 0);
--	xALUOut						:	out STD_LOGIC_VECTOR(15 downto 0);
--	xEnAlu						: 	in STD_LOGIC;
--	xzeroFlag, carryFlag		: 	out STD_LOGIC


--	xaddrA, addrB, addrC	: in STD_LOGIC_VECTOR(W-1 downto 0);		-- Address inputs
--	xdataIn					: in STD_LOGIC_VECTOR(B-1 downto 0);		-- Data input
--	--En							: in STD_LOGIC; -- Not sure we should use this one? 
--	xEnWr						: in STD_LOGIC;									-- Write enable input
--	xclk						: in STD_LOGIC;									--clock input
--
--	xALUA, ALUB				: out STD_LOGIC_VECTOR(B-1 downto 0)		-- Outputs to ALU

--	Program counter
--	clk, reset				:		in STD_LOGIC;		
--	synClr, load			: 		in STD_LOGIC;			
--	branchIn					:		in STD_LOGIC_VECTOR(N-1 downto 0);
--	enPc						: 		in STD_LOGIC;
--	sramAddr					:		out STD_LOGIC_VECTOR(N-1 downto 0);
--	maxTick, minTick		:		out STD_LOGIC 

-- SRAM
--	xaddr							: in STD_LOGIC_VECTOR(W-1 downto 0);			-- Address inputs
--	dataInOut					: inout STD_LOGIC_VECTOR(B-1 downto 0);		-- Data input & output
--	xaddrPC						: in STD_LOGIC_VECTOR(W-1 downto 0);			-- PC adress
--	xEn							: in STD_LOGIC;										-- Enable
--	xEnInstruction				: in STD_LOGIC;										-- Enable instructions
--	xEnWr							: in STD_LOGIC;										-- Write enable input
--	xclk							: in STD_LOGIC;										--clock input
--	xInstruction 				: out STD_LOGIC_VECTOR(14 downto 0)

-- ID:
--port(
--			instructionCode 			: in STD_LOGIC_VECTOR(14 downto 0);
--			clk 							: in STD_LOGIC;
--			EnID							: in STD_LOGIC;
--			EnWr							: in STD_LOGIC;
--			addrSRAM						: out STD_LOGIC_VECTOR(6 downto 0);
--			opCode						: out STD_LOGIC_VECTOR(4 DOWNTO 0);
--			addrRegA						: out STD_LOGIC_VECTOR(2 downto 0);
--			addrRegB						: out STD_LOGIC_VECTOR(2 downto 0);
--			addrRegC						: out STD_LOGIC_VECTOR(2 downto 0);
--			addrPC						: out STD_LOGIC_VECTOR(6 downto 0)
--	);

--CU:
--		clk, reset		:	in std_logic;
--		opCode			:	in std_logic_vector(4 downto 0);
--		SRAMEnInstr		:	out std_logic;
--		SRAMEn			:	out std_logic;
--		SRAMEnWr			:	out std_logic;
--		EnPC				:	out std_logic;
--		BranchEn			:	out std_logic;
--		BranchEnLatch	:	out std_logic;
--		IDEn				:	out std_logic;
--		IDEnWr			:	out std_logic;
--		GPREnWr			:	out std_logic;
--		EnALU				:	out std_logic;
--		EnSSEG			:	out std_logic