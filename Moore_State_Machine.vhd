LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

Entity Moore_State_Machine is
port(
	sm_clken								: in std_logic; -- state machine clock enable
	reset									: in std_logic;
	EWsm, NSsm							: in std_logic; -- push button inputs for the pedestrians
	blink_sig							: in std_logic; -- The blink signal
	NS_Crossing, EW_Crossing		: out std_logic;
	NSSegA, NSSegG, NSSegD			: out std_logic;
	EWSegA, EWSegG, EWSegD			: out std_logic;
	state_num							: out std_logic_vector(3 downto 0); 
	EW_reset, NS_reset				: out std_logic
);
end Entity;

-- RED Segment A: 	0000001
-- ORANGE Segment G: 1000000
-- Green Segment D: 	0001000

Architecture MSM of Moore_State_Machine is

TYPE state_names is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15); -- The list of all state names (There are 16 states, 0 to 15),
-- NS: 0,1 GF, 2-5 GS, 6-7 AS, 8-15 RS

SIGNAL current_state, next_state : state_names; --signals of type state_names

BEGIN

	Register_Section : process(sm_clken, reset) 
	begin 
	
		if( rising_edge(sm_clken) ) then
		--CLK_EN ENABLE
			if ( reset = '1' ) then
		
				current_state <= s0; -- sends the state back to the beginning
			
			else
		
				current_state <= next_state; --increments the state by 1 (counts)
			
			end if;
		
		end if;
	
	end process;


