library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

entity tb_PC is 
end entity;

architecture behavioral of tb_PC is

	component PC
	port (
		clk, reset				:		in STD_LOGIC;		
		synClr, load			: 		in STD_LOGIC;			
		branchIn					:		in STD_LOGIC_VECTOR(7-1 downto 0);
		enPc						: 		in STD_LOGIC;
		sramAddr					:		out STD_LOGIC_VECTOR(7-1 downto 0);
		maxTick, minTick		:		out STD_LOGIC 
	);
	end component;
	
	constant T: time := 20 ns;
	
	signal clk, reset			:		 STD_LOGIC;
	signal synClr, load		: 		 STD_LOGIC;
	signal branchIn			: 		 STD_LOGIC_VECTOR(7-1 downto 0);
	signal enPc					: 		 STD_LOGIC;
	signal sramAddr			:		 STD_LOGIC_VECTOR(7-1 downto 0);
	signal maxTick, minTick	:		 STD_LOGIC;
	
	begin
	uut: PC port map(
		clk 		=> clk,
		reset		=> reset,
		synClr	=> synClr,
		load		=> load,
		branchIn	=> branchIn,
		enPc		=> enPc,
		sramAddr	=> sramAddr,
		maxTick	=> maxTick,
		minTick	=> minTick
		);
		
	process 
	begin
		clk <= '1';
		wait for T/2;
		clk <= '0';
		wait for T/2;
	end process;
	
	process
	begin
	
		branchIn <= "1111100";
		for i in 0 to 5 loop 
			enPc <= '1';
			wait until falling_edge(clk);
		end loop;
		
		enPc <= '0';
		load <= '1';
		wait until falling_edge(clk);
		load <= '0';
		
		for i in 0 to 5 loop 
			enPc <= '1';
			wait until falling_edge(clk);
		end loop;
		
	end process;
	
end behavioral;
	
		