LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity binaryBCD is
	generic(N: positive :=16);
	port(
		clk, reset: in std_logic;
		binaryIn: in std_logic_vector(N-1 downto 0);
		bcd0, bcd1, bcd2, bcd3, bcd4: out std_logic_vector(3 downto 0)
	);
end binaryBCD;
	
architecture behaviour of binaryBCD is
	type states is (start, shift, done);
	signal state, stateNext: states;
	signal binary, binaryNext: std_logic_vector(N-1 downto 0);
	signal bcds, bcdsReg, bcdsNext: std_logic_vector(19 downto 0);
	signal bcdsOutReg, bcdsOutRegNext: std_logic_vector (19 downto 0);
	signal shiftCounter, shiftCounterNext: natural range 0 to N;
	
begin
	process(clk, reset)
	begin
		if reset = '1' then
			binary <= (others => '0');
			bcds <= (others => '0');
			state <= start;
			bcdsOutReg <= (others => '0');
			shiftCounter <= 0;
		elsif rising_edge(clk) then
			binary<=binaryNext
			bcds<=bcdsNext
			state<=stateNext;
			bcdsOutReg <= bcdsOutRegNext;
			shiftCounter <= shiftCounterNext;
		end if;
	end process;
	
	convert:
	process(state, binary, binaryIn, bcds, bcdsReg, shiftCounter)
	begin
		stateNext <= state;
		bcds <= bcdsNext;
		binaryNext <= binary;
		shiftCounterNext <= shiftCounter
		
		case state is
			when start =>
				stateNext <= shift;
				binaryNext<=binaryIn;
				bcdsNext <=(others=>'0');
				shiftCounterNext <='0';
			when shift =>
				if shiftCounter = N then
					stateNext <= done;
				else
					binaryNext <= binary(N-2 downto 0) & 'L';
					bcdsNext <= bcdsReg(18 downto 0) & binary(N-1);
					shiftCounterNext <= shiftCounter +1;
				end if;
			when done =>
				stateNext <= start;
		end case;
	end process;

	bcdsReg(19 downto 16) <= bcds(19 downto 16) +3 when bcds (19 downto 16) > 4 else bcds (19 downto 16);
	bcdsReg(15 downto 12) <= bcds(15 downto 12) +3 when bcds (15 downto 12) > 4 else bcds (15 downto 12);
	bcdsReg(11 downto 8) <= bcds(11 downto 8) +3 when bcds (11 downto 8) > 4 else bcds (11 downto 8);
	bcdsReg(7 downto 4) <= bcds(7 downto 4) +3 when bcds (7 downto 4) > 4 else bcds (7 downto 4);
	bcdsReg(3 downto 0) <= bcds(3 downto 0) +3 when bcds (3 downto 0) > 4 else bcds (3 downto 0);

	bcdsOutRegNext <= bcds when state = done else bcdsOutReg;

	bcds4 <= bcdsOutReg(19 downto 16);
	bcds3 <= bcdsOutReg(15 downto 12);
	bcds2 <= bcdsOutReg(11 downto 8);
	bcds1 <= bcdsOutReg(7 downto 4);
	bcds0 <= bcdsOutReg(3 downto 0);

end behaviour;



