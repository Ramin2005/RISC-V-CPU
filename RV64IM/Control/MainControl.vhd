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
        ALUSrcA, ALUSrcB : OUT STD_LOGIC;
        ALUSelect : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
    );
END ENTITY MainControl;

ARCHITECTURE Struct OF MainControl IS
    SIGNAL SigMemRead : STD_LOGIC;
    SIGNAL SigMemWrite : STD_LOGIC;
    SIGNAL SigRegWrite : STD_LOGIC;
    SIGNAL SigRegSrc : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL SigPCSrc : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL SigALUSrcA, SigALUSrcB : STD_LOGIC;
    SIGNAL SigALUSelect : STD_LOGIC_VECTOR(5 DOWNTO 0);

    SIGNAL SigALUOpcode : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL SigOpcode : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL SigFunct3 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL SigFunct7 : STD_LOGIC_VECTOR(6 DOWNTO 0);
BEGIN

    SigOpcode <= Instruction(6 DOWNTO 0);
    SigFunct3 <= Instruction(14 DOWNTO 12);
    SigFunct7 <= Instruction(31 DOWNTO 25);

    Control : ENTITY work.Control
        PORT MAP(
            Opcode => SigOpcode,
            MemRead => SigMemRead,
            MemWrite => SigMemWrite,
            RegWrite => SigRegWrite,
            RegSrc => SigRegSrc,
            PCSrc => SigPCSrc,
            ALUSrcA => SigALUSrcA,
            ALUSrcB => SigALUSrcB,
            ALUOpcode => SigALUOpcode
        );

    ALUControl : ENTITY work.ALUControl
        PORT MAP(
            funct3 => SigFunct3,
            funct7 => SigFunct7,
            ALUOpcode => SigALUOpcode,
            ALUSelect => SigALUSelect
        );

    MemRead <= SigMemRead;
    MemWrite <= SigMemWrite;
    RegWrite <= SigRegWrite;
    RegSrc <= SigRegSrc;
    PCSrc <= SigPCSrc;
    ALUSrcA <= SigALUSrcA;
    ALUSrcB <= SigALUSrcB;
    ALUSelect <= SigALUSelect;
END Struct;