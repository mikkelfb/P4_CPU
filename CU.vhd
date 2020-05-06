LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


entity CU is
	port (
		state					: 	out std_logic_vector(1 downto 0);
		clk, reset			:	in std_logic;
		opCode				:	in std_logic_vector(4 downto 0);
		SRAMEnInstr			:	out std_logic;
		SRAMEn				:	out std_logic;
		SRAMEnWr				:	out std_logic;
		EnPC					:	out std_logic;
		BranchEn				:	out std_logic;
		BranchUartEn		: 	out std_logic;
		BranchEnLatch		:	out std_logic;
		IDEn					:	out std_logic;
		IDEnWr				:	out std_logic;
		GPREnWr				:	out std_logic;
		EnALU					:	out std_logic;
		EnSSEG				:	out std_logic;
		UARTEnREAD			: 	out std_logic;
		UARTEnWrite			:  out std_logic;
		UARTEnRemoveRxBuf	:	out std_logic;
		PCLoadEn				:	out std_logic
	);
end CU;

Architecture behavioral of CU is

	type stateType is (fetch, decode, execute);
	signal stateReg, stateNext: stateType;
	
	signal opCodeReg: std_logic_vector(4 downto 0);
	signal EnCU:		std_logic;
	
	begin
	
		process(clk)
		begin
			if (rising_edge(clk)) then
				stateReg <= stateNext;
			end if;
		end process;
		
		
		
		process(stateReg, stateNext, opCodeReg)
		begin
		
			stateNext <= stateReg;
			SRAMEnInstr <= '0';
			SRAMEn <= '0';
			SRAMEnWr <= '0';
			EnPC <= '0';
			BranchEn <= '0';
			BranchEnLatch <= '0';
			IDEn <= '0';
			IDEnWr <= '0';
			GPREnWr <= '0';
			EnALU <= '0';
			EnSSEG <= '0';
			UARTEnREAD <= '0';
			UARTEnWrite <= '0';
			UARTEnRemoveRxBuf <= '0';
			PCLoadEn <= 'Z';
			BranchUartEn <= '0';
			
			case stateReg is
				when fetch =>
					SRAMEnInstr <= '1';
					SRAMEn <= '1';
					EnPC <= '1';
					IDEn <= '1';
					IDEnWr <= '1';
					stateNext <= decode;
					state <= "00";
				when decode =>
					SRAMEnInstr <= '0';
					SRAMEn <= '0';
					EnPC <= '0';
					IDEn <= '1';
					IDEnWr <= '0';
					EnCU <= '1';
					stateNext <= execute;
					state <= "01";
				when execute =>
					state <= "10";
					case opCodeReg is
						when "00000" => --NOP
							IDEn <= '1';
						when "00001" => --LAS
							SRAMEn <= '1';
							IDEn <= '1';
							GPREnWr <= '1';
						when "00010" => --SKR
							SRAMEn <= '1';
							SRAMEnWr <= '1';
							IDEn <= '1';
							EnALU <= '1';
						when "00011" => --STO
							--BranchEn <= '1';
							BranchEnLatch <= '1';
							IDEn <= '1';
							GPREnWr <= '1';
							EnALU <= '1';
						when "00100" => --MIN
							--BranchEn <= '1';
							BranchEnLatch <= '1';
							IDEn <= '1';
							GPREnWr <= '1';
							EnALU <= '1';
						when "00101" => --LIG
							--BranchEn <= '1';
							BranchEnLatch <= '1';
							IDEn <= '1';
							GPREnWr <= '1';
							EnALU <= '1';
						when "00110" => --AND
							--BranchEn <= '1';
							BranchEnLatch <= '1';
							IDEn <= '1';
							GPREnWr <= '1';
							EnALU <= '1';
						when "00111" => --ORR
							--BranchEn <= '1';
							BranchEnLatch <= '1';
							IDEn <= '1';
							GPREnWr <= '1';
							EnALU <= '1';
						when "01000" => --ADD
							IDEn <= '1';
							GPREnWr <= '1';
							EnALU <= '1';
						when "01001" => --SUB
							IDEn <= '1';
							GPREnWr <= '1';
							EnALU <= '1';
						when "01010" => --DIV
							IDEn <= '1';
							GPREnWr <= '1';
							EnALU <= '1';
						when "01011" => --MUL
							IDEn <= '1';
							GPREnWr <= '1';
							EnALU <= '1';
						when "01100" => --HOP
							PCLoadEn <= '1';
							--EnPC <= '1';
							IDEn <= '1';
						when "01101" => --UAL
							IDEn <= '1';
							GPREnWr <= '1';
							UARTEnREAD <= '1';
							UARTEnRemoveRxBuf <= '1';
							UARTEnWrite <= '0';
						when "01110" => --UAS
							IDEn <= '1';
							EnALU <= '1';
							UARTEnREAD <= '0';
							UARTEnRemoveRxBuf <= '0';
							UARTEnWrite <= '1';
						when "01111" => --VIS
							IDEn <= '1';
							EnALU <= '1';
							EnSSEG <= '1';
						when "10001" => --HOPC
							--EnPC <= '1';
							BranchEn <= '1';
							IDEn <= '1';
						when "10010" => --HOPUC
							BranchUartEn <= '1';
							IDEn <= '1';
						when others =>
							SRAMEnInstr <= '0';
							SRAMEn <= '0';
							SRAMEnWr <= '0';
							EnPC <= '0';
							BranchEn <= '0';
							BranchEnLatch <= '0';
							IDEn <= '0';
							IDEnWr <= '0';
							GPREnWr <= '0';
							EnALU <= '0';
							EnSSEG <= '0';
						end case;
						stateNext <= fetch;
			end case;
		end process;
		
		process(opCodeReg, clk, EnCU)
		begin
			
			if (rising_edge(clk) and EnCU = '1') then
				opCodeReg <= opCode;
			end if;
		
		end process;
	
end behavioral;
			
	
	