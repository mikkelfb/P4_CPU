LIBRARY ieee;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;


Entity tb_SRAM IS
END tb_SRAM;

Architecture behavior of tb_SRAM IS

	COMPONENT SRAM
	PORT(
		addr						: in STD_LOGIC_VECTOR(6 downto 0);			
		dataInOut				: inout STD_LOGIC_VECTOR(15 downto 0);		
		En							: in STD_LOGIC;										
		EnWr						: in STD_LOGIC;										
		clk						: in STD_LOGIC											
	);
	END COMPONENT;
	
	constant T: time := 10 ns;															
	
	signal addr						: STD_LOGIC_VECTOR(6 downto 0);			
	signal dataInOut				: STD_LOGIC_VECTOR(15 downto 0);		
	signal En						: STD_LOGIC;										
	signal EnWr						: STD_LOGIC;										
	signal clk						: STD_LOGIC;
	signal addrCounter			: STD_LOGIC_VECTOR(6 downto 0) := "1111100";
	signal testData				: STD_LOGIC_VECTOR(15 downto 0);		
	
	begin
	
		uut: SRAM port map(
			addr 			=> addr,
			dataInOut 	=> dataInOut, 
			clk 			=> clk,
			En				=> En,
			EnWr 			=> EnWr
		);
		
		
	dataInOut <= testData when (En = '1' and EnWr = '1') else (others=>'Z'); --Fix testbench by making input high impedans when EnWr is off.
		
		process
		begin
			clk <= '0';
			wait for T/2;
			clk <= '1';
			wait for T/2;
		end process;
		
		process
		begin
			En <= '1';
			EnWr <= '1';
			for i in 0 to 3 loop
				addr <= addrCounter;
				testData <= "000000000" & addrCounter;
				addrCounter <= addrCounter + "0000001";	
				wait until falling_edge(clk);	
			end loop;
			
			wait until falling_edge(clk);	
			wait until falling_edge(clk);	
			En <= '1';
			EnWr <= '0';
			wait until falling_edge(clk);
			
			addrCounter <= "1111100";
			wait until falling_edge(clk);
			for i in 0 to 3 loop
				addr <= addrCounter;
				addrCounter <= addrCounter + "0000001";	
				wait until falling_edge(clk);	
			end loop;
			
			
		end process;
	
		

end behavior;