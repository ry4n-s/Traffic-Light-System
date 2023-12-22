LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Entity declaration for holding_register
ENTITY holding_register IS
    PORT (
        clk          : IN  std_logic;     -- Clock input
        reset        : IN  std_logic;     -- Chip-wide reset from push button 3
        register_clr : IN  std_logic;     -- Clear signal for the register
        din          : IN  std_logic;     -- Synchronized input
        dout         : OUT std_logic      -- Output of the holding register
    );
END holding_register;

-- Architecture of holding_register
ARCHITECTURE circuit OF holding_register IS
    SIGNAL sreg : std_logic; -- The output Q of the D flip-flop

BEGIN
    -- Holding process to monitor pedestrian inputs
    holding : PROCESS (clk, reset, register_clr, din)
    BEGIN
        IF rising_edge(clk) THEN
            IF reset = '1' THEN
                sreg <= '0'; -- Reset output to 0
            ELSE
                sreg <= (din OR sreg) AND NOT(register_clr); -- Logic from the diagram in the manual
            END IF;
        END IF;

        dout <= sreg; -- The output Q becomes the final output
    END PROCESS holding;

END circuit;
