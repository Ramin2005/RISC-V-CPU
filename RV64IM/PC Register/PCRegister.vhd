LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY PCRegister IS
    PORT (
        Clk : IN STD_LOGIC;
        Clear : IN STD_LOGIC;
        DataIn : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        Q : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
END ENTITY PCRegister;

-- Architecture of Program Counter Register
ARCHITECTURE Struct OF PCRegister IS

    SIGNAL QR : STD_LOGIC_VECTOR(63 DOWNTO 0);

BEGIN

    PROCESS (Clk, Clear, DataIn)
    BEGIN

        IF rising_edge(Clk) AND Clear = '1' THEN
            QR <= (OTHERS => '0');

        ELSIF rising_edge(Clk) THEN
            QR <= DataIn;

        END IF;

    END PROCESS;

    Q <= QR;

END Struct;