--Author: Group 10, Ryan Stefanov, Ryan Wang
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity synchronizer is port ( -- the inputs are asynchronous so they must be synchronized with the clock. This is to avoid metastability

			clk					: in std_logic; -- Connected to the 50MHz common Global Clock (clkin_50)
			reset					: in std_logic; -- resets to 0
			din					: in std_logic; -- original input thta gets passed in
			dout					: out std_logic -- final output
  );
 end synchronizer;
 
 
architecture circuit of synchronizer is

	Signal sreg				: std_logic_vector(1 downto 0); --as the first output, Q

BEGIN

	synchronize: process (clk, reset, din) is -- This process occurs everytime a rising edge occurs 
	
	begin
	
		if( rising_edge(clk) ) then
		
			if (reset = '1') then -- notice that reset is synchronous, therefore it can only reset on a rising clock edge
				sreg <= "00";
			
			else 
				sreg <= sreg(0) & din; -- process through the first D flip flop
				
			end if;

		else
		
		end if;
		
	dout <= sreg(1); -- the final output comes from the second D flip flop's output
		
	end process;

END;