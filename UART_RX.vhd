LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- The UART RX component of the UART is implemented as a finite state machine.
-- The following states is used in the FSM: idle, start, data, stop.

entity uartRx is

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
	
end uartRx;

architecture behavioral of uartRx is
	type stateType is (idle, start, data, stop);				-- Creates a new type that contains the states of the FSM.
	signal stateReg, stateNext: stateType;						-- Create the current and next state registers.
	signal sReg. sNext: unsigned(3 downto 0);					-- Create the state registers that will be counting the sampling ticks. Counts to 7 in the start state and 15 in the data state.
	signal nReg, nNext: unsigned(2 downto 0);					-- Create the register that keeps track of the number of data bits received in the data state.
	signal bReg, bNext: std_logic_vector(7 downto 0);		-- Create a bit register signal that data bits are shifted into one by one.
	
begin
	
	
