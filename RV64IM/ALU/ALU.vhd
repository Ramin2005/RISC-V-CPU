-- RV64IM Base + Custom ALU Extensions

-- Arithmetic Operations:
-- ADD          -> opcode: "000000"(0)
-- SUB          -> opcode: "000001"(1)
-- ADDW         -> opcode: "000010"(2)
-- SUBW         -> opcode: "000011"(3)
-- ABS          -> opcode: "000100"(4)  -- Outside: Custom
-- ABSW         -> opcode: "000101"(5)  -- Outside: Custom
-- MUL          -> opcode: "000110"(6)
-- MULH         -> opcode: "000111"(7)
-- MULHSU       -> opcode: "001000"(8)
-- MULHU        -> opcode: "001001"(9)
-- MULW         -> opcode: "001010"(10)
-- DIV          -> opcode: "001011"(11)
-- DIVU         -> opcode: "001100"(12)
-- DIVW         -> opcode: "001101"(13)
-- DIVUW        -> opcode: "001110"(14)
-- REM          -> opcode: "001111"(15)
-- REMU         -> opcode: "010000"(16)
-- REMW         -> opcode: "010001"(17)
-- REMUW        -> opcode: "010010"(18)

-- Logic Operations:
-- NOT          -> opcode: "010011"(19) -- Outside: Pseudo (XORI)
-- AND          -> opcode: "010100"(20)
-- OR           -> opcode: "010101"(21)
-- XOR          -> opcode: "010110"(22)
-- ANDN         -> opcode: "010111"(23) -- Outside: Zbb
-- ORN          -> opcode: "011000"(24) -- Outside: Zbb
-- XORN         -> opcode: "011001"(25) -- Outside: XNOR (Zbb)
-- NAND         -> opcode: "011010"(26) -- Outside: Custom
-- NOR          -> opcode: "011011"(27) -- Outside: Custom
-- XNOR         -> opcode: "011100"(28) -- Outside: Zbb

-- Compare Operations:
-- A == B       -> opcode: "011101"(29) -- BEQ
-- A != B       -> opcode: "011110"(30) -- BNE
-- A < B        -> opcode: "011111"(31) -- SLT
-- Un A < B     -> opcode: "100000"(32) -- SLTU
-- A <= B       -> opcode: "100001"(33) -- BGE
-- Un A <= B    -> opcode: "100010"(34) -- BGEU

-- Shift and Rotate Operations:
-- SLL          -> opcode: "100011"(35)
-- SRL          -> opcode: "100100"(36)
-- SRA          -> opcode: "100101"(37)
-- ROL          -> opcode: "100110"(38) -- Outside: Zbb
-- ROR          -> opcode: "100111"(39) -- Outside: Zbb
-- SLLW         -> opcode: "101000"(40)
-- SRLW         -> opcode: "101001"(41)
-- SRAW         -> opcode: "101010"(42)
-- ROLW         -> opcode: "101011"(43) -- Outside: Zbb
-- RORW         -> opcode: "101100"(44) -- Outside: Zbb

-- Min/Max Operations:
-- MIN          -> opcode: "101101"(45) -- Outside: Zbb
-- MINU         -> opcode: "101110"(46) -- Outside: Zbb
-- MAX          -> opcode: "101111"(47) -- Outside: Zbb
-- MAXU         -> opcode: "110000"(48) -- Outside: Zbb

-- Bit Count Operations:
-- CLZ          -> opcode: "110001"(49) -- Outside: Zbb
-- CTZ          -> opcode: "110010"(50) -- Outside: Zbb
-- CPOP         -> opcode: "110011"(51) -- Outside: Zbb

-- Shift and Add Operations:
-- SH1ADD       -> opcode: "110100"(52)
-- SH2ADD       -> opcode: "110101"(53)
-- SH3ADD       -> opcode: "110110"(54)
-- SH4ADD       -> opcode: "110111"(55) -- Outside: Custom
-- SH8ADD       -> opcode: "111000"(56) -- Outside: Custom
-- ADDUW        -> opcode: "111001"(57) -- ADD.UW

-- Bit Manipulation Operations:
-- BSET         -> opcode: "111010"(58) -- Outside: Zbs
-- BCLR         -> opcode: "111011"(59) -- Outside: Zbs
-- BINV         -> opcode: "111100"(60) -- Outside: Zbs
-- BEXT         -> opcode: "111101"(61) -- Outside: Zbs

