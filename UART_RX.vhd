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


entity UART_RX is
	generic (
		DBIT: 	integer := 8;		-- Number of data bits.
		SB_TICK: integer := 16		-- Numbers of ticks needed for the stop bits. Set to 16 since we are using 1 stop bit. 
	);
	
	port (
		clk, reset	: in std_logic;									-- Clock and reset functions.
		rx				: in std_logic;									-- Bit that is received and will be shifted into the register.
		sTick			: in std_logic;									-- Enable tick from the baud rate generator.
		rxDoneTick	: out std_logic;									-- Tick for indicating receive is finished. Asserted one clock cycle after the receiving process is completed. 
		dataOut		: out std_logic_vector(DBIT-1 downto 0)	-- Data register for the received data that will go out on the bus.
	);
	
end UART_RX;

architecture behavioral of UART_RX is
	type stateType is (idle, start, data, stop);				-- Creates a new type that contains the states of the FSM. States created: idle, start, data, stop.
	signal stateReg, stateNext: stateType;						-- Create the current and next state registers.
	signal sReg, sNext: unsigned(3 downto 0);					-- Create the state registers that will be counting the sampling ticks. Counts to 7 in the start state and 15 in the data state.
	signal nReg, nNext: unsigned(2 downto 0);					-- Create the register that keeps track of the number of data bits received in the data state.
	signal bReg, bNext: std_logic_vector(7 downto 0);		-- Create a bit register signal that data bits are shifted into one by one.
	--signal sTick		: std_logic;
begin

	--baudGenUnit : entity work.baudGenerator(behavioral)
	--	port map(clk => clk, reset=>reset, q=> open, maxTick => sTick);


	-- FSM state & data registers
	process (clk, reset)
	begin
		if reset = '1' then								-- If reset is pressed then
			stateReg <= idle;								-- State goes to idle
			sReg <= (others=>'0');						-- sReg is set to all 0's
			nReg <= (others=>'0');						-- nReg is set to all 0's
			bReg <= (others=>'0');						-- bReg is set to all 0's
		elsif (rising_edge(clk)) then					-- If theres is a rising edge on the clock
			stateReg <= stateNext;						-- Current state is set to the next state
			sReg <= sNext;									-- The state counting register is set to the next count
			nReg <= nNext;									-- The number of data bits register is set to the next count
			bReg <= bNext;									-- The register that stores the bits is set to the next one.
		end if;
	end process;
	
	-- Next-state logic & data path functional units/routing
	
	process (stateReg, sReg, nReg, bReg, sTick, rx)
	begin
		stateNext <= stateReg;
		sNext <= sReg;
		nNext <= nReg;
		bNext <= bReg;
		rxDoneTick <= '0';
		
		case stateReg is
			when idle =>											-- Case if the current state is 'idle'
				if (rx = '0') then								-- If the rx bit is set to 0
					stateNext <= start;							-- Set the next state to be the start state
					sNext <= (others=>'0');						-- Set the sNext tick counter to all 0's. This makes sure that the counter is reset for when going into the start state.
				end if;
			when start =>											-- Case if the current state is 'start'
				if (sTick = '1') then							-- If there is an enable tick from the baud generator
					if sReg = 7 then								-- If the start bit has been identified
						stateNext <= data;						-- Set the next state to the 'data' state
						sNext <= (others=>'0');					-- Reset the sNext register
						nNext <= (others=>'0');					-- Reset the nNext register. This clears so it can be utiliezed in the 'data' state
					else 
						sNext <= sReg + 1;						-- If the start bit has not yet been identified. Count the tick one up. 
					end if;
				end if;
			when data =>											-- Case if the current state is 'data'
				if (sTick = '1') then							-- If there is an enable tick from the baud generator
					if sReg = 15 then								-- If the counter has reached the middle of the clock cycle.
						sNext <= (others=>'0');					--	Reset the clock cycle tick counter
						bNext <= rx & bReg(7 downto 1);		-- Shift the current bit into the register for storage
						if nReg = (DBIT-1) then					-- If there are no more data bits
							stateNext <= stop;					-- Set the state to 'stop'
						else											-- If there are more data bits
							nNext <= nReg + 1;					-- Count up the register that contains the number of bits that has been cycled through.
						end if;										
					else
						sNext <= sReg + 1;						-- Count up the clock cycle tick register
					end if;
				end if;
			when stop =>											-- Case if the current state is 'stop'
				if (sTick = '1') then							-- If there is an enable tick from the baud generator
					if sReg = (SB_TICK - 1) then				-- If the number of stop ticks has been reached
						stateNext <= idle;						-- Set the next state to 'idle'
						rxDoneTick <= '1';						-- Send a signal saying the receive is done
					else												-- If the number of stop ticks has not been reached
						sNext <= sReg + 1;						-- Count up the clock cycle tick register. 
					end if;
				end if;
		end case;
	end process;
	
	dataOut <= bReg;
	
end behavioral;	
	
