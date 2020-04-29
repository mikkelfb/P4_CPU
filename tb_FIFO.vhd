-- This file was inspird by Mr. Chu

LIBRARY ieee;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

entity tb_FIFO is
end tb_FIFO;


Architecture behavioral of tb_FIFO is

	component FIFO
	port (
		clk, reset		:	in std_logic;																-- Clock and reset
		rd					:	in std_logic;																-- Remove data signal. The output of the FIFO is constantly available. This signal makes sure we can delete the data
		wr					: 	in std_logic;																-- Write data signal
		wData				:	in std_logic_vector(7 downto 0);									-- Data to be written
		empty, full		:	out std_logic;																-- FIFO empty and full outputs
		rData				:	out std_logic_vector(7 downto 0)									-- Output data
	);
	end component;
	
	constant T: time := 20 ns;
	
	signal clk		: 	std_logic;
	signal reset	: 	std_logic;
	signal rd		:	std_logic;
	signal wr		:	std_logic;
	signal wData	:	std_logic_vector(7 downto 0);
	signal empty	:	std_logic;
	signal full		:	std_logic;
	signal rData	:	std_logic_vector(7 downto 0);
	signal testData	: std_logic_vector(7 downto 0) := "00000000";
	
	begin
		uut: FIFO port map (
			clk	=> clk,
			reset => reset,
			rd		=> rd,
			wr		=> wr,
			wData	=> wData,
			empty => empty,
			full	=> full,
			rData	=> rData
		);
		
		reset <= '0';
		
		process
		begin
			clk <= '1';
			wait for T/2;
			clk <= '0';
			wait for T/2;
		end process;
		
		
		
		process
		begin
			wr <= '1';
			rd <= '0';
			
			wait until falling_edge(clk);
			
			for i in 0 to 15 loop
				testData <= testData + "00000001";
				wData <= testData;
				wait until falling_edge(clk);
			end loop;
		end process;
		
end behavioral;
		