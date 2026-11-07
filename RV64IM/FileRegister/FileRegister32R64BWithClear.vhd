LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY FileRegister32R64BWithClear IS
    PORT (
        Clk : IN STD_LOGIC;
        Clear : IN STD_LOGIC;
        AddressA, AddressB, AddressW : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
        WriteEnable : IN STD_LOGIC;
        DataIn : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        DataOutA, DataOutB : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
END ENTITY FileRegister32R64BWithClear;

ARCHITECTURE Struct OF FileRegister32R64BWithClear IS

    TYPE DataArray IS ARRAY (31 DOWNTO 1) OF STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL Data : DataArray;

BEGIN

    PROCESS (Clk, Clear, WriteEnable, AddressW)
    BEGIN

        IF rising_edge(Clk) AND Clear = '1' THEN

            Data <= (OTHERS => (OTHERS => '0'));

        ELSIF rising_edge(Clk) AND WriteEnable = '1' THEN

            IF unsigned(AddressW) > 0 THEN
                Data(to_integer(unsigned(AddressW))) <= DataIn;
            END IF;

        END IF;

    END PROCESS;

    PROCESS (AddressA, AddressB, Data)
    BEGIN
        DataOutA <= (OTHERS => '0');
        IF to_integer(unsigned(AddressA)) > 0 THEN
            DataOutA <= Data(to_integer(unsigned(AddressA)));
        END IF;

        DataOutB <= (OTHERS => '0');
        IF to_integer(unsigned(AddressB)) > 0 THEN
            DataOutB <= Data(to_integer(unsigned(AddressB)));
        END IF;
    END PROCESS;

END Struct;