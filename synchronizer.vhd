LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Entity declaration for synchronizer
ENTITY synchronizer IS
    PORT (
        clk   : IN  std_logic;  -- Connected to the 50MHz common Global Clock (clkin_50)
        reset : IN  std_logic;  -- Resets to 0
        din   : IN  std_logic;  -- Original input that gets passed in
        dout  : OUT std_logic   -- Final output
    );
END synchronizer;

-- Architecture of synchronizer
ARCHITECTURE circuit OF synchronizer IS
    SIGNAL sreg : std_logic_vector(1 downto 0); -- First output, Q

BEGIN
    -- Synchronize process to align inputs with the clock
    synchronize : PROCESS (clk, reset, din)
    BEGIN
        IF rising_edge(clk) THEN
            IF reset = '1' THEN
                sreg <= "00"; -- Reset synchronously on a rising clock edge
            ELSE
                sreg <= sreg(0) & din; -- Process through the first D flip-flop
            END IF;
        END IF;

        dout <= sreg(1); -- Final output from the second D flip-flop's output
    END PROCESS synchronize;

END circuit;
