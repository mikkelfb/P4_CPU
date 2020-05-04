library IEEE;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

entity dispHexMux is 
	port(
			clk, reset: in std_logic;
			dpIn: in std_logic_vector (5 downto 0);
			binIN: in std_logic_vector(15 downto 0);
			an: out std_logic_vector (5 downto 0);
			sseg : out std_logic_vector ( 7 downto 0)
) ;
end dispHexMux ;


architecture arch of dispHexMux is
	constant N: integer:= 8; 		--Use 8 for simulations, use 19 on hardware
	signal qReg, qNext: unsigned (N-1 downto 0):=(others=>'0');
	signal sel: std_logic_vector (2 downto 0);
	signal hex4, hex3, hex2, hex1, hex0: std_logic_vector(3 downto 0);
	signal hex: std_logic_vector (3 downto 0);
	signal dp: std_logic;
begin

	bIn2BCD : entity work.bin2bcd_16bit(behavioral)
	port map(bcd0 => hex0, bcd1 => hex1, bcd2 => hex2, bcd3 => hex3, bcd4 => hex4, binIN => binIn);

	process (clk, reset)
	begin
		if reset='1' then
			qReg <= (others => '0');
		elsif (rising_edge(clk)) then
			qReg <= qNext;
		end if;
	end process;
	
	qNext <= qReg +1;
	
	sel <= std_logic_vector(qReg(N-1 downto N-3)) ;
	process(sel, hex0, hex1, hex2, hex3, hex4, dpIn)
	begin
		case sel is 
			when "000" =>
				an <= "111110";
				hex <= hex0;
				dp <= dpIn(0);
			when "001" =>
				an <= "111101";
				hex <= hex1;
				dp <= dpIn(1);
			when "010" =>
				an <= "111011";
				hex <=  hex2;
				dp <= dpIn(2);
			when "011" =>
				an <= "110111";
				hex <= hex3;
				dp <= dpIn(3);
			when "100" =>
				an <= "101111";
				hex <= hex4;
				dp <= dpIn(4);
			when others =>
				an <= "011111";
				hex <= "0000";
				dp <= dpIn(5);
			end case;
		end process;
		
		with hex select
			sseg (6 downto 0) <=
				"0000001" when "0000",
				"1001111" when "0001",
				"0010010" when "0010",
				"0000110" when "0011",
				"1001100" when "0100",
				"0100100" when "0101",
				"0100000" when "0110",
				"0001111" when "0111",
				"0000000" when "1000",
				"0000100" when "1001",
				"0001000" when "1010",
				"1100000" when "1011",
				"0110001" when "1100",
				"1000010" when "1101",
				"0110000" when "1110",
				"0111000" when others;
		sseg(7) <= dp;
end arch;