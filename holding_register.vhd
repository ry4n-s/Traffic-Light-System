--Author: Group 10, Ryan Stefanov, Ryan Wang
library ieee;
use ieee.std_logic_1164.all;


entity holding_register is port ( -- the holding register monitors for pedestrian inputs in states 8 and 9 for NS and 0 and 1 for EW

			clk					: in std_logic;
			reset					: in std_logic; -- the chip-wide reset from push button 3
			register_clr		: in std_logic;
			din					: in std_logic; -- the synchronized input
			dout					: out std_logic
  );
 end holding_register;
 
 architecture circuit of holding_register is

	Signal sreg				: std_logic; -- the output Q of the D flip flop


BEGIN

	holding: process (clk, reset, register_clr, din) is 
	
	begin
	
		if( rising_edge(clk) ) then -- only occurs on rising edge of clock
			
			if ( reset = '1') then -- if the reset is on, no matter what the other inputs are, the output is 0
			
				sreg <= '0';
				
			else 
				
				sreg <= (din OR sreg) AND ( NOT(register_clr) ); -- from the diagram in the manual
				
			end if;
			
		end if;
		
		dout <= sreg; -- the output of the D flip flop, Q, becomes the final output
		
	end process;
	
END;