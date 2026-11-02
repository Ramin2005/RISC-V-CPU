LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY PCControl IS
    PORT (
        PCSrc : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        ZeroFlag : IN STD_LOGIC;
        PCPlus4 : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        BranchAdd : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        ALUResult : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        NextPC : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
END ENTITY PCControl;

ARCHITECTURE Struct OF PCControl IS
BEGIN

    PROCESS (PCSrc, ZeroFlag, PCPlus4, BranchAdd, ALUResult)
    BEGIN
        IF PCSrc = "11" THEN
            NextPC <= ALUResult;

        ELSIF PCSrc = "10" THEN
            NextPC <= ALUResult;

        ELSIF PCSrc = "01" AND ZeroFlag = '1' THEN
            NextPC <= BranchAdd;

        ELSE
            NextPC <= PCPlus4;

        END IF;
    END PROCESS;

END Struct;