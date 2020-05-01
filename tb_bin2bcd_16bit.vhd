-- Inspired by the 12-bit implementation from the double dabble wiki: https://en.wikipedia.org/wiki/Double_dabble

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity tb_bin2bcd_16bit is
end tb_bin2bcd_16bit;

Architecture behavioral of tb_bin2bcd_16bit is


	-- Component Declaration for the Unit Under Test (UUT)

	COMPONENT bin2bcd_16bit
	PORT(
		binIN : IN  std_logic_vector(15 downto 0);
		bcd0 : OUT  std_logic_vector(3 downto 0);
		bcd1 : OUT  std_logic_vector(3 downto 0);
		bcd2 : OUT  std_logic_vector(3 downto 0);
		bcd3 : OUT  std_logic_vector(3 downto 0);
		bcd4 : OUT 	std_logic_vector(3 downto 0)
		  );
	 END COMPONENT;
	 
	-- WARNING: Please, notice that there is no need for a clock signal in the testbench, since the design is strictly
	--    combinational (or concurrent, in contrast to the C implementation which is sequential).
	-- This clock is here just for simulation; you can omit all clock references and process, and use "wait for ... ns"
	--    statements instead.

	--Inputs
	signal binIN : std_logic_vector(15 downto 0) := (others => '0');
	signal clk : std_logic := '0';  -- can be omitted

	--Outputs
	signal bcd0 : std_logic_vector(3 downto 0);
	signal bcd1 : std_logic_vector(3 downto 0);
	signal bcd2 : std_logic_vector(3 downto 0);
	signal bcd3 : std_logic_vector(3 downto 0);
	signal bcd4 : std_logic_vector(3 downto 0);

	-- Clock period definitions
	constant clk_period : time := 10 ns;  -- can be omitted

	-- Miscellaneous
	signal full_number : std_logic_vector(19 downto 0);

	BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: bin2bcd_16bit PORT MAP (
		binIN => binIN,
		bcd0 => bcd0,
		bcd1 => bcd1,
		bcd2 => bcd2,
		bcd3 => bcd3,
		bcd4 => bcd4
	);

	-- Clock process definitions  -- the whole process can be omitted
	process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process;

	-- Combine signals for full number
	full_number <= bcd4 & bcd3 & bcd2 & bcd1 & bcd0;

	-- Stimulus process
	process
	begin		
		-- hold reset state for 100 ns.
		wait for 100 ns;	

		wait for clk_period*10;

		-- insert stimulus here 
		-- should return 40095
		binIN <= X"FFFF";
		wait for clk_period*10;  assert full_number = x"40095" severity error;  -- use "wait for ... ns;"

		-- should return 0
		binIN <= X"0000";
		wait for clk_period*10;  assert full_number = x"00000" severity error;

		-- should return 27480
		binIN <= X"ABCD";
		wait for clk_period*10;  assert full_number = x"27480" severity error;
		
		
		wait;
	end process;


end behavioral;