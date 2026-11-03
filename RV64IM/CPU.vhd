LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY CPU IS
    PORT (
        -- Reset & Clock Signal
        Clk : IN STD_LOGIC;
        Reset : IN STD_LOGIC;

        -- Data Memory
        MemoryAddress : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        MemoryMask : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MemoryWriteEnable : OUT STD_LOGIC;
        MemoryWriteData : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        MemoryReadEnable : OUT STD_LOGIC;
        MemoryReadData : IN STD_LOGIC_VECTOR(63 DOWNTO 0);

        -- Instruction Memory
        InstructionAddress : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        InstructionIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY CPU;

ARCHITECTURE Struct OF CPU IS
    -- Constant 4
    CONSTANT Four : STD_LOGIC_VECTOR(63 DOWNTO 0) := (2 => '1', OTHERS => '0');

    -- Instruction Signal
    SIGNAL SigInstruction : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- PC
    SIGNAL SigPC : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL SigPCPlus4 : STD_LOGIC_VECTOR(63 DOWNTO 0);
    -- Control Unit Signals
    SIGNAL SigBranch : STD_LOGIC;
    SIGNAL SigMemRead : STD_LOGIC;
    SIGNAL SigMemWrite : STD_LOGIC;
    SIGNAL SigRegWrite : STD_LOGIC;
    SIGNAL SigRegSrc : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL SigPCSrc : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL SigALUSrcA, SigALUSrcB : STD_LOGIC;
    SIGNAL SigALUSelect : STD_LOGIC_VECTOR(5 DOWNTO 0);

    -- Register File
    SIGNAL SigRegDataIn : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL SigRegDataOutA, SigRegDataOutB : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Imm Gen
    SIGNAL SigImmediate : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- ALU
    SIGNAL SigA, SigB : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL SigResult : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL SigZeroFlag : STD_LOGIC;

    -- PC Control
    SIGNAL SigBranchAdd : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL SigNextPC : STD_LOGIC_VECTOR(63 DOWNTO 0);
BEGIN
    -- Instruction 
    SigInstruction <= InstructionIn;

    -- Control Unit
    ControlUnit : ENTITY work.MainControl
        PORT MAP(
            Instruction => SigInstruction,
            MemRead => SigMemRead,
            MemWrite => SigMemWrite,
            RegWrite => SigRegWrite,
            RegSrc => SigRegSrc,
            PCSrc => SigPCSrc,
            ALUSrcA => SigALUSrcA,
            ALUSrcB => SigALUSrcB,
            ALUSelect => SigALUSelect
        );

    -- Register File
    RegisterFile : ENTITY work.FileRegister32R64BWithClear
        PORT MAP(
            Clk => Clk,
            Clear => Reset,
            AddressA => SigInstruction(19 DOWNTO 15),
            AddressB => SigInstruction(24 DOWNTO 20),
            AddressW => SigInstruction(11 DOWNTO 7),
            WriteEnable => SigRegWrite,
            DataIn => SigRegDataIn,
            DataOutA => SigRegDataOutA,
            DataOutB => SigRegDataOutB
        );

    -- Imm Gen
    ImmGen : ENTITY work.ImmGen
        PORT MAP(
            Instruction => SigInstruction,
            Immediate => SigImmediate
        );

    -- Mux 1 (ALUSrc1)
    Mux1 : ENTITY work.MUX64B2To1
        PORT MAP(
            A => SigRegDataOutA,
            B => SigPC,
            S => SigALUSrcA,
            O => SigA
        );

    -- Mux 2 (ALUSrc2)
    Mux2 : ENTITY work.MUX64B2To1
        PORT MAP(
            A => SigRegDataOutB,
            B => SigImmediate,
            S => SigALUSrcB,
            O => SigB
        );

    -- ALU
    ALU : ENTITY work.ALU
        PORT MAP(
            A => SigA,
            B => SigB,
            S => SigALUSelect,
            Result => SigResult,
            Zero => SigZeroFlag
        );

    -- Memory Signals
    MemoryAddress <= SigResult;
    MemoryWriteData <= SigRegDataOutB;
    MemoryMask <= SigInstruction(14 DOWNTO 12);
    MemoryWriteEnable <= SigMemWrite;
    MemoryReadEnable <= SigMemRead;

    -- Mux 3 (Register File Src)
    Mux3 : ENTITY work.MUX64B4To1
        PORT MAP(
            A => SigResult,
            B => MemoryReadData,
            C => SigPCPlus4,
            D => SigImmediate,
            S => SigRegSrc,
            O => SigRegDataIn
        );

    -- Adder (PC + 4)
    PCAdder : ENTITY work.UnsignedAdder64Bit
        PORT MAP(
            A => SigPC,
            B => Four,
            sum => SigPCPlus4
        );

    -- Adder (PC + Imm)
    BranchAdder : ENTITY work.UnsignedAdder64Bit
        PORT MAP(
            A => SigPC,
            B => SigImmediate,
            sum => SigBranchAdd
        );
    -- Branch Signal
    SigBranch <= (NOT SigZeroFlag) XOR (SigInstruction(14) AND SigInstruction(12));

    -- PC Control
    PCControl : ENTITY work.PCControl
        PORT MAP(
            PCSrc => SigPCSrc,
            Branch => SigBranch,
            PCPlus4 => SigPCPlus4,
            BranchAdd => SigBranchAdd,
            ALUResult => SigResult,
            NextPC => SigNextPC
        );

    -- PC Register 
    PCRegister : ENTITY work.PCRegister
        PORT MAP(
            Clk => Clk,
            Clear => Reset,
            DataIn => SigNextPC,
            Q => SigPc
        );

    -- Instruction Address Signals
    InstructionAddress <= SigPc;

END Struct;