-- Other Operations:
-- REV8         -> opcode: "111110"(62) -- Outside: Zbb
-- ORC.B        -> opcode: "111111"(63) -- Outside: Zbb

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ALU IS
    PORT (
        A : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        B : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
        S : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        Result : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
        Zero : OUT STD_LOGIC
    );
END ENTITY ALU;

-- Architecture of ALU
ARCHITECTURE struct OF ALU IS

    -- Arithmetic result signals
    SIGNAL ResultADD, ResultSUB : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultADDW, ResultSUBW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultABS, ResultABSW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultMUL : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultMULH : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultMULHSU : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultMULHU : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultMULW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultDIV, ResultDIVU : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultDIVW, ResultDIVUW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultREM, ResultREMU : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultREMW, ResultREMUW : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Logic result signals
    SIGNAL ResultNOT : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultAND, ResultOR, ResultXOR : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultANDN, ResultORN, ResultXORN : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultNAND, ResultNOR, ResultXNOR : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Compare result signals
    SIGNAL ResultEQ, ResultNEQ : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultL, ResultUnL : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultLE, ResultUnLE : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Shift and Rotating result signals
    SIGNAL ResultSLL, ResultSRL, ResultSRA : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultROL, ResultROR : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultSLLW, ResultSRLW, ResultSRAW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultROLW, ResultRORW : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Custom Compare result signals
    SIGNAL ResultMIN, ResultMINU : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultMAX, ResultMAXU : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Custom Bit Count result signals
    SIGNAL ResultCLZ, ResultCTZ, ResultCPOP : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Custom Shift and Add (ZBA) result signals
    SIGNAL ResultSH1ADD, ResultSH2ADD, ResultSH3ADD,
    ResultSH4ADD, ResultSH8ADD : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultADDUW : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Custom Bit Manipulation result signals
    SIGNAL ResultBSET : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultBCLR : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultBINV : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultBEXT : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Other Custom Operations signals
    SIGNAL ResultREV8 : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ResultORCB : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Temporary signals
    -- 5, 6 Low bit unsigned temps
    SIGNAL TempBN5 : unsigned(4 DOWNTO 0);
    SIGNAL TempBN6 : unsigned(5 DOWNTO 0);
    SIGNAL TempBS : STD_LOGIC_VECTOR(63 DOWNTO 0);
    -- 32 Low bits temps
    SIGNAL TempAL, TempBL : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    -- Signed and Unsigned of A, B, AL, BL temps
    SIGNAL TempSA, TempSB : signed (63 DOWNTO 0) := (OTHERS => '0');
    SIGNAL TempUA, TempUB : unsigned (63 DOWNTO 0) := (OTHERS => '0');
    SIGNAL TempSAL, TempSBL : signed (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL TempUAL, TempUBL : unsigned (31 DOWNTO 0) := (OTHERS => '0');
    -- Abs of Signed of A, B, AL, BL temps
    SIGNAL TempAbsA, TempAbsB : signed (63 DOWNTO 0) := (OTHERS => '0');
    SIGNAL TempAbsAL, TempAbsBL : signed (31 DOWNTO 0) := (OTHERS => '0');
    -- Arithmetic temps
    SIGNAL TempADD, TempSUB : unsigned(64 DOWNTO 0);
    SIGNAL TempADDW, TempSUBW : unsigned(32 DOWNTO 0);
    SIGNAL TempMULSS : STD_LOGIC_VECTOR(127 DOWNTO 0);
    SIGNAL TempMULSU : STD_LOGIC_VECTOR(129 DOWNTO 0);
    SIGNAL TempMULUU : STD_LOGIC_VECTOR(127 DOWNTO 0);
    SIGNAL TempDIVW, TempREMW : signed (31 DOWNTO 0);
    SIGNAL TempDIVUW, TempREMUW : unsigned (31 DOWNTO 0);
    SIGNAL TempREM : signed (63 DOWNTO 0);
    -- Shift and Routing temps
    SIGNAL TempSLLW, TempSRLW, TempSRAW : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL TempROLW, TempRORW : STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- Custom Shift and Add operations temps
    SIGNAL TempSH1ADD, TempSH2ADD, TempSH3ADD,
    TempSH4ADD, TempSH8ADD : signed(64 DOWNTO 0);
    -- Other operations temps
    SIGNAL TempORCB0, TempORCB1, TempORCB2, TempORCB3, TempORCB4,
    TempORCB5, TempORCB6, TempORCB7 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    -- Result temp
    SIGNAL TempResult : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Enable and Select Signals
    SIGNAL Enable : STD_LOGIC_VECTOR(63 DOWNTO 0);

    -- Constants
    CONSTANT ConstantZero : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '0');
    CONSTANT ConstantFull : STD_LOGIC_VECTOR(63 DOWNTO 0) := (OTHERS => '1');
