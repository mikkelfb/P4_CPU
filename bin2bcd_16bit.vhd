-- Inspired by the 12-bit implementation from the double dabble wiki: https://en.wikipedia.org/wiki/Double_dabble

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- The circuit is sequential meaning no clock is needed. 

--	PARAM[IN] binIN 16 bit data string to be converted
-- PARAM[OUT] bcd0 first nibble of converted data
-- PARAM[OUT] bcd1 second nibble of converted data
-- PARAM[OUT] bcd2 third nibble of converted data
-- PARAM[OUT] bcd3 fourth nibbles of converted data
-- PARAM[OUT] bcd4 fifth nibbles of converted data


entity bin2bcd_16bit is
    Port ( 
				binIN : in  STD_LOGIC_VECTOR(15 downto 0);		-- Input for the binary formatet data
				bcd0 : out  STD_LOGIC_VECTOR(3 downto 0);			-- Output for the first BCD
				bcd1 : out  STD_LOGIC_VECTOR(3 downto 0);			--	Output for the second BCD
				bcd2 : out  STD_LOGIC_VECTOR(3 downto 0);			-- Output for the third BCD
				bcd3 : out  STD_LOGIC_VECTOR(3 downto 0);			-- Output for the fourth BCD
				bcd4 : out  STD_LOGIC_VECTOR(3 downto 0)			-- Output for the fifth BCD
          );
end bin2bcd_16bit;

architecture Behavioral of bin2bcd_16bit is

begin

	process(binIN)
		
		-- temporary variable to store the binary input
		variable temp : STD_LOGIC_VECTOR (15 downto 0);
	  
		-- Variable that stores the output
		variable bcd : UNSIGNED(19 downto 0) := (others => '0');

		  
		begin
			
			-- Set the bcd variable to all zeroes
			bcd := (others => '0');
		 
			-- Assign the input signal to the temp variable
			temp(15 downto 0) := binIN;
		 
			-- Create a for loop that cycles through all of the 16 input bits.
			for i in 0 to 15 loop
		 
				-- Check whether the first nibble is larger than 4
				if bcd(3 downto 0) > 4 then 
					bcd(3 downto 0) := bcd(3 downto 0) + 3; 			-- If larger than 4, add 3
				end if;
			
				-- Check whether the second nibble is larger than 4
				if bcd(7 downto 4) > 4 then 
					bcd(7 downto 4) := bcd(7 downto 4) + 3; 			-- If larger than 4, add 3
				end if;
				
				-- Check whether the third nibble is larger than 4
				if bcd(11 downto 8) > 4 then  
					bcd(11 downto 8) := bcd(11 downto 8) + 3; 		-- If larger than 4, add 3
				end if;
			
				-- Check whether the fourth nibble is larger than 4
				if bcd(15 downto 12) > 4 then
					bcd(15 downto 12) := bcd(15 downto 12) + 3; 		-- If larger than 4, add 3
				end if;
		 
		 
				-- Shift bcd left by 1 bit, copy MSB of temp into LSB of bcd
				bcd := bcd(18 downto 0) & temp(15);
		 
				-- Shift temp left by 1 bit
				temp := temp(14 downto 0) & '0';
		 
			end loop;
	 
		-- Set outputs
		bcd0 <= STD_LOGIC_VECTOR(bcd(3 downto 0));
		bcd1 <= STD_LOGIC_VECTOR(bcd(7 downto 4));
		bcd2 <= STD_LOGIC_VECTOR(bcd(11 downto 8));
		bcd3 <= STD_LOGIC_VECTOR(bcd(15 downto 12));
		bcd4 <= STD_LOGIC_VECTOR(bcd(19 downto 16));
	end process;            
  
end Behavioral;