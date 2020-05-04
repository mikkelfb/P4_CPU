-- This file is inspired by "FPGA PRototyping by VHDL Examples Xilinx Spartan 3"
-- By Pong P. Chu
-- It is an adobtion from listing 7.3

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- The UART RX component of the UART is implemented as a finite state machine.
-- The following states is used in the FSM: idle, start, data, stop.

-- The UART RX component of the UART uses oversampling to determine the state of the FSM.
-- Each clock cycle is divided into 16 pieces. 
-- To identify the start state, the oversampling mechanism counts from 0 to 7 when the line is pulled low.
-- By doing this, it is possible to identify when the middle of a clock cycle has been reached. The counter is then reset
-- When the start bit has been received, the next 8 bits will be data. By then counting to 16 and resetting, it is possible to determine
-- the middle of each of the data bits. Which are then shifted and stored in a register. 


entity UART_TX is
	generic (
		DBIT: 	integer := 8;		-- Number of data bits.
		SB_TICK: integer := 16		-- Numbers of ticks needed for the stop bits. Set to 16 since we are using 1 stop bit. 
	);
	
	port (
		clk, reset			: in std_logic;									-- Clock and reset functions.
		txStart				: in std_logic;									-- Bit that start transimitting
		sTick					: in std_logic;									-- Enable tick from the baud rate generator.
		txDoneTick			: out std_logic;									-- Tick for indicating transmitting is finished. Asserted one clock cycle after the receiving process is completed. 
		dataIn				: in std_logic_vector(DBIT-1 downto 0);	-- Data register for the transmitting data that will go out on the bus.
		tx						: out std_logic
	);
	
end UART_TX;

architecture behavioral of UART_TX is
	type stateType is (idle, start, data, stop);
	signal stateReg, stateNext 	: stateType;

	signal sReg, sNext 				: unsigned(3 downto 0);
	signal nReg, nNext				: unsigned(2 downto 0);
	signal bReg, bNext				: std_logic_vector(7 downto 0);
	signal txReg, txNext				: std_logic;
	--signal sTick						: std_logic;
begin

	--Import the baudGenerator entity, should not be there when the combined UART is made
	--baudGenUnit : entity work.baudGenerator(behavioral)
	--	port map(clk => clk, reset=>reset, q=> open, maxTick => sTick);

	--FSMD state & data registers
	process(clk,reset)	begin
		if reset='1' then
			stateReg 	<= idle;
			sReg 		<= (others=>'0');
			nReg			<= (others=>'0');
			bReg			<= (others=>'0');
			txReg 		<= '1';
		elsif (clk'event and clk='1') then
			stateReg 	<= stateNext;
			sReg 		<= sNext;
			nReg 		<= nNext;
			bReg 		<= bNext;
			txReg 		<= txNext;
		end if;
	end process;

	-- next-state logic
	process(stateReg, sReg, nReg, bReg, sTick, txReg, txStart, dataIn)
	begin
		-- Sets next state for registers
		stateNext 		<= stateReg; 
		sNext 			<= sReg;
		nNext 			<= nReg;
		bNext 			<= bReg;
		txNext 			<= txReg;
		txDoneTick 	<= '0';
		
		case stateReg is 									--case switches the state
			when idle => 										--When the state is idle
				txNext <= '1';								--Set tx to 1 as there is no signal to send in idle state
				if txStart = '1' then						--If txStart (start new transmission) is set high
					stateNext <= start;						--Set state to start
					sNext <= (others=>'0');				
					bNext <= dataIn;							--set "sending" bit register to dataIn
				end if;
			when start =>										--When the state is start
				txNext <= '0';								--Set tx to 0 as the start signal is a 0 "bit" frame
				if(sTick = '1') then							--Test if there is a sTick signal
					if sReg = 15 then						--If there have been 15 sTick signales the Start signal 0 is done
						stateNext <= data;					--Set next state to data state
						sNext <= (others=> '0');
						nNext <= (others=> '0');
					else
						sNext <= sReg + 1;					--Count sReg up until 15 sTick signal have been recieved
					end if;
				end if;
			when data =>										--When the state is data
				txNext <= bReg(0);							--Sets the tx to be the first bit in the bReg (sending byte register)
				if (sTick = '1') then						--Test if there is a sTick signal
					if (sReg = 15) then						--If there have been 15 sTick signales 1 bit have been transmitted
						sNext <= (others=>'0');			-- set sTick to 0
						bNext <= '0' & bReg(7 downto 1); --concatinate '0' with the 7 downto 1 bit in bReg -> eg. if bReg is (11101110) then the b_nex will be ("0"1110111)
						if (nReg = (DBIT-1)) then				--Test if all bits have been transmitted
							stateNext <= stop;				--sets next state to stop
						else
							nNext <= nReg+1;				--Increase the nReg by one
						end if;
					else
						sNext <= sReg+1;					--Count sReg up until 15 sTick signal have been recieved
					end if;
				end if;
			when stop =>										--When the state is stop
				txNext <= '1';								--Set the tx to 1 to generate stop signal
				if (sTick = '1') then						--Test if there is a sTick signal
					if sReg = (SB_TICK-1) then			--Test if there have been enough sTick signals for the stop signal
						stateNext <= idle;					--Sets next state to idle
						txDoneTick <= '1';					--Sets done tick high
					else
						sNext <= sReg + 1;
					end if;
				end if;
		end case;
	end process;
	tx <= txReg;
	
end behavioral;	
	
