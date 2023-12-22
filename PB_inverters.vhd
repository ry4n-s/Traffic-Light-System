library ieee;
use ieee.std_logic_1164.all;


entity PB_inverters is port (
 	pb_n	: in  std_logic_vector (3 downto 0);
	pb	: out	std_logic_vector(3 downto 0)							 
	); 
end PB_inverters;

architecture ckt of PB_inverters is

begin
pb <= NOT(pb_n); -- all this file does is invert the push buttons. Ordinarily, the buttons are "on" when they are not pressed, but this code flips it.
-- In technical terms, this code flips the active high/low of the push buttons.


end ckt;
