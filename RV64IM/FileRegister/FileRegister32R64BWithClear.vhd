LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FileRegister32R64BWithClear IS
    PORT (
        AddressA, AddressB, AddressW : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        WriteEnable : IN STD_LOGIC;
        Clk : IN STD_LOGIC;
        Clear : IN STD_LOGIC;
        DataIn : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        DataOutA, DataOutB : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
END ENTITY FileRegister32R64BWithClear;

ARCHITECTURE Struct OF FileRegister32R64BWithClear IS

    TYPE DataArray IS ARRAY (31 DOWNTO 0) OF STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL Data : DataArray;

BEGIN

    PROCESS (Clk)
    BEGIN

        IF rising_edge(CLK) AND Clear = '1' THEN

            FOR i IN 31 DOWNTO 0 LOOP
                Data(i) <= (OTHERS => '0');
            END LOOP;

        ELSIF rising_edge(CLK) AND WriteEnable = '1' THEN

            IF unsigned(AddressW) >= 0 THEN
                Data(to_integer(unsigned(AddressW))) <= DataIn;
            END IF;
            
        END IF;

    END PROCESS;

    DataOutA <= Data(to_integer(unsigned(AddressA)));
    DataOutB <= Data(to_integer(unsigned(AddressB)));

END Struct;