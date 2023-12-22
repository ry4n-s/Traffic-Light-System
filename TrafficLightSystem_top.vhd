LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY TrafficLightSystem_top IS
    PORT (
        clkin_50     : IN  std_logic;                  -- The 50 MHz FPGA Clock input
        rst_n        : IN  std_logic;                  -- The RESET input (ACTIVE LOW)
        pb_n         : IN  std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
        sw           : IN  std_logic_vector(7 downto 0); -- The switch inputs
        leds         : OUT std_logic_vector(7 downto 0); -- The lights for displaying various outputs
        seg7_data    : OUT std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment display
        seg7_char1   : OUT std_logic;                  -- seg7 digit selectors
        seg7_char2   : OUT std_logic                   -- seg7 digit selectors
    );
END TrafficLightSystem_top;

-- Architecture declaration
ARCHITECTURE SimpleCircuit OF TrafficLightSystem_top IS
    -- Component declarations
    COMPONENT segment7_mux PORT (
        clk   : IN  std_logic := '0';
        DIN2  : IN  std_logic_vector(6 downto 0);
        DIN1  : IN  std_logic_vector(6 downto 0);
        DOUT  : OUT std_logic_vector(6 downto 0);
        DIG2  : OUT std_logic;
        DIG1  : OUT std_logic
    );
    END COMPONENT;

    COMPONENT clock_generator PORT (
        sim_mode : IN  boolean;
        reset    : IN  std_logic;
        clkin    : IN  std_logic;
        sm_clken : OUT std_logic;
        blink    : OUT std_logic
    );
    END COMPONENT;

    COMPONENT pb_inverters PORT (
        pb_n : IN  std_logic_vector(3 downto 0);
        pb   : OUT std_logic_vector(3 downto 0)
    );
    END COMPONENT;

    COMPONENT synchronizer PORT (
        clk   : IN  std_logic;
        reset : IN  std_logic;
        din   : IN  std_logic;
        dout  : OUT std_logic
    );
    END COMPONENT;

    COMPONENT holding_register PORT (
        clk           : IN  std_logic;
        reset         : IN  std_logic;
        register_clr  : IN  std_logic;
        din           : IN  std_logic;
        dout          : OUT std_logic
    );
    END COMPONENT;

    COMPONENT Moore_State_Machine PORT (
        sm_clken       : IN  std_logic;
        reset          : IN  std_logic;
        EWsm, NSsm     : IN  std_logic; -- Pedestrian button inputs
        blink_sig      : IN  std_logic; -- Blink signal
        NS_Crossing    : OUT std_logic;
        EW_Crossing    : OUT std_logic;
        NSSegA, NSSegG, NSSegD : OUT std_logic;
        EWSegA, EWSegG, EWSegD : OUT std_logic;
        state_num      : OUT std_logic_vector(3 downto 0);
        EW_reset, NS_reset : OUT std_logic
    );
    END COMPONENT;

    -- Signal declarations
    SIGNAL sm_clken, blink_sig        : std_logic;
    SIGNAL pb                         : std_logic_vector(3 downto 0);
    SIGNAL EWC, NSC                   : std_logic;
    SIGNAL EWsm, NSsm                 : std_logic;
    SIGNAL NSA, NSG, NSD, NS_Crossing : std_logic;
    SIGNAL EWA, EWG, EWD, EW_Crossing : std_logic;
    SIGNAL NSSevenSegment, EWSevenSegment : std_logic_vector(6 downto 0);
    SIGNAL state_num_leds             : std_logic_vector(3 downto 0);
    SIGNAL EW_reset, NS_reset         : std_logic;

    CONSTANT sim_mode : boolean := FALSE; -- Set to FALSE for board, TRUE for simulations

BEGIN
    -- Component instantiations
    INST1: pb_inverters      PORT MAP (pb_n, pb);
    INST2: clock_generator   PORT MAP (sim_mode, pb(3), clkin_50, sm_clken, blink_sig);
    INST3: synchronizer      PORT MAP (clkin_50, pb(3), pb(1), EWC); -- EAST WEST synchronizer
    INST4: synchronizer      PORT MAP (clkin_50, pb(3), pb(0), NSC); -- NORTH SOUTH synchronizer
    INST5: holding_register  PORT MAP (clkin_50, pb(3), EW_reset, EWC, EWsm); -- EAST WEST holding register
    INST6: holding_register  PORT MAP (clkin_50, pb(3), NS_reset, NSC, NSsm); -- NORTH SOUTH holding register

    -- LED connections
    leds(1) <= NSsm;
    leds(3) <= EWsm;
    leds(0) <= NS_Crossing;
    leds(2) <= EW_Crossing;
    leds(4 TO 7) <= state_num_leds;

    -- State Machine and 7-segment display connections
    INST7: Moore_State_Machine PORT MAP (sm_clken, pb(3), EWsm, NSsm, blink_sig, NS_Crossing, EW_Crossing, NSA, NSG, NSD, EWA, EWG, EWD, state_num_leds, EW_reset, NS_reset);
    NSSevenSegment <= NSG & "00" & NSD & "00" & NSA;
    EWSevenSegment <= EWG & "00" & EWD & "00" & EWA;
    INST8: segment7_mux PORT MAP (clkin_50, NSSevenSegment, EWSevenSegment, seg7_data, seg7_char2, seg7_char1);

END SimpleCircuit;
