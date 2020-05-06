library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;
use std.textio.all;

entity SRAM is
	generic (
		B: integer := 16;		-- Number of bits in SRAM
		W: integer := 7		-- Number of SRAM addresses
	);
	
	port (
			addr						: in STD_LOGIC_VECTOR(W-1 downto 0);			-- Address inputs
			dataInOut				: inout STD_LOGIC_VECTOR(B-1 downto 0);		-- Data input & output
			addrPC					: in STD_LOGIC_VECTOR(W-1 downto 0);			-- PC adress
			En							: in STD_LOGIC;										-- Enable
			EnInstruction			: in STD_LOGIC;										-- Enable instructions
			EnWr						: in STD_LOGIC;										-- Write enable input
			clk						: in STD_LOGIC;										--clock input
			Instruction 			: out STD_LOGIC_VECTOR(14 downto 0)
	);
end SRAM;


architecture Behavioral of SRAM is
	type SRAM_type is array (2**W-1 downto 0) of		-- Create an array of 127 SRAM registers that contains 16 bit of data
		STD_LOGIC_VECTOR(B-1 downto 0);
	
	
	
	-- The function below takes a file called program.txt and reads it line by line. Then outputs the new vector with the program in it. 
	
	impure function initSRAM return SRAM_type is
		file textFile: text open read_mode is "..\..\program.txt";
		variable textLine: line;
		variable ramContent: SRAM_type;
		variable bv : bit_vector(ramContent(0)'range);
	begin
		for i in 0 to 2**W-1 loop
			readline(textFile, textLine);
			read(textLine, bv);
			ramContent(i) := to_stdlogicvector(bv);
		end loop;
		
		return ramContent;
	end function;

	-- Declare the RAM signal and specify a default value.	Quartus Prime
	-- will create a memory initialization file (.mif) based on the 
	-- default value.
	signal arrayReg			: SRAM_type := initSRAM;				-- Create a signal that enables references to the SRAM addresses
	
	
	
	signal addrPointer		: Integer;					-- For making addr to integer
	signal addrPCPointer		: Integer;
	signal InstructionTemp 	: STD_LOGIC_VECTOR(B-1 downto 0);
begin

	addrPointer <= to_integer(unsigned(addr));
	addrPCPointer <= to_integer(unsigned(addrPC));
	
	-- Process for writing to the ram
	process (clk, dataInOut, En, EnWr, addrPointer)
	begin
		if (rising_edge(clk)) then
			if (EnWr = '1' and En = '1' and EnInstruction = '0') then
				arrayReg(addrPointer) <= dataInOut;		-- If write is enabled then write dataIn to addrC on a rising edge
			end if;

		end if;
	end process;
	
	InstructionTemp <= arrayReg(addrPCPointer) when (En = '1' and EnInstruction = '1' and EnWr = '0') else (others => 'Z');
	Instruction <= InstructionTemp(14 downto 0);
	dataInOut <= arrayReg(addrPointer) when (En = '1' and EnWr = '0' and EnInstruction = '0') else (others=>'Z'); --Makes tri state buffer on output, enabled when En = 1 and EnWr = 0
end Behavioral;
