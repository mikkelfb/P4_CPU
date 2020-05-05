LIBRARY ieee;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;


Entity tb_Systemcentral IS
END tb_Systemcentral;

Architecture behavior of tb_Systemcentral IS
	COMPONENT Systemcentral
	port(
		clk	: in std_logic;
		reset : in std_logic
	);
	end component;
	
	constant T: time := 20 ns;		
	
	signal clk : std_logic;
	signal reset : std_logic:='0';
begin
	uut : Systemcentral port map(
		clk => clk,
		reset => reset	);


	process
		begin
			clk <= '0';
			wait for T/2;
			clk <= '1';
			wait for T/2;
		end process;
end behavior;