LIBRARY ieee;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;


Entity tb_Systemcentral IS
END tb_Systemcentral;

Architecture behavior of tb_Systemcentral IS
	COMPONENT Systemcentral
	port(
		inPutclk 		: in std_logic;
		debugLightOut	: out std_logic_vector(8 downto 0);
		debugSwitchIn	: in std_Logic_vector(9 downto 0);
		clkOut			: out std_logic
	);
	end component;
	
	constant T: time := 20 ns;		
	constant baudTime: time := 52 us;								-- Used to simulate input, set for a baudrate at 19200
	
	signal clk : std_logic;
	--signal reset : std_logic:='1';

	signal inPutclk 		: std_logic;
	signal debugLightOut : std_logic_vector(8 downto 0);
	signal debugSwitchIn	: std_Logic_vector(9 downto 0);
	signal clkOut			: std_logic;
	
begin
	uut : Systemcentral port map(
		inPutclk 		=> clk,
		debugLightOut 	=> debugLightOut,
		debugSwitchIn 	=> debugSwitchIn,
		clkOut 			=> clkOut);
	
	--clk process
	process
		begin
			clk <= '0';
			wait for T/2;
			clk <= '1';
			wait for T/2;
	end process;
	
	
end behavior;