LIBRARY ieee;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;


Entity tb_Systemcentral IS
END tb_Systemcentral;

Architecture behavior of tb_Systemcentral IS
	COMPONENT Systemcentral
	port(
		inPutclk 			: in std_logic;
		debugLightOut		: out std_logic_vector(8 downto 0);
		debugSwitchIn		: in std_Logic_vector(9 downto 0);
		clkOut				: out std_logic;
		UARTRX				: in std_logic;
		UARTTX 				: out std_logic;
		SevenSegHex0		: out std_logic_vector(7 downto 0);
		SevenSegHex1		: out std_logic_vector(7 downto 0);
		SevenSegHex2		: out std_logic_vector(7 downto 0);
		SevenSegHex3		: out std_logic_vector(7 downto 0);
		SevenSegHex4		: out std_logic_vector(7 downto 0);
		SevenSegHex5		: out std_logic_vector(7 downto 0)
	);
	end component;
	
	constant T: time := 20 ns;		
	constant baudTime: time := 52 us;								-- Used to simulate input, set for a baudrate at 19200
	
	signal clk : std_logic;
	--signal reset : std_logic:='1';

	signal inPutclk 			: std_logic;
	signal debugLightOut 	: std_logic_vector(8 downto 0);
	signal debugSwitchIn		: std_Logic_vector(9 downto 0);
	signal clkOut				: std_logic;
	signal UARTRX				: std_logic;
	signal UARTTX 				: std_logic;
	
	signal SevenSegHex0		: std_logic_vector(7 downto 0);
	signal SevenSegHex1		: std_logic_vector(7 downto 0);
	signal SevenSegHex2		: std_logic_vector(7 downto 0);
	signal SevenSegHex3		: std_logic_vector(7 downto 0);
	signal SevenSegHex4		: std_logic_vector(7 downto 0);
	signal SevenSegHex5		: std_logic_vector(7 downto 0);
	
	
begin
	uut : Systemcentral port map(
		inPutclk 		=> clk,
		debugLightOut 	=> debugLightOut,
		debugSwitchIn 	=> debugSwitchIn,
		clkOut 			=> clkOut,
		UARTRX			=> UARTRX,
		UARTTX			=> UARTTX,
		SevenSegHex0	=> SevenSegHex0,
		SevenSegHex1	=> SevenSegHex1,
		SevenSegHex2	=> SevenSegHex2,
		SevenSegHex3	=> SevenSegHex3,
		SevenSegHex4	=> SevenSegHex4,
		SevenSegHex5	=> SevenSegHex5);
	
	--clk process
	process
		begin
			clk <= '0';
			wait for T/2;
			clk <= '1';
			wait for T/2;
	end process;
	
	process
		begin
			UARTRX <= '0';					-- Sets rx to 0 generate start signal
			wait for baudTime;
		
			for i in 0 to 7 loop
				UARTRX <= not UARTRX;			-- set rx to shift between 1 and 0 for 8 bits
				wait for baudTime;
			end loop;
		
			UARTRX <= '1';					-- set rx to 1 and waits for to baudTime to generate stop signal
			wait for baudTime;
			wait for baudTime;
			
		
	end process;
	
end behavior;