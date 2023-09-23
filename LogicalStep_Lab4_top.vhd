--Author: Group 10, Ryan Stefanov, Ryan Wang
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
   clkin_50		: in	std_logic;							-- The 50 MHz FPGA Clock input
	rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out std_logic_vector(7 downto 0);	-- The lights for displaying the counter, pedestrian inputs, and when there is a solid green
	-------------------------------------------------------------
	-- you can add temporary output ports here if you need to debug your design 
	-- or to add internal signals for your simulations
	
	--ism_clken	: out std_logic;
	--iblink_sig	: out std_logic;
	--iNSA, iNSG, iNSD : out std_logic;
	--iEWA, iEWG, iEWD : out std_logic;
	
	-- we used these internal signals while making this project
	-------------------------------------------------------------
	
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment display
	seg7_char1  : out	std_logic;							-- seg7 digit selectors
	seg7_char2  : out	std_logic							-- seg7 digit selectors
	);
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS

   component segment7_mux port (
          clk        : in  std_logic := '0';					-- the clock
			 DIN2 		: in  std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 		: in  std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
   );
   end component;

   component clock_generator port ( -- see clock_generator
			sim_mode			: in boolean;
			reset				: in std_logic;
         clkin      		: in  std_logic;
			sm_clken			: out	std_logic;
			blink		  		: out std_logic
  );
   end component;

   component pb_inverters port (
			 pb_n					: in std_logic_vector(3 downto 0); -- see pb_inverters
			 pb			  		: out std_logic_vector(3 downto 0)
  );
   end component;

	
	component synchronizer port( -- see synchronizer
			clk					: in std_logic;
			reset					: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
	);
	end component;
-- 
	component holding_register port ( --see holding_register
			clk					: in std_logic;
			reset					: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout					: out std_logic
	);
	end component;
				
	component Moore_State_Machine port( -- see Moore_State_Machine for more
			sm_clken								: in std_logic;
			reset									: in std_logic;
			EWsm, NSsm							: in std_logic; -- The pedestrian button inputs
			blink_sig							: in std_logic; -- The blink signal
			NS_Crossing, EW_Crossing		: out std_logic;
			NSSegA, NSSegG, NSSegD			: out std_logic;
			EWSegA, EWSegG, EWSegD			: out std_logic;
			state_num							: out std_logic_vector(3 downto 0);
			EW_reset, NS_reset				: out std_logic
	);
	end component;
	
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode										: boolean := FALSE; -- set to FALSE for LogicalStep board downloads
	                                                     -- set to TRUE for SIMULATIONS
																		  -- For the demo, this is set to FALSE
	
	SIGNAL sm_clken, blink_sig							: std_logic; 
	-- state machine design updates to a new state only when it is enabled. Enable signal is connected to Clock Generator signal sm_clken
	-- blink_sig will be used as a source connected to the clock_generator output for the flashing States
	
	SIGNAL pb												: std_logic_vector(3 downto 0); -- pb(3) is used as an active-high reset for all registers
	
	signal EWC, NSC 										: std_logic; -- outputs of Synchronizer, inputs of holding register
	signal EWsm, NSsm										: std_logic; -- outputs of holding register, inputs of State Machine
	
	signal NSA, NSG, NSD, NS_Crossing				: std_logic;
	signal EWA, EWG, EWD, EW_Crossing				: std_logic;
	signal NSSevenSegment, EWSevenSegment			: std_logic_vector(6 downto 0);
	
	signal state_num_leds								: std_logic_vector(3 downto 0);
	
	signal EW_reset, NS_reset							: std_logic;
	
BEGIN
----------------------------------------------------------------------------------------------------
INST1: pb_inverters		port map (pb_n, pb);
INST2: clock_generator 	port map (sim_mode, pb(3), clkin_50, sm_clken, blink_sig);

--simulation connections
--ism_clken <= sm_clken;
--iblink_sig <= blink_sig;

INST3: synchronizer port map (clkin_50, pb(3), pb(1), EWC); -- EAST WEST synchronizer
INST4: synchronizer port map (clkin_50, pb(3), pb(0), NSC); -- NORTH SOUTH synchronizer
INST5: holding_register port map (clkin_50, pb(3), EW_reset, EWC, EWsm); -- EAST WEST holding register
INST6: holding_register port map (clkin_50, pb(3), NS_reset, NSC, NSsm); -- NORTH SOUTH holding register

leds(1) <= NSsm;
leds(3) <= EWsm;

-- NS will display on digit2 (right most digit)
INST7: Moore_State_Machine port map ( sm_clken, pb(3), EWsm, NSsm, blink_sig, NS_Crossing, EW_Crossing, NSA, NSG, NSD, EWA, EWG, EWD, state_num_leds, EW_reset, NS_reset);

--For simulation:
--INST7: Moore_State_Machine port map ( sm_clken, pb(3), EWsm, NSsm, blink_sig, NS_Crossing, EW_Crossing, iNSA, iNSG, iNSD, iEWA, iEWG, iEWD, state_num_leds, EW_reset, NS_reset);

leds(0) <= NS_Crossing; --the NS_Crossing display. When NS is a solid green
leds(2) <= EW_Crossing; --the EW_Crossing display. When EW is a solid green

leds(4) <= state_num_leds(0); -- the number of the state number counters for leds 4, 5, 6, 7
leds(5) <= state_num_leds(1);
leds(6) <= state_num_leds(2);
leds(7) <= state_num_leds(3);
--TEMP connections
--leds(4) <= NSA;
--leds(5) <= NSG;
--leds(6) <= NSD;
NSSevenSegment <= NSG & "00" & NSD & "00" & NSA; 
EWSevenSegment <= EWG & "00" & EWD & "00" & EWA;
INST8: segment7_mux port map (clkin_50, NSSevenSegment, EWSevenSegment, seg7_data, seg7_char2, seg7_char1);

END SimpleCircuit;
