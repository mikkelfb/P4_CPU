library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

entity GPR is
	generic (
		B: integer := 16;		-- Number of bits in GPR
		W: integer := 3		-- Number of GPR addresses
	);
	
	port (
			addrA, addrB, addrC	: in STD_LOGIC_VECTOR(W-1 downto 0);		-- Address inputs
			dataIn					: in STD_LOGIC_VECTOR(B-1 downto 0);		-- Data input
			--En							: in STD_LOGIC; -- Not sure we should use this one? 
			EnWr						: in STD_LOGIC;									-- Write enable input
			clk						: in STD_LOGIC;									--clock input

			ALUA, ALUB				: out STD_LOGIC_VECTOR(B-1 downto 0)		-- Outputs to ALU
	);
end GPR;


architecture Behavioral of GPR is
	type GPR_type is array (2**W-1 downto 0) of		-- Create an array of 8 GPR registers that contains 16 bit of data
		STD_LOGIC_VECTOR(B-1 downto 0);
	signal array_reg: GPR_type;							-- Create a signal that enables references to the GPR addresses
begin
	
	process (clk)
	begin
		if (rising_edge(clk)) then
			if EnWr = '1' then
				array_reg(to_integer(unsigned(AddrC))) <= dataIn;		-- If write is enabled then write dataIn to addrC on a rising edge
			end if;
		end if;
	end process;
	
	ALUA <= array_reg(to_integer(unsigned(addrA)));						-- Output whatever addrA points to, to ALUA
	ALUB <= array_reg(to_integer(unsigned(addrB)));						-- Output whatever addrB points to, to ALUB

end Behavioral;
