LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Control IS
    PORT (
        Opcode : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        Branch : OUT STD_LOGIC;
        MemRead : OUT STD_LOGIC;
        MemWrite : OUT STD_LOGIC;
        RegSrc : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        RegWrite : OUT STD_LOGIC;
        ALUSrcA : OUT STD_LOGIC;
        ALUSrcB : OUT STD_LOGIC;
        ALUOp : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY Control;

ARCHITECTURE Struct OF Control IS
BEGIN

    PROCESS (Opcode)
    BEGIN

        CASE Opcode IS
                ---------- ALU Register ----------
                -- OP
            WHEN "0110011" =>
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '0';
                RegSrc <= "00";
                RegWrite <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= '0';
                ALUOp <= "010";

                -- OP 32-Bit
            WHEN "0111011" =>
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '0';
                RegSrc <= "00";
                RegWrite <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= '0';
                ALUOp <= "100";
                
                ---------- ALU Immediate ----------
                -- OP IMM
            WHEN "0010011" =>
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '0';
                RegSrc <= "00";
                RegWrite <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= '1';
                ALUOp <= "011";

                -- OP IMM 32-Bit
            WHEN "0011011" =>
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '0';
                RegSrc <= "00";
                RegWrite <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= '1';
                ALUOp <= "101";

                ---------- Upper Immediate ----------
                -- AUIPC
            WHEN "0010111" =>
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '0';
                RegSrc <= "00";
                RegWrite <= '1';
                ALUSrcA <= '1';
                ALUSrcB <= '1';
                ALUOp <= "000";

                -- LUI
            WHEN "0110111" =>
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '0';
                RegSrc <= "11";
                RegWrite <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= '0';
                ALUOp <= "000";

                ---------- Memory ----------
                -- Load
            WHEN "0000011" =>
                Branch <= '0';
                MemRead <= '1';
                MemWrite <= '0';
                RegSrc <= "01";
                RegWrite <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= '1';
                ALUOp <= "000";

                -- Store
            WHEN "0100011" =>
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '1';
                RegSrc <= "00";
                RegWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= '1';
                ALUOp <= "000";

                ---------- Control Transfer ----------
                -- BRANCH
            WHEN "1100011" =>
                Branch <= '1';
                MemRead <= '0';
                MemWrite <= '0';
                RegSrc <= "00";
                RegWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= '0';
                ALUOp <= "001";

                -- JALR
            WHEN "1100111" =>
                Branch <= '1';
                MemRead <= '0';
                MemWrite <= '0';
                RegSrc <= "10";
                RegWrite <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= '1';
                ALUOp <= "000";

                -- JAL
            WHEN "1101111" =>
                Branch <= '1';
                MemRead <= '0';
                MemWrite <= '0';
                RegSrc <= "10";
                RegWrite <= '1';
                ALUSrcA <= '1';
                ALUSrcB <= '1';
                ALUOp <= "000";

                ---------- Fence / System ----------
                -- Misc Mem (FENCE)
            WHEN "0001111" =>
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '0';
                RegSrc <= "00";
                RegWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= '0';
                ALUOp <= "000";

                -- System (ECALL / EBREAK / CSR)
            WHEN "1110011" =>
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '0';
                RegSrc <= "00";
                RegWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= '0';
                ALUOp <= "000";

                ---------- Custom ----------
                -- Custom 0
            WHEN "0001011" =>
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '0';
                RegSrc <= "00";
                RegWrite <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= '0';
                ALUOp <= "110";

                -- Custom 1
            WHEN "0101011" =>
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '0';
                RegSrc <= "00";
                RegWrite <= '1';
                ALUSrcA <= '0';
                ALUSrcB <= '1';
                ALUOp <= "111";

                -- Custom 2
            WHEN "1011011" =>
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '0';
                RegSrc <= "00";
                RegWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= '0';
                ALUOp <= "000";

                -- Custom 3
            WHEN "1111011" =>
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '0';
                RegSrc <= "00";
                RegWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= '0';
                ALUOp <= "000";

                ---------- Reserved ----------
                -- Reserved
            WHEN "1101011" =>
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '0';
                RegSrc <= "00";
                RegWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= '0';
                ALUOp <= "000";

                -- Other (compressed / longer instructions)
            WHEN OTHERS =>
                Branch <= '0';
                MemRead <= '0';
                MemWrite <= '0';
                RegSrc <= "00";
                RegWrite <= '0';
                ALUSrcA <= '0';
                ALUSrcB <= '0';
                ALUOp <= "000";

        END CASE;

    END PROCESS;
    
END Struct;