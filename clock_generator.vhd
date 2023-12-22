LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Entity declaration for Clock_generator
ENTITY Clock_generator IS
    PORT (
        sim_mode  : IN  boolean;       -- Used to select the clocking frequency for the output signals
        reset     : IN  std_logic;     -- Resets the counters
        clkin     : IN  std_logic;     -- The input used for counter and register clocking
        sm_clken  : OUT std_logic;     -- The output used to enable the state machine to advance by 1 clk
        blink     : OUT std_logic      -- The output used for blink signal (25% the rate of sm_clken)
    );
END ENTITY;

-- Architecture declaration
ARCHITECTURE rtl OF Clock_generator IS
    SIGNAL digital_counter : std_logic_vector(24 downto 0);
    SIGNAL clk_1hz, clk_4hz : std_logic;
    SIGNAL sim_clk_blink, sim_clk_enbl : std_logic;
    SIGNAL clk_reg_extend : std_logic_vector(1 downto 0); -- Pipeline for single clock enable pulse signal
    SIGNAL blink_sig : std_logic;

BEGIN
    -- Clock divider process to generate 1Hz and 4Hz signals from 50MHz clkin
    clk_divider : PROCESS (clkin)
        VARIABLE counter : unsigned(24 downto 0);
    BEGIN
        IF rising_edge(clkin) THEN
            IF reset = '1' THEN
                counter := (others => '0'); -- Reset counter to 0
            ELSE
                counter := counter + 1; -- Increment counter
            END IF;
        END IF;
        digital_counter <= std_logic_vector(counter);
    END PROCESS clk_divider;

    clk_1hz <= digital_counter(24); -- Approximate 1Hz clock
    clk_4hz <= digital_counter(22); -- Approximate 4Hz clock
    sim_clk_enbl <= digital_counter(4);  -- Simulation clock enable
    sim_clk_blink <= digital_counter(2);  -- Simulation blink signal

    -- Clock extender process to create a single one-cycle enable pulse
    clk_extender : PROCESS (clkin)
    BEGIN
        IF rising_edge(clkin) THEN
            IF reset = '1' THEN
                clk_reg_extend <= (others => '0');
                blink_sig <= '0';
            ELSIF sim_mode THEN
                clk_reg_extend <= clk_reg_extend(0) & sim_clk_enbl; -- Simulation mode clock register
                blink_sig <= sim_clk_blink; -- Simulation mode blink signal
            ELSE
                clk_reg_extend <= clk_reg_extend(0) & clk_1hz; -- LogicalStep Board clock enable
                blink_sig <= clk_4hz; -- LogicalStep Board blink signal
            END IF;
        END IF;
    END PROCESS clk_extender;

    -- Assign output signals
    sm_clken <= clk_reg_extend(0) AND NOT clk_reg_extend(1);
    blink <= blink_sig;

END rtl;