BEGIN

    TempBN5 <= unsigned(B(4 DOWNTO 0));
    TempBN6 <= unsigned(B(5 DOWNTO 0));
    TempAL <= A(31 DOWNTO 0);
    TempBL <= B(31 DOWNTO 0);
    TempSA <= signed(A);
    TempSB <= signed(B);
    TempUA <= unsigned(A);
    TempUB <= unsigned(B);
    TempSAL <= signed(TempAL);
    TempSBL <= signed(TempBL);
    TempUAL <= unsigned(TempAL);
    TempUBL <= unsigned(TempBL);
    TempAbsA <= ABS(TempSA);
    TempAbsB <= ABS(TempSB);
    TempAbsAL <= ABS(TempSAL);
    TempAbsBL <= ABS(TempSBL);

    ------------------------------------------------------------------------------------------
    -- Arithmetic operations
    TempMULSS <= STD_LOGIC_VECTOR(TempSA * TempSB);
    TempMULSU <= STD_LOGIC_VECTOR(signed(A(63) & A) * signed('0' & B));
    TempMULUU <= STD_LOGIC_VECTOR(TempUA * TempUB);

    -- MUL
    ResultMUL <= TempMULSS(63 DOWNTO 0);

    -- MULH
    ResultMULH <= TempMULSS(127 DOWNTO 64);

    -- MULHSU
    ResultMULHSU <= TempMULSU(127 DOWNTO 64);

    -- MULHU
    ResultMULHU <= TempMULUU(127 DOWNTO 64);

    -- MULW
    ResultMULW <= (63 DOWNTO 32 => TempMULSS(31)) & TempMULSS(31 DOWNTO 0);

    -- DIV
    ResultDIV <= (OTHERS => '1') WHEN TempSB = 0 ELSE
        STD_LOGIC_VECTOR(TempSA / TempSB);

    -- DIVU
    ResultDIVU <= (OTHERS => '1') WHEN TempUB = 0 ELSE
        STD_LOGIC_VECTOR(TempUA / TempUB);

    -- DIVW
    TempDIVW <= TempSAL / TempSBL WHEN TempSBL /= 0 ELSE
        (OTHERS => '0');
    ResultDIVW <= (OTHERS => '1') WHEN TempSBL = 0 ELSE
        (63 DOWNTO 32 => TempDIVW(31)) & STD_LOGIC_VECTOR(TempDIVW(31 DOWNTO 0));

    -- DIVUW
    TempDIVUW <= TempUAL / TempUBL WHEN TempUBL /= 0 ELSE
        (OTHERS => '0');
    ResultDIVUW <= (OTHERS => '1') WHEN TempUBL = 0 ELSE
        (63 DOWNTO 32 => TempDIVUW(31)) & STD_LOGIC_VECTOR(TempDIVUW(31 DOWNTO 0));

    -- REM
    TempREM <= signed(unsigned(TempAbsA) MOD unsigned(TempAbsB)) WHEN TempAbsB /= 0 ELSE
        (OTHERS => '0');
    ResultREM <= A WHEN TempAbsB = 0 ELSE
        STD_LOGIC_VECTOR(TempREM) WHEN TempSA >= 0 ELSE
        STD_LOGIC_VECTOR(-TempREM);

    -- REMU
    ResultREMU <= A WHEN TempUB = 0 ELSE
        STD_LOGIC_VECTOR(TempUA MOD TempUB);

    -- REMW
    TempREMW <= signed(unsigned(TempAbsAL) MOD unsigned(TempAbsBL)) WHEN TempAbsBL /= 0 ELSE
        (OTHERS => '0');
    ResultREMW <= ((63 DOWNTO 32 => A(31)) & A(31 DOWNTO 0)) WHEN TempSBL = 0 ELSE
        (63 DOWNTO 32 => TempREMW(31)) & STD_LOGIC_VECTOR(TempREMW) WHEN TempSAL >= 0 ELSE
        STD_LOGIC_VECTOR(RESIZE(-TempREMW, 64));

    -- REMUW
    TempREMUW <= TempUAL MOD TempUBL WHEN TempUBL /= 0 ELSE
        (OTHERS => '0');
    ResultREMUW <= ((63 DOWNTO 32 => A(31)) & A(31 DOWNTO 0)) WHEN TempSBL = 0 ELSE
        (63 DOWNTO 32 => TempREMUW(31)) & STD_LOGIC_VECTOR(TempREMUW);

    -- ADD
    TempADD <= unsigned('0' & A) + unsigned('0' & B);
    ResultADD <= STD_LOGIC_VECTOR(TempADD(63 DOWNTO 0));

    -- SUB
    TempSUB <= unsigned('0' & A) + unsigned('0' & (NOT B)) + to_unsigned(1, 65);
    ResultSUB <= STD_LOGIC_VECTOR(TempSUB(63 DOWNTO 0));

    -- ADDW
    TempADDW <= unsigned('0' & TempAL) + unsigned('0' & TempBL);
    ResultADDW <= (31 DOWNTO 0 => TempADDW(31)) & STD_LOGIC_VECTOR(TempADDW(31 DOWNTO 0));

    -- SUBW
    TempSUBW <= unsigned('0' & TempAL) + unsigned('0' & (NOT TempBL)) + to_unsigned(1, 33);
    ResultSUBW <= (31 DOWNTO 0 => TempSUBW(31)) & STD_LOGIC_VECTOR(TempSUBW(31 DOWNTO 0));

    -- ABS
    ResultABS <= STD_LOGIC_VECTOR(TempAbsA);

    -- ABSW
    ResultABSW <= (63 DOWNTO 32 => TempAbsAL(31)) & STD_LOGIC_VECTOR(TempAbsAL);
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Logic Operations
    -- NOT
    ResultNOT <= NOT A;
    -- AND
    ResultAND <= A AND B;
    -- OR
    ResultOR <= A OR B;
    -- XOR
    ResultXOR <= A XOR B;
    -- ANDN
    ResultANDN <= A AND NOT B;
    -- ORN
    ResultORN <= A OR NOT B;
    -- XORN
    ResultXORN <= A XOR NOT B;
    -- NAND
    ResultNAND <= A NAND B;
    -- NOR
    ResultNOR <= A NOR B;
    -- XNOR
    ResultXNOR <= A XNOR B;
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Compare operations
    -- A = B
    ResultEQ <= (0 => '1', OTHERS => '0') WHEN A = B ELSE
        ConstantZero;

    -- A != B
    ResultNEQ <= (0 => '1', OTHERS => '0') WHEN A /= B ELSE
        ConstantZero;

    -- A < B
    ResultL <= (0 => '1', OTHERS => '0') WHEN TempSA < TempSB ELSE
        ConstantZero;

    -- Un A < B
    ResultUnL <= (0 => '1', OTHERS => '0') WHEN TempUA < TempUB ELSE
        ConstantZero;

    -- A <= B
    ResultLE <= (0 => '1', OTHERS => '0') WHEN TempSA <= TempSB ELSE
        ConstantZero;

    -- Un A <= B
    ResultUnLE <= (0 => '1', OTHERS => '0') WHEN TempUA <= TempUB ELSE
        ConstantZero;
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Shift and Rotating operations
    -- SLL
    ResultSLL <= STD_LOGIC_VECTOR(SHIFT_LEFT(TempUA, to_integer(TempBN6)));

    -- SRL
    ResultSRL <= STD_LOGIC_VECTOR(SHIFT_RIGHT(TempUA, to_integer(TempBN6)));

    -- SRA
    ResultSRA <= STD_LOGIC_VECTOR(SHIFT_RIGHT(TempSA, to_integer(TempBN6)));

    -- ROL
    ResultROL <= STD_LOGIC_VECTOR(ROTATE_LEFT(TempUA, to_integer(TempBN6)));

    -- ROR
    ResultROR <= STD_LOGIC_VECTOR(ROTATE_RIGHT(TempUA, to_integer(TempBN6)));

    -- SLLW
    TempSLLW <= STD_LOGIC_VECTOR(SHIFT_LEFT(TempUAL, to_integer(TempBN5)));
    ResultSLLW <= (63 DOWNTO 32 => TempSLLW(31)) & TempSLLW;

    -- SRLW
    TempSRLW <= STD_LOGIC_VECTOR(SHIFT_RIGHT(TempUAL, to_integer(TempBN5)));
    ResultSRLW <= (63 DOWNTO 32 => TempSRLW(31)) & TempSRLW;

    -- SRAW
    TempSRAW <= STD_LOGIC_VECTOR(SHIFT_RIGHT(TempSAL, to_integer(TempBN5)));
    ResultSRAW <= (63 DOWNTO 32 => TempSRAW(31)) & TempSRAW;

    -- ROLW
    TempROLW <= STD_LOGIC_VECTOR(ROTATE_LEFT(TempUAL, to_integer(TempBN5)));
    ResultROLW <= (63 DOWNTO 32 => TempROLW(31)) & TempROLW;

    -- RORW
    TempRORW <= STD_LOGIC_VECTOR(ROTATE_RIGHT(TempUAL, to_integer(TempBN5)));
    ResultRORW <= (63 DOWNTO 32 => TempRORW(31)) & TempRORW;
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Custom Compare Operations
    -- MIN
    ResultMIN <= A WHEN TempSA < TempSB ELSE
        B;

    -- MINU
    ResultMINU <= A WHEN TempUA < TempUB ELSE
        B;

    -- MAX
    ResultMAX <= A WHEN TempSA > TempSB ELSE
        B;

    -- MAXU
    ResultMAXU <= A WHEN TempUA > TempUB ELSE
        B;
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Custom Bit Count Operations
    PROCESS (A)
        VARIABLE VarCLZ, VarCTZ, VarCPOP : INTEGER;
    BEGIN
        -- CLZ
        VarCLZ := 64;
        FOR i IN 63 DOWNTO 0 LOOP
            IF A(i) = '1' THEN
                VarCLZ := 63 - i;
                EXIT;
            END IF;
        END LOOP;
        ResultCLZ <= STD_LOGIC_VECTOR(to_unsigned(VarCLZ, 64));

        -- CTZ
        VarCTZ := 64;
        FOR i IN 0 TO 63 LOOP
            IF A(i) = '1' THEN
                VarCTZ := i;
                EXIT;
            END IF;
        END LOOP;
        ResultCTZ <= STD_LOGIC_VECTOR(to_unsigned(VarCTZ, 64));

        -- CPOP
        VarCPOP := 0;
        FOR i IN 0 TO 63 LOOP
            IF A(i) = '1' THEN
                VarCPOP := VarCPOP + 1;
            END IF;
        END LOOP;
        ResultCPOP <= STD_LOGIC_VECTOR(to_unsigned(VarCPOP, 64));
    END PROCESS;
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- CCustom Shift and Add (ZBA) Operations
    -- SH1ADD
    TempSH1ADD <= SHIFT_LEFT((TempSA(63) & TempSA), 1) + (TempSB(63) & TempSB);
    ResultSH1ADD <= STD_LOGIC_VECTOR(TempSH1ADD(63 DOWNTO 0));

    -- SH2ADD
    TempSH2ADD <= SHIFT_LEFT((TempSA(63) & TempSA), 2) + (TempSB(63) & TempSB);
    ResultSH2ADD <= STD_LOGIC_VECTOR(TempSH2ADD(63 DOWNTO 0));

    -- SH3ADD
    TempSH3ADD <= SHIFT_LEFT((TempSA(63) & TempSA), 3) + (TempSB(63) & TempSB);
    ResultSH3ADD <= STD_LOGIC_VECTOR(TempSH3ADD(63 DOWNTO 0));

    -- SH4ADD
    TempSH4ADD <= SHIFT_LEFT((TempSA(63) & TempSA), 4) + (TempSB(63) & TempSB);
    ResultSH4ADD <= STD_LOGIC_VECTOR(TempSH4ADD(63 DOWNTO 0));

    -- SH8ADD
    TempSH8ADD <= SHIFT_LEFT((TempSA(63) & TempSA), 8) + (TempSB(63) & TempSB);
    ResultSH8ADD <= STD_LOGIC_VECTOR(TempSH8ADD(63 DOWNTO 0));

    -- ADDUW
    ResultADDUW <= STD_LOGIC_VECTOR(unsigned(ConstantZero(31 DOWNTO 0) & TempAL) + TempUB);
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Custom Bit Manipulation Operations
    TempBS <= STD_LOGIC_VECTOR(shift_left(to_unsigned(1, 64), to_integer(TempBN6)));

    -- BSET
    ResultBSET <= A OR TempBS;

    -- BCLR
    ResultBCLR <= A AND NOT TempBS;

    -- BINV
    ResultBINV <= A XOR TempBS;

    -- BEXT
    ResultBEXT <= (0 => A(to_integer(TempBN6)), OTHERS => '0');
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Other Custom Operations
    -- REV8
    ResultREV8 <= A(7 DOWNTO 0) & A(15 DOWNTO 8) & A(23 DOWNTO 16) & A(31 DOWNTO 24)
        & A(39 DOWNTO 32) & A(47 DOWNTO 40) & A(55 DOWNTO 48) & A(63 DOWNTO 56);

    -- ORCB 
    TempORCB0 <= (OTHERS => '0') WHEN A(7 DOWNTO 0) = ConstantZero(7 DOWNTO 0) ELSE
        (OTHERS => '1');
    TempORCB1 <= (OTHERS => '0') WHEN A(15 DOWNTO 8) = ConstantZero(7 DOWNTO 0) ELSE
        (OTHERS => '1');
    TempORCB2 <= (OTHERS => '0') WHEN A(23 DOWNTO 16) = ConstantZero(7 DOWNTO 0) ELSE
        (OTHERS => '1');
    TempORCB3 <= (OTHERS => '0') WHEN A(31 DOWNTO 24) = ConstantZero(7 DOWNTO 0) ELSE
        (OTHERS => '1');
    TempORCB4 <= (OTHERS => '0') WHEN A(39 DOWNTO 32) = ConstantZero(7 DOWNTO 0) ELSE
        (OTHERS => '1');
    TempORCB5 <= (OTHERS => '0') WHEN A(47 DOWNTO 40) = ConstantZero(7 DOWNTO 0) ELSE
        (OTHERS => '1');
    TempORCB6 <= (OTHERS => '0') WHEN A(55 DOWNTO 48) = ConstantZero(7 DOWNTO 0) ELSE
        (OTHERS => '1');
    TempORCB7 <= (OTHERS => '0') WHEN A(63 DOWNTO 56) = ConstantZero(7 DOWNTO 0) ELSE
        (OTHERS => '1');
    ResultORCB <= TempORCB7 & TempORCB6 & TempORCB5 & TempORCB4
        & TempORCB3 & TempORCB2 & TempORCB1 & TempORCB0;
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Enable and Select
    Enable <= STD_LOGIC_VECTOR(shift_left(to_unsigned(1, 64), to_integer(unsigned(S))));
    ------------------------------------------------------------------------------------------

    ------------------------------------------------------------------------------------------
    -- Multiplexing
    TempResult <=
        -- Arithmetic operations
        (ResultADD AND (63 DOWNTO 0 => Enable(0)))
        OR (ResultSUB AND (63 DOWNTO 0 => Enable(1)))
        OR (ResultADDW AND (63 DOWNTO 0 => Enable(2)))
        OR (ResultSUBW AND (63 DOWNTO 0 => Enable(3)))
        OR (ResultABS AND (63 DOWNTO 0 => Enable(4)))
        OR (ResultABSW AND (63 DOWNTO 0 => Enable(5)))
        OR (ResultMUL AND (63 DOWNTO 0 => Enable(6)))
        OR (ResultMULH AND (63 DOWNTO 0 => Enable(7)))
        OR (ResultMULHSU AND (63 DOWNTO 0 => Enable(8)))
        OR (ResultMULHU AND (63 DOWNTO 0 => Enable(9)))
        OR (ResultMULW AND (63 DOWNTO 0 => Enable(10)))
        OR (ResultDIV AND (63 DOWNTO 0 => Enable(11)))
        OR (ResultDIVU AND (63 DOWNTO 0 => Enable(12)))
        OR (ResultDIVW AND (63 DOWNTO 0 => Enable(13)))
        OR (ResultDIVUW AND (63 DOWNTO 0 => Enable(14)))
        OR (ResultREM AND (63 DOWNTO 0 => Enable(15)))
        OR (ResultREMU AND (63 DOWNTO 0 => Enable(16)))
        OR (ResultREMW AND (63 DOWNTO 0 => Enable(17)))
        OR (ResultREMUW AND (63 DOWNTO 0 => Enable(18)))
        -- Logic operations
        OR (ResultNOT AND (63 DOWNTO 0 => Enable(19)))
        OR (ResultAND AND (63 DOWNTO 0 => Enable(20)))
        OR (ResultOR AND (63 DOWNTO 0 => Enable(21)))
        OR (ResultXOR AND (63 DOWNTO 0 => Enable(22)))
        OR (ResultANDN AND (63 DOWNTO 0 => Enable(23)))
        OR (ResultORN AND (63 DOWNTO 0 => Enable(24)))
        OR (ResultXORN AND (63 DOWNTO 0 => Enable(25)))
        OR (ResultNAND AND (63 DOWNTO 0 => Enable(26)))
        OR (ResultNOR AND (63 DOWNTO 0 => Enable(27)))
        OR (ResultXNOR AND (63 DOWNTO 0 => Enable(28)))
        -- Compare operations
        OR (ResultEQ AND (63 DOWNTO 0 => Enable(29)))
        OR (ResultNEQ AND (63 DOWNTO 0 => Enable(30)))
        OR (ResultL AND (63 DOWNTO 0 => Enable(31)))
        OR (ResultUnL AND (63 DOWNTO 0 => Enable(32)))
        OR (ResultLE AND (63 DOWNTO 0 => Enable(33)))
        OR (ResultUnLE AND (63 DOWNTO 0 => Enable(34)))
        -- Shift and Rotating operations
        OR (ResultSLL AND (63 DOWNTO 0 => Enable(35)))
        OR (ResultSRL AND (63 DOWNTO 0 => Enable(36)))
        OR (ResultSRA AND (63 DOWNTO 0 => Enable(37)))
        OR (ResultROL AND (63 DOWNTO 0 => Enable(38)))
        OR (ResultROR AND (63 DOWNTO 0 => Enable(39)))
        OR (ResultSLLW AND (63 DOWNTO 0 => Enable(40)))
        OR (ResultSRLW AND (63 DOWNTO 0 => Enable(41)))
        OR (ResultSRAW AND (63 DOWNTO 0 => Enable(42)))
        OR (ResultROLW AND (63 DOWNTO 0 => Enable(43)))
        OR (ResultRORW AND (63 DOWNTO 0 => Enable(44)))
        -- Custom Compare operations
        OR (ResultMIN AND (63 DOWNTO 0 => Enable(45)))
        OR (ResultMINU AND (63 DOWNTO 0 => Enable(46)))
        OR (ResultMAX AND (63 DOWNTO 0 => Enable(47)))
        OR (ResultMAXU AND (63 DOWNTO 0 => Enable(48)))
        -- Custom Bit Count operations
        OR (ResultCLZ AND (63 DOWNTO 0 => Enable(49)))
        OR (ResultCTZ AND (63 DOWNTO 0 => Enable(50)))
        OR (ResultCPOP AND (63 DOWNTO 0 => Enable(51)))
        -- Custom Shift and Add (ZBA) operations
        OR (ResultSH1ADD AND (63 DOWNTO 0 => Enable(52)))
        OR (ResultSH2ADD AND (63 DOWNTO 0 => Enable(53)))
        OR (ResultSH3ADD AND (63 DOWNTO 0 => Enable(54)))
        OR (ResultSH4ADD AND (63 DOWNTO 0 => Enable(55)))
        OR (ResultSH8ADD AND (63 DOWNTO 0 => Enable(56)))
        OR (ResultADDUW AND (63 DOWNTO 0 => Enable(57)))
        -- Custom Bit Manipulation operations
        OR (ResultBSET AND (63 DOWNTO 0 => Enable(58)))
        OR (ResultBCLR AND (63 DOWNTO 0 => Enable(59)))
        OR (ResultBINV AND (63 DOWNTO 0 => Enable(60)))
        OR (ResultBEXT AND (63 DOWNTO 0 => Enable(61)))
        -- Other Custom operations
        OR (ResultREV8 AND (63 DOWNTO 0 => Enable(62)))
        OR (ResultORCB AND (63 DOWNTO 0 => Enable(63)));

    Result <= TempResult;

    Zero <= '1' WHEN TempResult = ConstantZero ELSE
        '0';

END struct;