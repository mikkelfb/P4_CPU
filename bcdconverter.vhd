LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bcdconverter is
	generic(N: positive :=16); --N is declared 16, as we are dealing with a 16-bit number
	port(
		clk, reset: in std_logic;
		binaryIn: in std_logic_vector(N-1 downto 0); --The input 16-bit number
		bcd0, bcd1, bcd2, bcd3, bcd4: out std_logic_vector(3 downto 0) --the output for the 4 decimals, in bcd
	);
end bcdconverter;
	
architecture behaviour of bcdconverter is
	type states is (start, shift, done); --defines a type of state machine with 3 states.
	signal state, stateNext: states;		--creates a signal from the statemachine to store 1 of the 3 states.
	signal binary, binaryNext: std_logic_vector(N-1 downto 0); --
	signal bcds, bcdsReg, bcdsNext: std_logic_vector(19 downto 0);
	signal bcdsOutReg, bcdsOutRegNext: std_logic_vector (19 downto 0);
	signal shiftCounter, shiftCounterNext: natural range 0 to N;
	
begin
	process(clk, reset) --start a process to reset if it needs to, and count the shift register if it needs to.
	begin
		if (reset = '1') then --indicates that a reset needs to happen
			binary <= (others => '0'); --reset the binary signal
			bcds <= (others => '0'); --reset the bcds signal
			state <= start; --put the statemachine in the start state
			bcdsOutReg <= (others => '0'); --fill the bcdsOutReg with zeroes, ready to be shifted.
			shiftCounter <= 0; --reset the shiftCounter signal
		elsif rising_edge(clk) then --activates at the regular enterval of rising edge (clk)
			binary <= binaryNext; --Binary is set to binary next.
			bcds <= bcdsNext;	--bcds is set to bcds next.
			state <= stateNext; --state is set to stateNext.
		--	bcdsOutReg <= bcdsOutRegNext; --bcdsOutReg is set to bcdsOutRegNext.
			shiftCounter <= shiftCounterNext; --Counts up the shiftCounter (shiftCounterNext should at this point be shiftCounter +1)
		end if;
	end process;
	
	convert:
	process(state, binary, binaryIn, bcds, bcdsReg, shiftCounter)
	begin								--start conditions are set.
		stateNext <= state;
		bcds <= bcdsNext;
		binaryNext <= binary;
		shiftCounterNext <= shiftCounter;
		
		case state is --statemachine instructions
			when start => --state: start. happens when reset input is '1' or after state done
				stateNext <= shift; --declares the next state is shift
				binaryNext <= binaryIn; --sets binaryNext to binaryIn.
				bcdsNext <= (others=>'0'); --fills bcdsNext with zeroes ready to be shifted
				shiftCounterNext <=0; --resets the shiftCounterNext. Note that shiftCounter is resat when reset input is '1'
			when shift => --state: shift happens after start and after shift, unless shiftCounter has reached N.
				if shiftCounter = N then --checks if shifCounter is equal to N, if yes goes to the state done.
					stateNext <= done;
				else  						--if shiftCounter is not yet N
					binaryNext <= binary(N-2 downto 0) & 'L'; --shifts the input left by concatinating with a '0' on the right.
					bcdsNext <= bcdsReg(18 downto 0) & binary(N-1); --shifts the output by concatinating with the new binary.
					shiftCounterNext <= shiftCounter +1; --makes the shiftCounterNext equal to shiftCounter +1. This is used to make the shiftCounter count.
				end if;
			when done => --the state done, simply goes to state start.
				stateNext <= start;
		end case;
	end process;

	
	--blabla !!REVISIT COMMENT!!
	bcdsReg(19 downto 16) <= bcds(19 downto 16) + 3 when bcds(19 downto 16) > 4 else bcds(19 downto 16);
	bcdsReg(15 downto 12) <= bcds(15 downto 12) + 3 when bcds(15 downto 12) > 4 else bcds(15 downto 12);
	bcdsReg(11 downto 8) <= bcds(11 downto 8) + 3 when bcds(11 downto 8) > 4 else bcds(11 downto 8);
	bcdsReg(7 downto 4) <= bcds(7 downto 4) + 3 when bcds(7 downto 4) > 4 else bcds(7 downto 4);
	bcdsReg(3 downto 0) <= bcds(3 downto 0) + 3 when bcds(3 downto 0) > 4 else bcds(3 downto 0);

	bcdsOutRegNext <= bcds when state = done else bcdsOutReg;

	--sets the outputs as the 5 individual bcds
	bcd4 <= bcdsOutReg(19 downto 16);
	bcd3 <= bcdsOutReg(15 downto 12);
	bcd2 <= bcdsOutReg(11 downto 8);
	bcd1 <= bcdsOutReg(7 downto 4);
	bcd0 <= bcdsOutReg(3 downto 0);
	
end behaviour;