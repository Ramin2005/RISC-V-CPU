LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY MainControl IS
    PORT (
        Instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        MemRead : OUT STD_LOGIC;
        MemWrite : OUT STD_LOGIC;
        RegWrite : OUT STD_LOGIC;
        RegSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        PCSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        ALUSrcA : OUT STD_LOGIC;
        ALUSrcB : OUT STD_LOGIC;
        ALUSelect : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
    );
END ENTITY MainControl;

ARCHITECTURE Struct OF MainControl IS
BEGIN

END Struct;