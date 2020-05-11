library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

-- Implementation of Program Counter
--
-- The Program Counter has 3 inputs and 1 output
--
-- Peram[IN] reset 1 bit to reset the rReg signal to zero
-- Param[IN] cynClr clears next instruction, which resets the program counter
-- Param[IN] load enables the PC to jump to the branchIn param
-- Param[IN] branchIn is the sramAddr which the PC jumps to
--	PARAM[IN] enPc 1 bit to make PC output SRAM_adress and increment by 1
-- PARAM[IN] branchIn is a 7 bit address
-- PARAM[OUT] sramAddr points to the next instruction in the memory
-- Param[OUT] maxTick indicates that the last sramAddr is reached
-- Param[OUT] minTick duh...


entity PC is
	generic(N: integer := 7);
	port (
		clk, reset				:		in STD_LOGIC;		
		loadCU					: 		in STD_LOGIC;
		loadBranch				:		in std_logic;
		branchIn					:		in STD_LOGIC_VECTOR(N-1 downto 0);
		enPc						: 		in STD_LOGIC;
		sramAddr					:		out STD_LOGIC_VECTOR(N-1 downto 0)
	);
end PC;

architecture Behavioral of PC is
	signal rReg: unsigned(N-1 downto 0) := (others =>'0');
	signal rNext: unsigned(N-1 downto 0);
	
begin
	-- register
	process(clk, reset)
	begin
		if (reset = '1') then
			rReg <= (others => '0');
		elsif (rising_edge(clk)) then
			rReg <= rNext;
		end if;
	end process;
	
	
	-- next-state logic
	rNext <=	(others=>'0')			when reset = '1'				else
				unsigned(branchIn)	when loadBranch = '1'		else
				unsigned(branchIn)	when loadCU = '1'				else
				rReg + 1					when enPc = '1'  				else
				rReg;
				
	-- output logic
	sramAddr <= STD_LOGIC_VECTOR(rReg);
end behavioral;
				
	
	
	
	
	
	
	
	
	
	
	
	
	
	
