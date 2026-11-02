LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Control IS
    PORT (
        Opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        MemRead : OUT STD_LOGIC;
        MemWrite : OUT STD_LOGIC;
        RegWrite : OUT STD_LOGIC;
        RegSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        PCSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        ALUSrcA, ALUSrcB : OUT STD_LOGIC;
        ALUOpcode : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY Control;

ARCHITECTURE Struct OF Control IS
BEGIN

    PROCESS (Opcode)
    BEGIN

        MemRead <= '0';
        MemWrite <= '0';
        RegWrite <= '0';
        RegSrc <= "00";
        PCSrc <= "00";
        ALUSrcA <= '0';
        ALUSrcB <= '0';
        ALUOpcode <= "000";

        CASE Opcode IS
                ---------- ALU Register ----------
                -- OP
            WHEN "0110011" =>
                RegWrite <= '1';
                ALUOpcode <= "010";

                -- OP 32-Bit
            WHEN "0111011" =>
                RegWrite <= '1';
                ALUOpcode <= "100";

                ---------- ALU Immediate ----------
                -- OP IMM
            WHEN "0010011" =>
                RegWrite <= '1';
                ALUSrcB <= '1';
                ALUOpcode <= "011";

                -- OP IMM 32-Bit
            WHEN "0011011" =>
                RegWrite <= '1';
                ALUSrcB <= '1';
                ALUOpcode <= "101";

                ---------- Upper Immediate ----------
                -- AUIPC
            WHEN "0010111" =>
                RegWrite <= '1';
                ALUSrcA <= '1';
                ALUSrcB <= '1';

                -- LUI
            WHEN "0110111" =>
                RegWrite <= '1';
                RegSrc <= "11";

                ---------- Memory ----------
                -- Load
            WHEN "0000011" =>
                MemRead <= '1';
                RegWrite <= '1';
                RegSrc <= "01";
                ALUSrcB <= '1';

                -- Store
            WHEN "0100011" =>
                MemWrite <= '1';
                ALUSrcB <= '1';

                ---------- Control Transfer ----------
                -- BRANCH
            WHEN "1100011" =>
                PCSrc <= "01";
                ALUOpcode <= "001";

                -- JALR
            WHEN "1100111" =>
                RegWrite <= '1';
                RegSrc <= "10";
                PCSrc <= "11";
                ALUSrcB <= '1';

                -- JAL
            WHEN "1101111" =>
                RegWrite <= '1';
                RegSrc <= "10";
                PCSrc <= "10";
                ALUSrcA <= '1';
                ALUSrcB <= '1';

                ---------- Custom ----------
                -- Custom 0 (R-Type)
            WHEN "0001011" =>
                RegWrite <= '1';
                ALUOpcode <= "110";

                -- Custom 1 (I-Type)
            WHEN "0101011" =>
                RegWrite <= '1';
                ALUSrcB <= '1';
                ALUOpcode <= "111";

                -- Other (compressed / longer instructions)
            WHEN OTHERS =>
                NULL;

        END CASE;

    END PROCESS;

END Struct;