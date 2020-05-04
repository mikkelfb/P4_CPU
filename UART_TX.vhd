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
		tx_start				: in std_logic;									-- Bit that start transimitting
		sTick					: in std_logic;									-- Enable tick from the baud rate generator.
		txDoneTick			: out std_logic;									-- Tick for indicating transmitting is finished. Asserted one clock cycle after the receiving process is completed. 
		dataIn				: in std_logic_vector(DBIT-1 downto 0);	-- Data register for the transmitting data that will go out on the bus.
		tx						: out std_logic
	);
	
end UART_TX;

architecture behavioral of UART_TX is
	type state_type is (idle, start, data, stop);
	signal state_reg, state_next 	: state_type;

	signal s_reg, s_next 			: unsigned(3 downto 0);
	signal n_reg, n_next				: unsigned(2 downto 0);
	signal b_reg, b_next				: std_logic_vector(7 downto 0);
	signal tx_reg, tx_next			: std_logic;
	--signal sTick						: std_logic;
begin

	--Import the baudGenerator entity, should not be there when the combined UART is made
	--baudGenUnit : entity work.baudGenerator(behavioral)
	--	port map(clk => clk, reset=>reset, q=> open, maxTick => sTick);

	--FSMD state & data registers
	process(clk,reset)	begin
		if reset='1' then
			state_reg 	<= idle;
			s_reg 		<= (others=>'0');
			n_reg			<= (others=>'0');
			b_reg			<= (others=>'0');
			tx_reg 		<= '1';
		elsif (clk'event and clk='1') then
			state_reg 	<= state_next;
			s_reg 		<= s_next;
			n_reg 		<= n_next;
			b_reg 		<= b_next;
			tx_reg 		<= tx_next;
		end if;
	end process;

	-- next-state logic
	process(state_reg, s_reg, n_reg, b_reg, sTick, tx_reg, tx_start, dataIn)
	begin
		-- Sets next state for registers
		state_next 		<= state_reg; 
		s_next 			<= s_reg;
		n_next 			<= n_reg;
		b_next 			<= b_reg;
		tx_next 			<= tx_reg;
		txDoneTick 	<= '0';
		
		case state_reg is 									--case switches the state
			when idle => 										--When the state is idle
				tx_next <= '1';								--Set tx to 1 as there is no signal to send in idle state
				if tx_start = '1' then						--If tx_start (start new transmission) is set high
					state_next <= start;						--Set state to start
					s_next <= (others=>'0');				
					b_next <= dataIn;							--set "sending" bit register to dataIn
				end if;
			when start =>										--When the state is start
				tx_next <= '0';								--Set tx to 0 as the start signal is a 0 "bit" frame
				if(sTick = '1') then							--Test if there is a sTick signal
					if s_reg = 15 then						--If there have been 15 sTick signales the Start signal 0 is done
						state_next <= data;					--Set next state to data state
						s_next <= (others=> '0');
						n_next <= (others=> '0');
					else
						s_next <= s_reg + 1;					--Count s_reg up until 15 sTick signal have been recieved
					end if;
				end if;
			when data =>										--When the state is data
				tx_next <= b_reg(0);							--Sets the tx to be the first bit in the b_reg (sending byte register)
				if (sTick = '1') then						--Test if there is a sTick signal
					if (s_reg = 15) then						--If there have been 15 sTick signales 1 bit have been transmitted
						s_next <= (others=>'0');			-- set sTick to 0
						b_next <= '0' & b_reg(7 downto 1); --concatinate '0' with the 7 downto 1 bit in B_reg -> eg. if b_reg is (11101110) then the b_nex will be ("0"1110111)
						if (n_reg = (DBIT-1)) then				--Test if all bits have been transmitted
							state_next <= stop;				--sets next state to stop
						else
							n_next <= n_reg+1;				--Increase the n_reg by one
						end if;
					else
						s_next <= s_reg+1;					--Count s_reg up until 15 sTick signal have been recieved
					end if;
				end if;
			when stop =>										--When the state is stop
				tx_next <= '1';								--Set the tx to 1 to generate stop signal
				if (sTick = '1') then						--Test if there is a sTick signal
					if s_reg = (SB_TICK-1) then			--Test if there have been enough sTick signals for the stop signal
						state_next <= idle;					--Sets next state to idle
						txDoneTick <= '1';					--Sets done tick high
					else
						s_next <= s_reg + 1;
					end if;
				end if;
			end case;
		end process;
		tx <= tx_reg;
	
end behavioral;	
	
