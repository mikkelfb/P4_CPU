library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

entity SRAM is
	generic (
		B: integer := 16;		-- Number of bits in SRAM
		W: integer := 7		-- Number of SRAM addresses
	);
	
	port (
			addr						: in STD_LOGIC_VECTOR(W-1 downto 0);			-- Address inputs
			dataInOut				: inout STD_LOGIC_VECTOR(B-1 downto 0);		-- Data input & output
			En							: in STD_LOGIC;										-- Enable
			EnWr						: in STD_LOGIC;										-- Write enable input
			clk						: in STD_LOGIC											--clock input

	);
end SRAM;


architecture Behavioral of SRAM is
	type SRAM_type is array (2**W-1 downto 0) of		-- Create an array of 127 SRAM registers that contains 16 bit of data
		STD_LOGIC_VECTOR(B-1 downto 0);
	signal array_reg			: SRAM_type;				-- Create a signal that enables references to the SRAM addresses
	signal addrPointer		: Integer;					-- For making addr to integer
begin

	addrPointer <= to_integer(unsigned(addr));
	
	
	-- Process for writing to the ram
	process (clk, dataInOut, En, EnWr, addrPointer)
	begin
		if (rising_edge(clk)) then
			if (EnWr = '1' and En = '1') then
				array_reg(addrPointer) <= dataInOut;		-- If write is enabled then write dataIn to addrC on a rising edge
			end if;
		end if;
	end process;
	
	dataInOut <= array_reg(addrPointer) when (En = '1' and EnWr = '0') else (others=>'Z'); --Makes tri state buffer on output, enabled when En = 1 and EnWr = 0
end Behavioral;
