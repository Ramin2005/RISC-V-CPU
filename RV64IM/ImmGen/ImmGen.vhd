LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ImmGen IS
    PORT (
        Instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Immediate : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
    );
END ENTITY ImmGen;

ARCHITECTURE Struct OF ImmGen IS
    -- Immediate Inputs
    SIGNAL ShiftImm : unsigned(5 DOWNTO 0);
    SIGNAL ShiftWImm : unsigned(4 DOWNTO 0);
    SIGNAL RegularImm : signed(11 DOWNTO 0);
    SIGNAL StoreImm : signed(11 DOWNTO 0);
    SIGNAL UTypeImm : signed(31 DOWNTO 0);
    SIGNAL BTypeImm : signed(12 DOWNTO 0);
    SIGNAL JALImm : signed(20 DOWNTO 0);

    -- Immediate Results
    SIGNAL ImmediateShift : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ImmediateShiftW : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ImmediateRegular : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ImmediateStores : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ImmediateUType : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ImmediateBType : STD_LOGIC_VECTOR(63 DOWNTO 0);
    SIGNAL ImmediateJAL : STD_LOGIC_VECTOR(63 DOWNTO 0);
BEGIN
    -- Immediate Inputs
    ShiftImm <= unsigned(Instruction(25 DOWNTO 20));
    ShiftWImm <= unsigned(Instruction(24 DOWNTO 20));
    RegularImm <= signed(Instruction(31 DOWNTO 20));
    StoreImm <= signed(Instruction(31 DOWNTO 25) & Instruction(11 DOWNTO 7));
    UTypeImm <= signed(Instruction(31 DOWNTO 12) & x"000");
    BTypeImm <= signed(Instruction(31) & Instruction(7) & Instruction(30 DOWNTO 25) & Instruction(11 DOWNTO 8) & '0');
    JALImm <= signed(Instruction(31) & Instruction(19 DOWNTO 12) & Instruction(20) & Instruction(30 DOWNTO 21) & '0');

    -- Immediate Results
    ImmediateShift <= STD_LOGIC_VECTOR(RESIZE(ShiftImm, 64));
    ImmediateShiftW <= STD_LOGIC_VECTOR(RESIZE(ShiftWImm, 64));
    ImmediateRegular <= STD_LOGIC_VECTOR(RESIZE(RegularImm, 64));
    ImmediateStores <= STD_LOGIC_VECTOR(RESIZE(StoreImm, 64));
    ImmediateUType <= STD_LOGIC_VECTOR(RESIZE(UTypeImm, 64));
    ImmediateBType <= STD_LOGIC_VECTOR(RESIZE(BTypeImm, 64));
    ImmediateJAL <= STD_LOGIC_VECTOR(RESIZE(JALImm, 64));

    PROCESS (Instruction, ImmediateShift, ImmediateShiftW, ImmediateRegular,
        ImmediateStores, ImmediateUType, ImmediateBType, ImmediateJAL)
    BEGIN
        Immediate <= (OTHERS => '0');

        CASE Instruction(6 DOWNTO 0) IS
                -- I-Type Loads, JALR
            WHEN "0000011" | "1100111" =>
                Immediate <= ImmediateRegular;

                -- S-Type Stores
            WHEN "0100011" =>
                Immediate <= ImmediateStores;

                -- I-Type Arithmetic / Logical / Shift
            WHEN "0010011" =>
                CASE Instruction(14 DOWNTO 12) IS
                        -- Regular I-Type: 12-bit Sign Extension
                    WHEN "000" | "010" | "011" | "100" | "110" | "111" =>
                        Immediate <= ImmediateRegular;

                        -- Shift Immediate: 6-bit Zero Extension
                    WHEN "001" | "101" =>
                        Immediate <= ImmediateShift;

                    WHEN OTHERS =>
                        NULL;
                END CASE;

                -- I-Type Word Instructions
            WHEN "0011011" =>
                CASE Instruction(14 DOWNTO 12) IS
                        -- ADDIW
                    WHEN "000" =>
                        Immediate <= ImmediateRegular;

                        -- SLLIW, SRLIW, SRAIW
                    WHEN "001" | "101" =>
                        Immediate <= ImmediateShiftW;

                    WHEN OTHERS =>
                        NULL;
                END CASE;

                -- U-Type: LUI,  AUIPC
            WHEN "0110111" | "0010111" =>
                Immediate <= ImmediateUType;

                -- B-Type Branch Instructions
            WHEN "1100011" =>
                Immediate <= ImmediateBType;

                -- J-Type: JAL
            WHEN "1101111" =>
                Immediate <= ImmediateJAL;

                -- Custom I-Type Instructions
            WHEN "0101011" =>
                CASE Instruction(14 DOWNTO 12) IS
                        -- NANDI, NORI, XNORI, SLEI, SLEUI, ANDNI
                    WHEN "000" | "001" | "010" | "011" | "100" | "111" =>
                        Immediate <= ImmediateRegular;

                        -- ROLI, RORI: 6-bit Zero Extension
                    WHEN "101" | "110" =>
                        -- Immediate[11:6] must be zero
                        IF Instruction(31 DOWNTO 26) = "000000" THEN
                            Immediate <= ImmediateShift;
                        END IF;

                    WHEN OTHERS =>
                        NULL;
                END CASE;

                -- Instructions Without Immediate
            WHEN OTHERS =>
                NULL;

        END CASE;

    END PROCESS;

END Struct;