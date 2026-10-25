LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY PCRegister IS
    PORT (
        CLK : IN STD_LOGIC;
        Reset : IN STD_LOGIC;
        DataIn : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        Q : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
END ENTITY PCRegister;

-- Architecture of Program Counter Register
ARCHITECTURE Struct OF PCRegister IS

    SIGNAL QR : STD_LOGIC_VECTOR(63 DOWNTO 0);

BEGIN

    PROCESS (CLK)
    BEGIN

        IF rising_edge(CLK) AND Reset = '1' THEN
            QR <= (OTHERS => '0');

        ELSIF rising_edge(CLK) THEN
            QR <= DataIn;

        END IF;

    END PROCESS;

    Q <= QR;

END Struct;