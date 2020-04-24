LIBRARY ieee;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;


Entity tb_GPR IS
END tb_GPR;

Architecture behavior of tb_GPR IS

	COMPONENT GPR
	PORT(
		addrA, addrB, addrC		: 	in STD_LOGIC_VECTOR(2 downto 0);
		EnWr							: 	in STD_LOGIC;
		clk							:	in STD_LOGIC;
		dataIn						: 	in STD_LOGIC_VECTOR(15 downto 0);
		
		ALUA							:	out STD_LOGIC_VECTOR(15 downto 0);
		ALUB							:	out STD_LOGIC_VECTOR(15 downto 0)
	);
	END COMPONENT;
	
	constant T: time := 20 ns;
	
	signal addrA, addrB, addrC		: 	STD_LOGIC_VECTOR(2 downto 0);
	signal EnWr							: 	STD_LOGIC;
	signal clk							:	STD_LOGIC;
	signal dataIn						: 	STD_LOGIC_VECTOR(15 downto 0);
	
	signal ALUA							:	STD_LOGIC_VECTOR(15 downto 0);
	signal ALUB							:	STD_LOGIC_VECTOR(15 downto 0);
	
	signal addrCounter				:	STD_LOGIC_VECTOR(2 downto 0) := "000";
	
	begin
	
		uut: GPR port map(
			addrA 	=> addrA,
			addrB 	=> addrB,
			addrC 	=> addrC, 
			clk 		=> clk,
			EnWr		=> EnWr,
			dataIn 	=> dataIn,
			ALUA		=> ALUA,
			ALUB		=> ALUB
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
			EnWr <= '1';
		
			for i in 0 to 7 loop
				addrA <= addrCounter;
				addrB <= addrCounter;
				addrC <= addrCounter;
				
				dataIn <= "0000000000000" & addrCounter;
				
				addrCounter <= addrCounter + "001";
				
				wait until falling_edge(clk);
				
			end loop;
			
			EnWr <= '0';
			addrCounter <= "000";
			
			for i in 0 to 7 loop
				addrA <= addrCounter;
				addrB <= addrCounter + "001";
				
				addrCounter <= addrCounter + "001";
				
				wait until falling_edge(clk);
			end loop;
			
		end process;
	

end behavior;