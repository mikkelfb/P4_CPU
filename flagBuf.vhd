LIBRARY ieee;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

entity flagBuf is
	generic (
		W: integer := 8
	);
	
	port (
		clk, reset			:	in std_logic;
		clrFlag, setFlag	:	in std_logic;
		dataIn				:	in std_logic_vector(W-1 downto 0);
		dataOut				: 	out std_logic_vector(W-1 downto 0);
		flag					:	out std_logic
	);
end flagBuf;

Architecture behavioral of flagBuf is

	signal bufReg, bufNext		:	std_logic_vector(W-1 downto 0);
	signal flagReg, flagNext	:	std_logic;
begin
	-- FF & Register
	process(clk, reset)
	begin
		if reset = '1' then
			bufReg <= (others=>'0');
			flagReg <= '0';
		elsif (rising_edge(clk)) then
			bufReg <= bufNext;
			flagReg <= flagNext;
		end if;
	end process;
		
	process(bufReg, flagReg, setFlag, clrFlag, dataIn)
	begin
		bufNext <= bufReg;
		flagNext <= flagReg;
		if (setFlag = '1') then
			bufNext <= dataIn;
			flagNext <= '1';
		elsif (clrFlag = '1') then
			flagNext <= '0';
		end if;
	end process;
	
	-- Output Logic
	
	dataOut <= bufReg;
	flag <= flagReg;
end behavioral;