--changes state when it is a rising edge. so use if statements with the clock inputs
	Transistion_Section: process(current_state, EWsm, NSsm) 
	
	begin
	
		CASE current_state is
		
			when s0 =>
				
					if( (EWsm = '1') AND (NSsm = '0') ) then -- skips to state 6 when the East-West button was pressed and the North-South one wasn't
						next_state <= s6;
					else
						next_state <= s1; -- counts, the same follows for each state, and goes back to 0 when reaches the end
					end if;
			
			when s1 =>
					if( (EWsm = '1') AND (NSsm = '0') ) then -- the same as s0, this is the blinking phase for North-South
						next_state <= s6;
					else
						next_state <= s2;
					end if;
			when s2 =>
					next_state <= s3;
				
			when s3 =>

					next_state <= s4;
			
			when s4 =>
			
					next_state <= s5;
	
			
			when s5 =>
					next_state <= s6;
	
			
			when s6 =>
					next_state <= s7;
			
			when s7 =>
					next_state <= s8;
		
			when s8 =>
				if( (EWsm = '0') AND (NSsm = '1') ) then --skips to state 14 when the North-South button was pressed and the East-West one wasn't
						next_state <= s14;
					else
						next_state <= s9;
					end if;
		
			
			when s9 =>
					if( (EWsm = '0') AND (NSsm = '1') ) then --same as s8, this is the blinking phase for East-West
						next_state <= s14;
					else
						next_state <= s10;
					end if;
	
			
			when s10 =>
					next_state <= s11;
	
			
			when s11 =>
					next_state <= s12;
	
			
			when s12 =>
					next_state <= s13;
	
			
			when s13 =>
					next_state <= s14;
					
	
			
			when s14 =>
					next_state <= s15;
			
			when s15 =>
					next_state <= s0; -- goes back to 0 after all states have been cycled through
					
			when others =>
					next_state <= s0;
		
			
		end CASE;
		
	end process;
	
	Decoder_Section : process (current_state) 
	
	begin
	
		CASE current_state is -- this section outlines what is supposed to happen on the display. NS is the right display, and EW is the left.
		-- 0 indicates that the light is off, 1 indicates the light is on, and blink_sig indicates that a light is flashing. Reset also must be 0 in order
		-- to cycle properly. Also, note the state number corresponds to the binary representation of the state. This is done for each state. The following code
		-- is repetitive so this serves as an explanation for all of the following states.
		
			--NS flashing
			--EW RS
			when s0 => 
			NSSegA <= '0';
			NSSegG <= '0';
			NSSegD <= blink_sig;
			NS_Crossing <= '0'; 
			
			EWSegA <= '1';
			EWSegG <= '0';
			EWSegD <= '0';
			EW_Crossing <= '0';
			
			EW_reset <= '0';
			NS_reset <= '0';
			
			state_num <= "0000";
			
			--NS flashing
			--EW RS
			when s1 => 
			NSSegA <= '0';
			NSSegG <= '0';
			NSSegD <= blink_sig;
			NS_Crossing <= '0'; 
			
			EWSegA <= '1';
			EWSegG <= '0';
			EWSegD <= '0';
			EW_Crossing <= '0';
			
			EW_reset <= '0';
			NS_reset <= '0';
			
			state_num <= "0001";
			
			--NS Gsolid
			--EW RS
			when s2 => 
			NSSegA <= '0';
			NSSegG <= '0';
			NSSegD <= '1';
			NS_Crossing <= '1'; 
			
			EWSegA <= '1';
			EWSegG <= '0';
			EWSegD <= '0';
			EW_Crossing <= '0';
			
			EW_reset <= '0';
			NS_reset <= '0';
			
			state_num <= "0010";
			
			--NS GS
			--EW RS
			when s3 => 
			NSSegA <= '0';
			NSSegG <= '0';
			NSSegD <= '1';
			NS_Crossing <= '1'; 
			
			EWSegA <= '1';
			EWSegG <= '0';
			EWSegD <= '0';
			EW_Crossing <= '0';
			
			EW_reset <= '0';
			NS_reset <= '0';
			
			state_num <= "0011";
			
			--NS GS
			--EW RS
			when s4 => 
			NSSegA <= '0';
			NSSegG <= '0';
			NSSegD <= '1';
			NS_Crossing <= '1'; 
			
			EWSegA <= '1';
			EWSegG <= '0';
			EWSegD <= '0';
			EW_Crossing <= '0';
			
			EW_reset <= '0';
			NS_reset <= '0';
			
			state_num <= "0100";
			
			--NS GS
			--EW RS
			when s5 => 
			NSSegA <= '0';
			NSSegG <= '0';
			NSSegD <= '1';
			NS_Crossing <= '1'; 
			
			EWSegA <= '1';
			EWSegG <= '0';
			EWSegD <= '0';
			EW_Crossing <= '0';
			
			EW_reset <= '0';
			NS_reset <= '0';
			
			state_num <= "0101";
			
			--NS AS
			--EW RS
			when s6 => 
			NSSegA <= '0';
			NSSegG <= '1';
			NSSegD <= '0';
			NS_Crossing <= '0'; 
			
			EWSegA <= '1';
			EWSegG <= '0';
			EWSegD <= '0';
			EW_Crossing <= '0';
			
			EW_reset <= '1';
			NS_reset <= '0';
			
			state_num <= "0110";
			
			--NS AS
			--EW RS
			when s7 => 
			NSSegA <= '0';
			NSSegG <= '1';
			NSSegD <= '0';
			NS_Crossing <= '0'; 
			
			EWSegA <= '1';
			EWSegG <= '0';
			EWSegD <= '0';
			EW_Crossing <= '0';
			
			EW_reset <= '0';
			NS_reset <= '0';
			
			state_num <= "0111";
			
			--NS RS
			--EW GF
			when s8 => 
			NSSegA <= '1';
			NSSegG <= '0';
			NSSegD <= '0';
			NS_Crossing <= '0'; 
			
			EWSegA <= '0';
			EWSegG <= '0';
			EWSegD <= blink_sig;
			EW_Crossing <= '0';
			
			EW_reset <= '0';
			NS_reset <= '0';
			
			state_num <= "1000";
			
			--NS RS
			--EW GF
			when s9 => 
			NSSegA <= '1';
			NSSegG <= '0';
			NSSegD <= '0';
			NS_Crossing <= '0'; 
			
			EWSegA <= '0';
			EWSegG <= '0';
			EWSegD <= blink_sig;
			EW_Crossing <= '0';
			
			EW_reset <= '0';
			NS_reset <= '0';
			
			state_num <= "1001";
			
			--NS RS
			--EW GS
			when s10 => 
			NSSegA <= '1';
			NSSegG <= '0';
			NSSegD <= '0';
			NS_Crossing <= '0'; 
			
			EWSegA <= '0';
			EWSegG <= '0';
			EWSegD <= '1';
			EW_Crossing <= '1';
			
			EW_reset <= '0';
			NS_reset <= '0';
			
			state_num <= "1010";
			
			--NS RS
			--EW GS
			when s11 => 
			NSSegA <= '1';
			NSSegG <= '0';
			NSSegD <= '0';
			NS_Crossing <= '0'; 
			
			EWSegA <= '0';
			EWSegG <= '0';
			EWSegD <= '1';
			EW_Crossing <= '1';
			
			EW_reset <= '0';
			NS_reset <= '0';
			
			state_num <= "1011";
			
			--NS RS
			--EW GS
			when s12 => 
			NSSegA <= '1';
			NSSegG <= '0';
			NSSegD <= '0';
			NS_Crossing <= '0'; 
			
			EWSegA <= '0';
			EWSegG <= '0';
			EWSegD <= '1';
			EW_Crossing <= '1';
			
			EW_reset <= '0';
			NS_reset <= '0';
			
			state_num <= "1100";
			
			--NS RS
			--EW GS
			when s13 => 
			NSSegA <= '1';
			NSSegG <= '0';
			NSSegD <= '0';
			NS_Crossing <= '0'; 
			
			EWSegA <= '0';
			EWSegG <= '0';
			EWSegD <= '1';
			EW_Crossing <= '1';
			
			EW_reset <= '0';
			NS_reset <= '0';
			
			state_num <= "1101";
			
			--NS RS
			--EW AS
			when s14 => 
			NSSegA <= '1';
			NSSegG <= '0';
			NSSegD <= '0';
			NS_Crossing <= '0'; 
			
			EWSegA <= '0';
			EWSegG <= '1';
			EWSegD <= '0';
			EW_Crossing <= '0';
			
			EW_reset <= '0';
			NS_reset <= '1';
			
			state_num <= "1110";
			
			--NS RS
			--EW AS
			when s15 => 
			NSSegA <= '1';
			NSSegG <= '0';
			NSSegD <= '0';
			NS_Crossing <= '0'; 
			
			EWSegA <= '0';
			EWSegG <= '1';
			EWSegD <= '0';
			EW_Crossing <= '0';
			
			EW_reset <= '0';
			NS_reset <= '0';
			
			state_num <= "1111";
			
			when others =>
			NSSegA <= '0';
			NSSegG <= '0';
			NSSegD <= '0';
			NS_Crossing <= '0'; 
			
			EWSegA <= '0';
			EWSegG <= '0';
			EWSegD <= '0';
			EW_Crossing <= '0';
			
			EW_reset <= '0';
			NS_reset <= '0';
			
			state_num <= "0000";
			
		end CASE;
		
	end process;
	
END;
