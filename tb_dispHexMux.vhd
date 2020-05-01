LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity tb_dispHexMux is
end tb_dispHexMux;

architecture behavioural of tb_dispHexMux is
	
	component dispHexMux
		port(
			clk, reset: in std_logic;
			hex3, hex2, hex1, hex0: in std_logic_vector(3 downto 0);
			dpIn: in std_logic_vector (3 downto 0);
			ena: in std_logic;
			an: out std_logic_vector (3 downto 0);
			sseg : out std_logic_vector ( 7 downto 0)
			);
	end component;
		
	constant T: time := 20 ns;
	signal clk, reset: std_logic;
	signal hex3, hex2, hex1, hex0: std_logic_vector(3 downto 0);
	signal dpIn: std_logic_vector(3 downto 0);
	signal ena: std_logic;
	signal an: std_logic_vector (3 downto 0);
	signal sseg: std_logic_vector (7 downto 0);
	
	begin 
		uut: dispHexMux port map (
			clk => clk,
			reset => reset,
			hex3 => hex3,
			hex2 => hex2,
			hex1 => hex1,
			hex0 => hex0,
			dpIn => dpIn,
			ena => ena,
			an => an,
			sseg => sseg
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
		for i in 0 to 255 loop
			ena <= '1';
			hex0 <= "0000";
			hex1 <= "0001";
			hex2 <= "0010";
			hex3 <= "0011";
			dpIn <= "0000";
			wait until falling_edge(clk);
		end loop;
		for i in 0 to 9 loop
			ena <= '0';
			wait until falling_edge(clk);
		end loop;
	end process;
end behavioural;