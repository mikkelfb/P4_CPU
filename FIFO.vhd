-- This file was inspird by Mr. Chu

LIBRARY ieee;
Use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
Use IEEE.NUMERIC_STD.all;

entity FIFO is
	generic (
		B: natural := 8;	-- Number of bits in buffer
		W: natural := 4 	-- Number of address bits
	);
	
	port (
		clk, reset		:	in std_logic;									-- Clock and reset
		rd					:	in std_logic;									-- Remove data signal. The output of the FIFO is constantly available. This signal makes sure we can delete the data
		wr					: 	in std_logic;									-- Write data signal
		wData				:	in std_logic_vector(B-1 downto 0);		-- Data to be written
		empty, full		:	out std_logic;									-- FIFO empty and full outputs
		rData				:	out std_logic_vector(B-1 downto 0)		-- Output data
	);
end FIFO;
	
Architecture behavioral of FIFO is

	type regFileType is array (2**W-1 downto 0) of std_logic_vector(B-1 downto 0);	-- Creating 16 registers inside the FIFO of 8 bits each
	
	signal arrayReg: regFileType;																		-- Create a signal for the 16 FIFO registers
	signal wPtrReg, wPtrNext, wPtrSucc: std_logic_vector(W-1 downto 0);					-- Create write pointers that points to the head of the queue
	signal rPtrReg, rPtrNext, rPtrSucc: std_logic_vector(W-1 downto 0);					-- Create read pointers that point to the tail of the queue.
	signal fullReg, emptyReg, fullNext, emptyNext: std_logic;								-- These signals are used to switch between the registers.
	signal wrOp: std_logic_vector(1 downto 0);													-- Signal for FIFO Control Logic
	signal wrEn: std_logic;																				-- Enable write
	
begin
	--====================================================
	--						Register File
	--====================================================
	process(clk, reset)
	begin
		if (reset = '1') then
			arrayReg <= (others=>(others=>'0'));													-- If reset then set all of the registers to 0's
		elsif (rising_edge(clk)) then
			if (wrEn = '1') then																			-- Check if write is enabled
				arrayReg(to_integer(unsigned(wPtrReg))) <= wData;								-- If write is enabled then put the data into the next empty register in the queue.
			end if;
		end if;
	end process;
	
	-- Read Port
	Rdata <= arrayReg(to_integer(unsigned(rPtrReg)));											-- Set the tail of the queue to the output
	
	wrEn <= wr and (not fullReg); 																	-- Do not write if the FIFO is full 
	
	--====================================================
	--						FIFO Control Logic
	--====================================================
	
	-- Register for read and write pointers
	process (clk, reset)
	begin
		if (reset = '1') then
			wPtrReg <= (others => '0');
			rPtrReg <= (others => '0');
			fullReg <= '0';
			emptyReg <= '1';
		elsif (rising_edge(clk)) then
			wPtrReg <= wPtrNext;
			rPtrReg <= rPtrNext;
			fullReg <= fullNext;
			emptyReg <= emptyNext;
		end if;
	end process;
	
	-- Successive pointer values
	wPtrSucc <= std_logic_vector(unsigned(wPtrReg) + 1);
	rPtrSucc <= std_logic_vector(unsigned(rPtrReg) + 1);
	
	-- Next-state logic for read and write pointers
	wrOp <= wr & rd;
	
	process (wPtrReg, wPtrSucc, rPtrReg, rPtrSucc, wrOp, emptyReg, fullReg)
	begin
		wPtrNext <= wPtrReg;
		rPtrNext <= rPtrReg;
		fullNext <= fullReg;
		emptyNext <= emptyReg;
		case wrOp is
			when "00" => -- no op
			when "01" => -- Read
				if (emptyReg /= '1') then -- Not empty
					rPtrNext <= rPtrSucc;
					fullNext <= '0';
					if (rPtrSucc=wPtrReg) then
						emptyNext <= '1';
					end if;
				end if;
			when "10" => -- Write
				if (fullReg /= '1') then -- Not full
					wPtrNext <= wPtrSucc;
					emptyNext <= '0';
					if (wPtrSucc=rPtrReg) then
						fullNext <= '1';
					end if;
				end if;
			when others => -- write/read
				wPtrNext <= wPtrSucc;
				rPtrNext <= rPtrSucc;
		end case;
	end process;
	
	-- Output
	full <= fullReg;
	empty <= emptyReg;
end behavioral;