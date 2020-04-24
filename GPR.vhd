library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

entity GPR is
	generic (
		B: integer := 16;
		W: integer := 3
	);
	
	port (
			addrA, addrB, addrC	: in STD_LOGIC_VECTOR(W-1 downto 0);
			dataIn					: in STD_LOGIC_VECTOR(B-1 downto 0);
			--En							: in STD_LOGIC;
			EnWr						: in STD_LOGIC;
			clk						: in STD_LOGIC;
			
			ALUA, ALUB				: out STD_LOGIC_VECTOR(B-1 downto 0)
	);
end GPR;


architecture Behavioral of GPR is
	type GPR_type is array (2**W-1 downto 0) of
		STD_LOGIC_VECTOR(B-1 downto 0);
	signal array_reg: GPR_type;
begin
	
	process (clk)
	begin
		if (rising_edge(clk)) then
			if EnWr = '1' then
				array_reg(to_integer(unsigned(AddrC))) <= dataIn;
			end if;
		end if;
	end process;
	
	ALUA <= array_reg(to_integer(unsigned(addrA)));
	ALUB <= array_reg(to_integer(unsigned(addrB)));

end Behavioral;
