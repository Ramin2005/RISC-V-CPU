LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY UnsignedAdder64Bit IS
    PORT (
        A, B : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        Sum : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
END ENTITY UnsignedAdder64Bit;

ARCHITECTURE Struct OF UnsignedAdder64Bit IS
    SIGNAL Temp : unsigned(64 DOWNTO 0);
BEGIN

    Temp <= unsigned('0' & A) + unsigned('0' & B);
    Sum <= STD_LOGIC_VECTOR(Temp(63 DOWNTO 0));

END Struct;