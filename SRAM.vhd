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
	
	
	
	--attribute ram_init_file : string;
	--attribute ram_init_file of arrayReg : signal is "my_init_file.hex";
	
	
	function initSram
		return SRAM_type is 
		variable tmp : SRAM_type := (others => (others => '0'));
	begin 
		for addr_pos in 0 to 2**W - 1 loop 
			-- Initialize each address with the address itself
			tmp(addr_pos) := std_logic_vector(to_unsigned(addr_pos, B));
		end loop;
		tmp(0) := "0000000000000000";
		tmp(1) := "0011001000100001";
		tmp(2) := "0011001101000001";
		tmp(3) := "0011000101001000";
		tmp(4) := "0100000101001001";
		tmp(5) := "0000000000101111";
		tmp(6) := "0011001011000001"; --LOAD GPR addr 6 with 45
		tmp(7) := "0011001011100001"; --LOAD GPR addr 7 with 45
		tmp(8) := "0101011111000100"; -- Evaluate addr 7 < 6
		tmp(9) := "0000000000010001"; --HOPC to line 0.
	
		tmp(50) 	:= "0000000000101101";
		tmp(51) 	:= "0000000100101100";
		return tmp;
	end initSram;	 

	-- Declare the RAM signal and specify a default value.	Quartus Prime
	-- will create a memory initialization file (.mif) based on the 
	-- default value.
	signal arrayReg			: SRAM_type :=initSram;				-- Create a signal that enables references to the SRAM addresses
	
	
	
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
