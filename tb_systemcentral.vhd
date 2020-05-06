LIBRARY ieee;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;


Entity tb_Systemcentral IS
END tb_Systemcentral;

Architecture behavior of tb_Systemcentral IS
	COMPONENT Systemcentral
	port(
		--clk	: in std_logic;
		inPutclk : in std_logic;
		--reset : in std_logic;
		UARTRX : in std_logic;
		UARTTX : out std_logic
	);
	end component;
	
	constant T: time := 20 ns;		
	constant baudTime: time := 52 us;								-- Used to simulate unput, set for a baudrate at 19200
	
	signal clk : std_logic;
	--signal reset : std_logic:='1';
	
	signal UARTRX : std_logic:='1';
	signal UARTTX : std_logic:='1';
	signal inPutclk : std_logic;
	
begin
	uut : Systemcentral port map(
		inPutclk => inPutclk,
		--reset => reset,
		UARTRX => UARTRX,
		UARTTX => UARTTX);
	
	--clk process
	process
		begin
			inPutclk <= '0';
			wait for T/2;
			inPutclk <= '1';
			wait for T/2;
			--if(reset = '1') then
				--reset <= '0';
			--end if;
	end process;
	
	process
		begin
			wait until falling_edge(clk);
			wait until falling_edge(clk);
			--start incomming UART message
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