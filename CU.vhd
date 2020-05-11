LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


entity CU is
	port (
		--Debug state output for testing
		state					: 	out std_logic_vector(2 downto 0);
		--clock
		clk					:	in std_logic;
		--Opcode input
		opCode				:	in std_logic_vector(4 downto 0);
		--SRAM control signals
		SRAMaddrCtr			:	out std_logic;
		SRAMEnWr				:	out std_logic;
		--Program counter signal
		EnPC					:	out std_logic;
		loadFromCU			:	out std_logic;
		loadFromBranch		: 	out std_logic;
		--Branch control signal
		BranchEn				:	out std_logic;
		BranchUartEn		: 	out std_logic;
		BranchEnLatch		:	out std_logic;
		--Instruction decoder control signals
		IDEnWr				:	out std_logic;
		--GPR control signal
		GPREnWr				:	out std_logic;
		--7-segment display control signals
		EnSSEG				:	out std_logic;
		--UART control signals
		UARTRemoveRxBuf	: 	out std_logic; 
		UARTEnWrite			:  out std_logic;
		--Reset signals
		resetIn				: 	in std_logic;
		resetOut				: 	out std_logic;
		--Databus control
		DataBusCtr			: out std_logic_vector(1 downto 0)
	);
end CU;

Architecture behavioral of CU is

	type stateType is (start, fetch, decode, execute, writeBack);
	signal stateReg, stateNext: stateType := start;
	
	signal opCodeReg: std_logic_vector(4 downto 0);
	signal CUWr:		std_logic;
	
	begin
	
		process(clk, resetIn)
		begin
			if resetIn = '1' then
				stateReg <= start;
			elsif (rising_edge(clk)) then
				stateReg <= stateNext;
			end if;
		end process;
		
		process(stateReg, stateNext, opCodeReg)
		begin
			--Set all signals to deafual 0
			stateNext 		<= stateReg;
			resetOut 		<= '0';
			SRAMaddrCtr 	<= '0';
			SRAMEnWr 		<= '0';
			EnPC 				<= '0';
			loadFromCU 		<= '0';
			BranchEn 		<= '0';
			BranchUartEn 	<= '0';
			BranchEnLatch 	<= '0';
			IDEnWr			<= '0';
			GPREnWr			<= '0';
			EnSSEG			<= '0';
			UARTRemoveRxBuf<= '0';
			UARTEnWrite		<= '0';
			resetOut			<= '0';
			CUWr				<= '0';
			DataBusCtr		<= "00";
			state				<= "000";
			case stateReg is
				when start =>
					resetOut <= '1';
					stateNext <= fetch;
					state <= "000";
				when fetch =>
					EnPC <= '1';
					SRAMaddrCtr <= '1';
					stateNext <= decode;
					state <= "001";
				when decode =>
					IDEnWr <= '1';
					CUWr <= '1';
					stateNext <= execute;
					state <= "010";
				when execute =>
					case opCodeReg is
						when "00000" => --NOP
						when "00001" => --LAS
							DataBusCtr <= "01"; --Read from SRAM 
						when "00010" => --SKR
							SRAMEnWr <= '1';
							DataBusCtr <= "10"; --Read from ALU
						when "00011" => --STO
							DataBusCtr <= "10"; --Read from ALU
							BranchEnLatch <= '1'; --Latch zero for all alu operations.
						when "00100" => --MIN
							DataBusCtr <= "10"; --Read from ALU
							BranchEnLatch <= '1';
						when "00101" => --LIG
							DataBusCtr <= "10"; --Read from ALU
							BranchEnLatch <= '1';
						when "00110" => --AND
							DataBusCtr <= "10"; --Read from ALU
							BranchEnLatch <= '1';
						when "00111" => --ORR
							DataBusCtr <= "10"; --Read from ALU
							BranchEnLatch <= '1';
						when "01000" => --ADD
							DataBusCtr <= "10"; --Read from ALU
							BranchEnLatch <= '1';
						when "01001" => --SUB
							DataBusCtr <= "10"; --Read from ALU
							BranchEnLatch <= '1';
						when "01010" => --DIV
							DataBusCtr <= "10"; --Read from ALU
							BranchEnLatch <= '1';
						when "01011" => --MUL
							DataBusCtr <= "10"; --Read from ALU
							BranchEnLatch <= '1';
						when "01100" => --HOP
							loadFromCU <= '1'; --Loads the PC with address from ID
						when "01101" => --UAL
							DataBusCtr <= "11"; --Read from UART RX buff
						when "01110" => --UAS
							DataBusCtr <= "10"; --Read from ALU
						when "01111" => --VIS
							DataBusCtr <= "10"; --Read from ALU
						when "10001" => --HOPC
							branchEn <= '1';
						when "10010" => --HOPUC
							branchUartEn <= '1';
						when others =>
					end case;
					stateNext <= writeBack;
					state <= "011";
				when writeBack =>
					case opCodeReg is
						when "00000" => --NOP
						when "00001" => --LAS
							GPREnWr <= '1';
							DataBusCtr <= "01"; --Read from SRAM 
						when "00010" => --SKR
							DataBusCtr <= "10"; --Read from ALU
						when "00011" => --STO
							GPREnWr <= '1';
							DataBusCtr <= "10"; --Read from ALU
						when "00100" => --MIN
							GPREnWr <= '1';
							DataBusCtr <= "10"; --Read from ALU
						when "00101" => --LIG
							GPREnWr <= '1';
							DataBusCtr <= "10"; --Read from ALU
						when "00110" => --AND
							GPREnWr <= '1';
							DataBusCtr <= "10"; --Read from ALU
						when "00111" => --ORR
							GPREnWr <= '1';
							DataBusCtr <= "10"; --Read from ALU
						when "01000" => --ADD
							GPREnWr <= '1';	
							DataBusCtr <= "10"; --Read from ALU
						when "01001" => --SUB
							GPREnWr <= '1';
							DataBusCtr <= "10"; --Read from ALU
						when "01010" => --DIV
							GPREnWr <= '1';
							DataBusCtr <= "10"; --Read from ALU
						when "01011" => --MUL
							GPREnWr <= '1';
							DataBusCtr <= "10"; --Read from ALU
						when "01100" => --HOP
						when "01101" => --UAL
							GPREnWr <= '1';
							DataBusCtr <= "11"; --Read from UART RX buff
							UARTRemoveRxBuf <= '1';
						when "01110" => --UAS
							UARTEnWrite <= '1';
							DataBusCtr <= "10"; --Read from ALU
						when "01111" => --VIS
							EnSSEG <= '1';
							DataBusCtr <= "10"; --Read from ALU
						when "10001" => --HOPC
						when "10010" => --HOPUC
						when others =>
					end case;
					stateNext <= fetch;
					state <= "100";
			end case;
		end process;
		
		process(opCodeReg, clk, CUWr)
		begin
			if(resetIn = '1') then
				opCodeReg <= (others=>'0');
			elsif (rising_edge(clk) and CUWr = '1') then
				opCodeReg <= opCode;
			end if;
		end process;
	
end behavioral;
			
	
	