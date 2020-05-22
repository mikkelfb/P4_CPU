library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

entity tb_SRAMVHead is
end tb_SRAMVHead;

architecture Behavioral of tb_SRAMVHead is
component SRAMVHead
	port(
		clk 					: in std_logic;
		EnWrite				: in std_logic;
		SRAMaddrControl	: in std_logic; -- 0 = ID, 1 = PC
		addrFromID			: in std_logic_vector(6 downto 0);
		addrFromPC			: in std_logic_vector(6 downto 0);
		dataIn				: in std_logic_vector(15 downto 0);
		dataout				: out std_logic_vector(15 downto 0);
		InstructionOut		: out std_logic_vector(14 downto 0)
	);
end component;
	
	constant T: time := 20 ns;	

	signal clk 						:  std_logic;
	signal EnWrite					:  std_logic;
	signal SRAMaddrControl		:  std_logic; -- 0 = ID, 1 = PC
	signal addrFromID				:  std_logic_vector(6 downto 0);
	signal addrFromPC				:  std_logic_vector(6 downto 0);
	signal dataIn					:  std_logic_vector(15 downto 0);
	signal dataout					:  std_logic_vector(15 downto 0);
	signal InstructionOut		:  std_logic_vector(14 downto 0);
	
	signal addrCounter				: std_logic_vector(6 downto 0):= (others=>'0');
	
begin

	uut : SRAMVHead port map(
		clk	=> clk,
		EnWrite => EnWrite,
		SRAMaddrControl => SRAMaddrControl,
		addrFromID => addrFromID,
		addrFromPC => addrFromPC,
		dataIn => dataIn,
		dataout => dataout,
		InstructionOut => InstructionOut
	);
	
	process
		begin
			clk <= '0';
			wait for T/2;
			clk <= '1';
			wait for T/2;
	end process;
	
	process
	begin
		--Test writing to SRAM 
		EnWrite <= '1'; --Enable write
		SRAMaddrControl <= '0'; --FROM ID
		for i in 0 to 127 loop
			addrFromID <= addrCounter;
			dataIn <= "000000000" & addrCounter;
			addrCounter <= addrCounter + "0000001";	
			wait until falling_edge(clk);	
		end loop;
		EnWrite <= '0';
		wait until falling_edge(clk);	
		wait until falling_edge(clk);	
		--Loop through all SRAM to check if output is correct
		addrCounter <= "0000000";
		for i in 0 to 127 loop
			addrFromID <= addrCounter;
			addrCounter <= addrCounter + "0000001";	
			wait until falling_edge(clk);	
		end loop;
		wait until falling_edge(clk);	
		wait until falling_edge(clk);
		--Test if able to read with Instruction address
		SRAMaddrControl <= '1';
		addrFromPC <= "0000100";
		wait until falling_edge(clk);
	end process;
end Behavioral;

