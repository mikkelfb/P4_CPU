library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

entity tb_PC_V2 is 
end entity;

architecture behavioral of tb_PC_V2 is

	component PC
	port (
		clk 						:		in STD_LOGIC;		
		reset						:		in STD_LOGIC;		
		loadCU					: 		in STD_LOGIC;			
		loadBranch				:		in STD_LOGIC;	
		branchIn					:		in STD_LOGIC_VECTOR(7-1 downto 0);
		enPc						: 		in STD_LOGIC;
		sramAddr					:		out STD_LOGIC_VECTOR(7-1 downto 0)
	);
	end component;
	
	constant T: time := 20 ns;
	
	signal clk					:		 STD_LOGIC; 
	signal reset				:		 STD_LOGIC := '0';
	signal branchIn			: 		 STD_LOGIC_VECTOR(7-1 downto 0);
	signal loadCU				:		 STD_LOGIC := '0';
	signal loadBranch			:		 STD_LOGIC := '0';
	signal enPc					: 		 STD_LOGIC;
	signal sramAddr			:		 STD_LOGIC_VECTOR(7-1 downto 0);
	
	begin
	uut: PC port map(
		clk 			=> clk,
		reset			=> reset,
		loadCU		=> loadCU,
		loadBranch	=> loadBranch,
		branchIn		=> branchIn,
		enPc			=> enPc,
		sramAddr		=> sramAddr
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
		branchIn <= "0001110";
		enPc <= '1';
		wait until falling_edge(clk);	
		wait until falling_edge(clk);	
		enPc <= '0';
		wait until falling_edge(clk);	
		enPc <= '1';
		loadCU <= '1';
		wait until falling_edge(clk);	
		enPc <= '0';
		loadCU <= '0';
		wait until falling_edge(clk);	
		branchIn <= "0011110";
		enPc <= '1';
		loadBranch <= '1';
		wait until falling_edge(clk);	
		enPc <= '0';
		loadBranch <= '0';
		wait until falling_edge(clk);	
		reset <= '1';
		wait until falling_edge(clk);	
		reset <= '0';
		wait until falling_edge(clk);
	end process;
	
	
	
	
end behavioral;