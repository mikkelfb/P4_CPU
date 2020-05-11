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
	signal reset : std_logic := '0';
	signal resetFromCU : std_logic;
	signal resetInCu	 : std_logic := '0';
	
	--Opcode line
	signal opCodeALU										: std_logic_vector(4 downto 0);
	signal opCodeCU										: std_logic_vector(4 downto 0);
	
	--InstructionCode line
	signal instructionCode								: std_logic_vector(14 downto 0);
	
	--Enable lines
	signal SRAMEnWr										: std_logic;
	signal PCEn												: std_logic;
	
	signal BranchEn										: std_logic;
	signal BranchEnLatch									: std_logic;
	signal BranchUartEn									: std_logic;
	
	signal IDEnWr											: std_logic;
	signal GPREnWr											: std_logic;
	signal EnSSEG											: std_logic;
	
	signal dataBusCtr										: std_logic_vector(1 downto 0);
	
	signal SRAMCtr											: std_logic;
	
	signal loadFromCU										: std_logic;
	signal loadFromBranch								: std_logic;
	signal rxEmpty											: std_logic;
	
	signal UARTEnRemoveRxBuf							: std_logic;
	signal UARTEnWrite									: std_logic;
	signal UARTTxFull										: std_logic;
	
	signal debugState										: std_logic_vector(2 downto 0);
	
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
	signal dataSRAMOut									: std_logic_vector(15 downto 0);
	signal fromDataBus									: std_logic_vector(15 downto 0);
	signal dataALUOut										: std_logic_vector(15 downto 0);
	signal dataUARTOut									: std_logic_vector(15 downto 0);
	
	signal dataALUA										: std_logic_vector(15 downto 0);
	signal dataALUB										: std_logic_vector(15 downto 0);
	
	
	--Seven segment connections
	signal sevenSegCon			:  std_logic_vector(7 downto 0);
	signal sevenSegAnodeCon		:  std_logic_vector(5 downto 0);
	
	
	signal clk : std_logic;
	signal clkCounter : unsigned(22 downto 0) := (others=>'0');
	
begin
--clock slowdown for FPGA testing
	clkOut <= clk;
	process(clk , inPutclk)
	begin
		if(rising_edge(inPutclk)) then
			clkCounter <= clkCounter + 1;
		end if;
	end process;
	clk <=	'1' when clkCounter(22) = '1' else
				'0'; 
	
--	clk<= inPutclk;
	
	reset <= resetFromCU;
	
	--Program coutner unit
	PCUnit : entity work.PC(Behavioral)
		port map(
			clk 			=> clk,
			reset 		=> reset,
			loadCU 		=> loadFromCU,
			loadBranch	=> loadFromBranch,
			enPc 			=> PCEn,
			sramAddr 	=> addrSRAMPC,
			branchIn 	=> addrNewPC);
	
	--SRAM unit
	SRAMUnit : entity work.SRAMVHead(Behavioral)
		port map(
			clk => clk,
			EnWrite => SRAMEnWr,
			SRAMaddrControl => SRAMCtr,
			addrFromID => addrSRAMID,
			addrFromPC => addrSRAMPC,
			dataIn => fromDataBus,
			dataout => dataSRAMOut,
			InstructionOut => instructionCode);
	
	--Instruction decoder unit
	IDUnit : entity work.Instruction_Decoder(Behavioral)
		port map(
			clk 					=> clk,
			reset					=> reset,
			EnWr 					=> IDEnWr,
			instructionCode 	=> instructionCode,
			addrSRAM 			=> addrSRAMID,
			opCodeALU			=> opCodeALU,
			opCodeCU				=> opCodeCU,
			addrPC				=> addrNewPC,
			addrRegA				=> addrRegA,
			addrRegB				=> addrRegB,
			addrRegC				=> addrRegC);
	
	--Control unit unit
	CUUnit : entity work.CU(behavioral)
		port map(
			state 				=> debugState,
			clk 					=> clk,
			opCode 				=> opCodeCU,
			SRAMaddrCtr 		=> SRAMCtr,
			SRAMEnWr 			=> SRAMEnWr,
			EnPC 					=> PCEn,
			loadFromCU 			=> loadFromCU,
			BranchEn 			=> BranchEn,
			BranchUartEn 		=> BranchUartEn,
			BranchEnLatch 		=> BranchEnLatch,
			IDEnWr 				=> IDEnWr,
			GPREnWr 				=> GPREnWr,
			EnSSEG 				=> EnSSEG,
			UARTRemoveRxBuf 	=> UARTEnRemoveRxBuf,
			UARTEnWrite 		=> UARTEnWrite,
			resetIn 				=> resetInCu,
			resetOut 			=> resetFromCU,
			DataBusCtr 			=> dataBusCtr);
	
	-- General purpose register
	GPRUnit : entity work.GPR(Behavioral)
		port map(
			reset		=> reset,
			addrA 	=> addrRegA,
			addrB 	=> addrRegB,
			addrC 	=> addrRegC,
			dataIn 	=> fromDataBus,
			EnWr		=> GPREnWr,
			clk		=> clk,
			ALUA		=> dataALUA,
			ALUB		=> dataALUB);

	-- ALU unit
	ALUUnit	: entity work.ALU(Behavioral)
		port map(
			opCode 		=> opCodeALU,
			ALUA			=> dataALUA,
			ALUB			=> dataALUB,
			ALUOut		=> dataALUOut,
			zeroFlag		=> zeroFlag,
			carryFlag	=> carryFlag);
	
	--Databus unit
	DataBusUnit	: entity work.DataBus(Behavioral)
		port map(
		clk		=> clk,
		reset		=> reset,
		Ctr		=> dataBusCtr,
		SRAMIn	=> dataSRAMOut,
		ALUIn		=> dataALUOut,
		UARTIn	=> dataUARTOut,
		dataOut	=> fromDataBus);
	
	--Branch control Unit 
	BranchUnit	: entity work.Branching_Control(Behavioral)
		port map(
			CarryFlag 	=> carryFlag,
			ZeroFlag		=> zeroFlag,
			En				=> BranchEn,
			EnLatchALU	=> BranchEnLatch,
			EnUart		=> BranchUartEn,
			PCControl	=> loadFromBranch,
			UartBranch	=> rxEmpty);
	
	
	-- 7-segment display
	SevenSegmentDisp : entity work.dispHexMux(arch)
		port map(
			clk	=> clk, 
			reset	=> reset,
			dpIn  => (others=>'0'),
			binIN => fromDataBus,
			en		=> EnSSEG,
			an		=> sevenSegAnodeCon,
			sseg 	=> sevenSegCon);

	-- UART
	UARTUnit	:	entity work.UART(behavioral)
		port map(
			clk 				=> clk,
			reset 			=> reset,
			rx 				=> UARTRX,
			tx 				=> UARTTX,
			remDataRxBuf 	=> UARTEnRemoveRxBuf,
			wrUart 			=> UARTEnWrite,
			txFull 			=> UARTTxFull,
			rxEmpty 			=> rxEmpty,
			dataIn 			=> fromDataBus,
			dataOut 			=>dataUARTOut
		);
	
	
	
	debugLightOut(7 downto 0) 	<= dataALUOut(7 downto 0);
	
--	SevenSegHex0 <=	"1000000" when debugState = "000" else
--							"1111001" when debugState = "001" else
--							"0100100" when debugState = "010" else
--							"0110000" when debugState = "011" else
--							"0011001" when debugState = "100" else
--							"1111111";
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
	
end behavioral;