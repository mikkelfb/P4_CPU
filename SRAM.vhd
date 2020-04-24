library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

entity SRAM is
	generic (
		B: integer := 16;
		W:	integer := 7
	);
	
	port (
		addr			: 	in STD_LOGIC_VECTOR(W-1 downto 0);
		dataInOut	:	inout STD_LOGIC_VECTOR(B-1 downto 0);
		en				:	in STD_LOGIC;
		enWr			:	in STD_LOGIC;
		clk			:	in STD_LOGIC
		
	);
end SRAM;

Architecture behavior of SRAM is
	type SRAM_type is array (2**W-1 downto 0) of 
		STD_LOGIC_VECTOR(B-1 downto 0);
	signal array_reg : SRAM_type := (others => x"0000");
	
	signal dataIn	: STD_LOGIC_VECTOR(B-1 downto 0);
	signal dataOut	: STD_LOGIC_VECTOR(B-1 downto 0);
	signal store	: STD_LOGIC_VECTOR(B-1 downto 0);
begin
		
		dataOut <= array_reg(to_integer(unsigned(addr)));
		
		array_reg(to_integer(unsigned(addr))) <= dataIn;
		
		dataInOut <= dataOut when enWr='1' else (others=>'Z');
		dataIn <= dataInOut;
		
		--process (clk, addr, dataInOut, enWr)
		--begin
		--	if (rising_edge(clk)) then
		--		if (enWr = '1' and en = '1') then
					
					--array_reg(to_integer(unsigned(addr))) <= dataInOut;
		--		end if;
		--	end if;
		--end process;
			
end behavior;
	