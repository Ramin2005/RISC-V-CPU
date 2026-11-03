LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ALUControl IS
    PORT (
        funct3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        funct7 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        ALUOpcode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ALUSelect : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
    );
END ENTITY ALUControl;

ARCHITECTURE Struct OF ALUControl IS
    SIGNAL funct6 : STD_LOGIC_VECTOR(5 DOWNTO 0);
BEGIN
    funct6 <= funct7(6 DOWNTO 1);

    PROCESS (funct3, funct6, funct7, ALUOpcode)
    BEGIN

        ALUSelect <= "000000";

        CASE ALUOpcode IS
                --------------
                -- ALUOpcode "000"
            WHEN "000" =>
                -- ADD
                ALUSelect <= "000000";

                --------------
                -- ALUOpcode "001"
            WHEN "001" =>
                CASE funct3 IS
                    WHEN "000" =>
                        -- BEQ
                        ALUSelect <= "011101";

                    WHEN "001" =>
                        -- BNE
                        ALUSelect <= "011110";

                    WHEN "100" | "101" =>
                        -- SLT
                        ALUSelect <= "011111";

                    WHEN "110" | "111" =>
                        -- SLTU
                        ALUSelect <= "100000";

                    WHEN OTHERS =>
                        NULL;
                END CASE;

                --------------
                -- ALUOpcode "010"
            WHEN "010" =>
                CASE funct3 IS
                    WHEN "000" =>
                        IF funct7 = "0000000" THEN
                            -- ADD
                            ALUSelect <= "000000";

                        ELSIF funct7 = "0100000" THEN
                            -- SUB
                            ALUSelect <= "000001";

                        ELSIF funct7 = "0000001" THEN
                            -- MUL
                            ALUSelect <= "000110";
                        END IF;

                    WHEN "001" =>
                        IF funct7 = "0000000" THEN
                            -- SLL
                            ALUSelect <= "100011";

                        ELSIF funct7 = "0000001" THEN
                            -- MULH
                            ALUSelect <= "000111";
                        END IF;

                    WHEN "010" =>
                        IF funct7 = "0000000" THEN
                            -- SLT
                            ALUSelect <= "011111";

                        ELSIF funct7 = "0000001" THEN
                            -- MULHSU
                            ALUSelect <= "001000";
                        END IF;

                    WHEN "011" =>
                        IF funct7 = "0000000" THEN
                            -- SLTU
                            ALUSelect <= "100000";

                        ELSIF funct7 = "0000001" THEN
                            -- MULHU
                            ALUSelect <= "001001";
                        END IF;

                    WHEN "100" =>
                        IF funct7 = "0000000" THEN
                            -- XOR
                            ALUSelect <= "010110";

                        ELSIF funct7 = "0000001" THEN
                            -- DIV
                            ALUSelect <= "001011";
                        END IF;

                    WHEN "101" =>
                        IF funct7 = "0000000" THEN
                            -- SRL
                            ALUSelect <= "100100";

                        ELSIF funct7 = "0100000" THEN
                            -- SRA
                            ALUSelect <= "100101";

                        ELSIF funct7 = "0000001" THEN
                            -- DIVU
                            ALUSelect <= "001100";
                        END IF;

                    WHEN "110" =>
                        IF funct7 = "0000000" THEN
                            -- OR
                            ALUSelect <= "010101";

                        ELSIF funct7 = "0000001" THEN
                            -- REM
                            ALUSelect <= "001111";
                        END IF;

                    WHEN "111" =>
                        IF funct7 = "0000000" THEN
                            -- AND
                            ALUSelect <= "010100";

                        ELSIF funct7 = "0000001" THEN
                            -- REMU
                            ALUSelect <= "010000";
                        END IF;

                    WHEN OTHERS =>
                        NULL;
                END CASE;

                --------------
                -- ALUOpcode "011"
            WHEN "011" =>
                CASE funct3 IS
                    WHEN "000" =>
                        -- ADD
                        ALUSelect <= "000000";

                    WHEN "001" =>
                        CASE funct6 IS
                            WHEN "000000" =>
                                -- SLL
                                ALUSelect <= "100011";

                            WHEN "001010" =>
                                -- BSET
                                ALUSelect <= "111010";

                            WHEN "010010" =>
                                -- BCLR
                                ALUSelect <= "111011";

                            WHEN "011010" =>
                                -- BINV
                                ALUSelect <= "111100";

                            WHEN OTHERS =>
                                NULL;
                        END CASE;

                    WHEN "010" =>
                        -- SLT
                        ALUSelect <= "011111";

                    WHEN "011" =>
                        -- SLTU
                        ALUSelect <= "100000";

                    WHEN "100" =>
                        -- XOR
                        ALUSelect <= "010110";

                    WHEN "101" =>
                        CASE funct6 IS
                            WHEN "000000" =>
                                -- SRL
                                ALUSelect <= "100100";

                            WHEN "010000" =>
                                -- SRA
                                ALUSelect <= "100101";

                            WHEN "010010" =>
                                -- BEXT
                                ALUSelect <= "111101";

                            WHEN OTHERS =>
                                NULL;
                        END CASE;

                    WHEN "110" =>
                        -- OR
                        ALUSelect <= "010101";

                    WHEN "111" =>
                        -- AND
                        ALUSelect <= "010100";

                    WHEN OTHERS =>
                        NULL;
                END CASE;

                --------------
                -- ALUOpcode "100"
            WHEN "100" =>
                CASE funct3 IS
                    WHEN "000" =>
                        IF funct7 = "0000000" THEN
                            -- ADDW
                            ALUSelect <= "000010";

                        ELSIF funct7 = "0100000" THEN
                            -- SUBW
                            ALUSelect <= "000011";

                        ELSIF funct7 = "0000001" THEN
                            -- MULW
                            ALUSelect <= "001010";

                        ELSIF funct7 = "0000100" THEN
                            -- ADDUW
                            ALUSelect <= "111001";
                        END IF;

                    WHEN "001" =>
                        IF funct7 = "0000000" THEN
                            -- SLLW
                            ALUSelect <= "101000";
                        END IF;

                    WHEN "100" =>
                        IF funct7 = "0000001" THEN
                            -- DIVW
                            ALUSelect <= "001101";
                        END IF;

                    WHEN "101" =>
                        IF funct7 = "0000000" THEN
                            -- SRLW
                            ALUSelect <= "101001";

                        ELSIF funct7 = "0100000" THEN
                            -- SRAW
                            ALUSelect <= "101010";

                        ELSIF funct7 = "0000001" THEN
                            -- DIVUW
                            ALUSelect <= "001110";
                        END IF;

                    WHEN "110" =>
                        IF funct7 = "0000001" THEN
                            -- REMW
                            ALUSelect <= "010001";
                        END IF;

                    WHEN "111" =>
                        IF funct7 = "0000001" THEN
                            -- REMUW
                            ALUSelect <= "010010";
                        END IF;

                    WHEN OTHERS =>
                        NULL;
                END CASE;

                --------------
                -- ALUOpcode "101"
            WHEN "101" =>
                CASE funct3 IS
                    WHEN "000" =>
                        -- ADDW
                        ALUSelect <= "000010";

                    WHEN "001" =>
                        IF funct7 = "0000000" THEN
                            -- SLLW
                            ALUSelect <= "101000";
                        END IF;

                    WHEN "101" =>
                        IF funct7 = "0000000" THEN
                            -- SRLW
                            ALUSelect <= "101001";

                        ELSIF funct7 = "0100000" THEN
                            -- SRAW
                            ALUSelect <= "101010";

                        ELSIF funct7 = "0110000" THEN
                            -- RORW
                            ALUSelect <= "101100";
                        END IF;

                    WHEN OTHERS =>
                        NULL;
                END CASE;

                --------------
                -- ALUOpcode "110"
            WHEN "110" =>
                CASE funct3 IS
                    WHEN "000" =>
                        IF funct7 = "0000000" THEN
                            -- NOT
                            ALUSelect <= "010011";

                        ELSIF funct7 = "0000001" THEN
                            -- ROLW
                            ALUSelect <= "101011";

                        ELSIF funct7 = "0100000" THEN
                            -- BEQ
                            ALUSelect <= "011101";

                        ELSIF funct7 = "0100001" THEN
                            -- CLZ
                            ALUSelect <= "110001";

                        ELSIF funct7 = "0100010" THEN
                            -- XORN
                            ALUSelect <= "011001";
                        END IF;

                    WHEN "001" =>
                        IF funct7 = "0000000" THEN
                            -- NAND
                            ALUSelect <= "011010";

                        ELSIF funct7 = "0000001" THEN
                            -- RORW
                            ALUSelect <= "101100";

                        ELSIF funct7 = "0100000" THEN
                            -- BNE
                            ALUSelect <= "011110";

                        ELSIF funct7 = "0100001" THEN
                            -- CTZ
                            ALUSelect <= "110010";

                        ELSIF funct7 = "0100010" THEN
                            -- SH4ADD
                            ALUSelect <= "110111";
                        END IF;

                    WHEN "010" =>
                        IF funct7 = "0000000" THEN
                            -- NOR
                            ALUSelect <= "011011";

                        ELSIF funct7 = "0000001" THEN
                            -- MIN
                            ALUSelect <= "101101";

                        ELSIF funct7 = "0100000" THEN
                            -- ABS
                            ALUSelect <= "000100";

                        ELSIF funct7 = "0100001" THEN
                            -- CPOP
                            ALUSelect <= "110011";

                        ELSIF funct7 = "0100010" THEN
                            -- SH8ADD
                            ALUSelect <= "111000";
                        END IF;

                    WHEN "011" =>
                        IF funct7 = "0000000" THEN
                            -- XNOR
                            ALUSelect <= "011100";

                        ELSIF funct7 = "0000001" THEN
                            -- MINU
                            ALUSelect <= "101110";

                        ELSIF funct7 = "0100000" THEN
                            -- ABSW
                            ALUSelect <= "000101";

                        ELSIF funct7 = "0100001" THEN
                            -- ANDN
                            ALUSelect <= "010111";
                        END IF;

                    WHEN "100" =>
                        IF funct7 = "0000000" THEN
                            -- BGE
                            ALUSelect <= "100001";

                        ELSIF funct7 = "0000001" THEN
                            -- MAX
                            ALUSelect <= "101111";

                        ELSIF funct7 = "0100000" THEN
                            -- BSET
                            ALUSelect <= "111010";

                        ELSIF funct7 = "0100001" THEN
                            -- ORN
                            ALUSelect <= "011000";
                        END IF;

                    WHEN "101" =>
                        IF funct7 = "0000000" THEN
                            -- BGEU
                            ALUSelect <= "100010";

                        ELSIF funct7 = "0000001" THEN
                            -- MAXU
                            ALUSelect <= "110000";

                        ELSIF funct7 = "0100000" THEN
                            -- BCLR
                            ALUSelect <= "111011";

                        ELSIF funct7 = "0100001" THEN
                            -- SH1ADD
                            ALUSelect <= "110100";
                        END IF;

                    WHEN "110" =>
                        IF funct7 = "0000000" THEN
                            -- ROL
                            ALUSelect <= "100110";

                        ELSIF funct7 = "0000001" THEN
                            -- REV8
                            ALUSelect <= "111110";

                        ELSIF funct7 = "0100000" THEN
                            -- BINV
                            ALUSelect <= "111100";

                        ELSIF funct7 = "0100001" THEN
                            -- SH2ADD
                            ALUSelect <= "110101";
                        END IF;

                    WHEN "111" =>
                        IF funct7 = "0000000" THEN
                            -- ROR
                            ALUSelect <= "100111";

                        ELSIF funct7 = "0000001" THEN
                            -- ORC.B
                            ALUSelect <= "111111";

                        ELSIF funct7 = "0100000" THEN
                            -- BEXT
                            ALUSelect <= "111101";

                        ELSIF funct7 = "0100001" THEN
                            -- SH3ADD
                            ALUSelect <= "110110";
                        END IF;

                    WHEN OTHERS =>
                        NULL;
                END CASE;

                --------------
                -- ALUOpcode "111"
            WHEN "111" =>
                CASE funct3 IS
                    WHEN "000" =>
                        -- NAND
                        ALUSelect <= "011010";

                    WHEN "001" =>
                        -- NOR
                        ALUSelect <= "011011";

                    WHEN "010" =>
                        -- XNOR
                        ALUSelect <= "011100";

                    WHEN "011" =>
                        -- BGE
                        ALUSelect <= "100001";

                    WHEN "100" =>
                        -- BGEU
                        ALUSelect <= "100010";

                    WHEN "101" =>
                        -- ROL
                        ALUSelect <= "100110";

                    WHEN "110" =>
                        -- ROR
                        ALUSelect <= "100111";

                    WHEN "111" =>
                        -- ANDN
                        ALUSelect <= "010111";

                    WHEN OTHERS =>
                        NULL;
                END CASE;

            WHEN OTHERS =>
                NULL;
        END CASE;
    END PROCESS;

END Struct;