library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

Entity DataBus is
	port(
		clk 		: in std_logic;
		reset		: in std_logic;
		Ctr		: in std_logic_vector(1 downto 0);
		SRAMIn 	: in std_Logic_vector(15 downto 0);
		ALUIn 	: in std_Logic_vector(15 downto 0);
		UARTIn	: in std_logic_vector(15 downto 0);
		dataOut	: out std_logic_vector(15 downto 0)
	);
end DataBus;

architecture Behavioral of DataBus is	
	signal reg, nreg : std_logic_vector(15 downto 0);
begin
	process(clk)
		begin
			if(reset = '1') then 
				reg<= (others=>'0');
			elsif(rising_edge(clk)) then
				reg <= nreg;
			end if;
	end process;
	
	with Ctr select nreg <=
		SRAMIn 			when "01",
		ALUIn 			when "10",
		UARTIn 			when "11",
		(others=>'0')	when others;
	dataOut <= reg;
end Behavioral;
