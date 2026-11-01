LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ALUControl IS
    PORT (
        Instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALUOp : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ALUSelect : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
    );
END ENTITY ALUControl;

ARCHITECTURE Struct OF ALUControl IS
BEGIN

    PROCESS (Instruction)
    BEGIN
    END PROCESS;

END Struct;