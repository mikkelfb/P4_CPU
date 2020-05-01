-- Inspired by the 12-bit implementation from the double dabble wiki: https://en.wikipedia.org/wiki/Double_dabble

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity bin2bcd_16bit is
    Port ( binIN : in  STD_LOGIC_VECTOR(15 downto 0);
           bcd0 : out  STD_LOGIC_VECTOR(3 downto 0);
           bcd1 : out  STD_LOGIC_VECTOR(3 downto 0);
           bcd2 : out  STD_LOGIC_VECTOR(3 downto 0);
           bcd3 : out  STD_LOGIC_VECTOR(3 downto 0);
			  bcd4 :	out  STD_LOGIC_VECTOR(3 downto 0)
          );
end bin2bcd_16bit;

architecture Behavioral of bin2bcd_16bit is

begin

	process(binIN)

	  -- temporary variable
	  variable temp : STD_LOGIC_VECTOR (15 downto 0);
	  

	  variable bcd : UNSIGNED(19 downto 0) := (others => '0');

	  
	  begin
		 -- zero the bcd variable
		 bcd := (others => '0');
		 
		 -- read input into temp variable
		 temp(15 downto 0) := binIN;
		 
		 -- cycle 16 times as we have 16 input bits
		 for i in 0 to 15 loop
		 
			if bcd(3 downto 0) > 4 then 
				bcd(3 downto 0) := bcd(3 downto 0) + 3;
			end if;
			
			if bcd(7 downto 4) > 4 then 
				bcd(7 downto 4) := bcd(7 downto 4) + 3;
			end if;
		 
			if bcd(11 downto 8) > 4 then  
				bcd(11 downto 8) := bcd(11 downto 8) + 3;
			end if;
			
			if bcd(15 downto 12) > 4 then
				bcd(15 downto 12) := bcd(15 downto 12) + 3;	
			end if;
		 
		 
			-- shift bcd left by 1 bit, copy MSB of temp into LSB of bcd
			bcd := bcd(18 downto 0) & temp(15);
		 
			-- shift temp left by 1 bit
			temp := temp(14 downto 0) & '0';
		 
		 end loop;
	 
		 -- set outputs
		 bcd0 <= STD_LOGIC_VECTOR(bcd(3 downto 0));
		 bcd1 <= STD_LOGIC_VECTOR(bcd(7 downto 4));
		 bcd2 <= STD_LOGIC_VECTOR(bcd(11 downto 8));
		 bcd3 <= STD_LOGIC_VECTOR(bcd(15 downto 12));
		 bcd4 <= STD_LOGIC_VECTOR(bcd(19 downto 16));
	  
	  end process;            
  
end Behavioral;