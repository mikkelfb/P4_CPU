LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity baudGenerator is
	generic (
		N: integer := 	8;
		M: integer := 	163
	);
	
	port (
		clk, reset		:	in std_logic;
		maxTick			:	out std_logic;
		q					:	out std_logic_vector(N-1 downto 0)
	);
end baudGenerator;

Architecture behavioral of baudGenerator is

	signal rReg		:	unsigned(N-1 downto 0) := (others=>'0');
	signal rNext	:	unsigned(N-1 downto 0);
	
begin
	
	process(clk, reset)
	begin
		if (reset = '1') then
			rReg <= (others=>'0');
		elsif (rising_edge(clk)) then
			rReg <= rNext;
		end if;
	end process;
	
	rNext <= (others=>'0') when rReg = (M-1) else
					rReg+1;
	
	q <= std_logic_vector(rReg);
	maxTick <= '1' when rReg = (M-1) else '0';
	
end behavioral;