# RV64IM CPU: Supported Instructions

Single-cycle 64-bit RISC-V CPU (VHDL). All instructions are 32 bits wide. This file lists only the instructions the current files can decode and execute, with their `opcode` and function fields.

Instruction fields: `opcode` = `[6:0]`, `funct3` = `[14:12]`, `funct7` = `[31:25]`. For immediate shifts `[31:26]` (funct6) is used, because bit 25 belongs to the 6-bit shift amount.

Supported: 52 RV64I, 13 M, 4 Zba, 18 Zbb, 8 Zbs, 19 custom, total 114 instructions.

## RV64I (52)

| Instruction | opcode | funct3 | funct7 / upper bits |
|---|---|---|---|
| LB | `0000011` | `000` | - |
| LH | `0000011` | `001` | - |
| LW | `0000011` | `010` | - |
| LD | `0000011` | `011` | - |
| LBU | `0000011` | `100` | - |
| LHU | `0000011` | `101` | - |
| LWU | `0000011` | `110` | - |
| FENCE | `0001111` | `000` | - |
| ADDI | `0010011` | `000` | - |
| SLTI | `0010011` | `010` | - |
| SLTIU | `0010011` | `011` | - |
| XORI | `0010011` | `100` | - |
| ORI | `0010011` | `110` | - |
| ANDI | `0010011` | `111` | - |
| SLLI | `0010011` | `001` | `[31:26] = 000000` |
| SRLI | `0010011` | `101` | `[31:26] = 000000` |
| SRAI | `0010011` | `101` | `[31:26] = 010000` |
| AUIPC | `0010111` | `-` | - |
| ADDIW | `0011011` | `000` | - |
| SLLIW | `0011011` | `001` | `[31:25] = 0000000` |
| SRLIW | `0011011` | `101` | `[31:25] = 0000000` |
| SRAIW | `0011011` | `101` | `[31:25] = 0100000` |
| SB | `0100011` | `000` | - |
| SH | `0100011` | `001` | - |
| SW | `0100011` | `010` | - |
| SD | `0100011` | `011` | - |
| ADD | `0110011` | `000` | `[31:25] = 0000000` |
| SLL | `0110011` | `001` | `[31:25] = 0000000` |
| SLT | `0110011` | `010` | `[31:25] = 0000000` |
| SLTU | `0110011` | `011` | `[31:25] = 0000000` |
| XOR | `0110011` | `100` | `[31:25] = 0000000` |
| SRL | `0110011` | `101` | `[31:25] = 0000000` |
| OR | `0110011` | `110` | `[31:25] = 0000000` |
| AND | `0110011` | `111` | `[31:25] = 0000000` |
| SUB | `0110011` | `000` | `[31:25] = 0100000` |
| SRA | `0110011` | `101` | `[31:25] = 0100000` |
| LUI | `0110111` | `-` | - |
| ADDW | `0111011` | `000` | `[31:25] = 0000000` |
| SLLW | `0111011` | `001` | `[31:25] = 0000000` |
| SRLW | `0111011` | `101` | `[31:25] = 0000000` |
| SUBW | `0111011` | `000` | `[31:25] = 0100000` |
| SRAW | `0111011` | `101` | `[31:25] = 0100000` |
| BEQ | `1100011` | `000` | - |
| BNE | `1100011` | `001` | - |
| BLT | `1100011` | `100` | - |
| BGE | `1100011` | `101` | - |
| BLTU | `1100011` | `110` | - |
| BGEU | `1100011` | `111` | - |
| JALR | `1100111` | `000` | - |
| JAL | `1101111` | `-` | - |
| EBREAK | `1110011` | `000` | `[31:20] = 000000000001` |
| ECALL | `1110011` | `000` | `[31:20] = 000000000000` |

ECALL and EBREAK differ only in `[31:20]`. FENCE, ECALL and EBREAK are decoded but have no effect (no traps, no CSRs).

## M (13)

| Instruction | opcode | funct3 | funct7 / upper bits |
|---|---|---|---|
| MUL | `0110011` | `000` | `[31:25] = 0000001` |
| MULH | `0110011` | `001` | `[31:25] = 0000001` |
| MULHSU | `0110011` | `010` | `[31:25] = 0000001` |
| MULHU | `0110011` | `011` | `[31:25] = 0000001` |
| DIV | `0110011` | `100` | `[31:25] = 0000001` |
| DIVU | `0110011` | `101` | `[31:25] = 0000001` |
| REM | `0110011` | `110` | `[31:25] = 0000001` |
| REMU | `0110011` | `111` | `[31:25] = 0000001` |
| MULW | `0111011` | `000` | `[31:25] = 0000001` |
| DIVW | `0111011` | `100` | `[31:25] = 0000001` |
| DIVUW | `0111011` | `101` | `[31:25] = 0000001` |
| REMW | `0111011` | `110` | `[31:25] = 0000001` |
| REMUW | `0111011` | `111` | `[31:25] = 0000001` |

## Zba (4 of 8)

| Instruction | opcode | funct3 | funct7 / upper bits |
|---|---|---|---|
| SH1ADD | `0001011` | `101` | `[31:25] = 0100001` |
| SH2ADD | `0001011` | `110` | `[31:25] = 0100001` |
| SH3ADD | `0001011` | `111` | `[31:25] = 0100001` |
| ADD.UW | `0111011` | `000` | `[31:25] = 0000100` |

ADD.UW is the same instruction as ADDUW. ADD.UW uses the official encoding. SH1ADD, SH2ADD and SH3ADD use the custom-0 slot (not the official encoding).

## Zbb (18 of 24)

| Instruction | opcode | funct3 | funct7 / upper bits |
|---|---|---|---|
| XNOR | `0001011` | `011` | `[31:25] = 0000000` |
| ROL | `0001011` | `110` | `[31:25] = 0000000` |
| ROR | `0001011` | `111` | `[31:25] = 0000000` |
| ROLW | `0001011` | `000` | `[31:25] = 0000001` |
| RORW | `0001011` | `001` | `[31:25] = 0000001` |
| MIN | `0001011` | `010` | `[31:25] = 0000001` |
| MINU | `0001011` | `011` | `[31:25] = 0000001` |
| MAX | `0001011` | `100` | `[31:25] = 0000001` |
| MAXU | `0001011` | `101` | `[31:25] = 0000001` |
| REV8 | `0001011` | `110` | `[31:25] = 0000001` |
| ORC.B | `0001011` | `111` | `[31:25] = 0000001` |
| CLZ | `0001011` | `000` | `[31:25] = 0100001` |
| CTZ | `0001011` | `001` | `[31:25] = 0100001` |
| CPOP | `0001011` | `010` | `[31:25] = 0100001` |
| ANDN | `0001011` | `011` | `[31:25] = 0100001` |
| ORN | `0001011` | `100` | `[31:25] = 0100001` |
| RORIW | `0011011` | `101` | `[31:25] = 0110000` |
| RORI | `0101011` | `110` | - |

RORIW uses the official encoding. All other Zbb instructions here use the custom-0 slot (opcode `0001011`), except RORI, which uses the custom-1 slot (opcode `0101011`).

## Zbs (8)

| Instruction | opcode | funct3 | funct7 / upper bits |
|---|---|---|---|
| BSET | `0001011` | `100` | `[31:25] = 0100000` |
| BCLR | `0001011` | `101` | `[31:25] = 0100000` |
| BINV | `0001011` | `110` | `[31:25] = 0100000` |
| BEXT | `0001011` | `111` | `[31:25] = 0100000` |
| BSETI | `0010011` | `001` | `[31:26] = 001010` |
| BCLRI | `0010011` | `001` | `[31:26] = 010010` |
| BEXTI | `0010011` | `101` | `[31:26] = 010010` |
| BINVI | `0010011` | `001` | `[31:26] = 011010` |

BSETI, BCLRI, BINVI and BEXTI use the official encoding. BSET, BCLR, BINV and BEXT use the custom-0 slot.

## Custom instructions (19)

Not part of any RISC-V extension. Opcode `0001011` (custom-0) is R-type, opcode `0101011` (custom-1) is I-type.

| Instruction | opcode | funct3 | funct7 / upper bits |
|---|---|---|---|
| NOT | `0001011` | `000` | `[31:25] = 0000000` |
| NAND | `0001011` | `001` | `[31:25] = 0000000` |
| NOR | `0001011` | `010` | `[31:25] = 0000000` |
| SLE | `0001011` | `100` | `[31:25] = 0000000` |
| SLEU | `0001011` | `101` | `[31:25] = 0000000` |
| CMPEQ | `0001011` | `000` | `[31:25] = 0100000` |
| CMPNE | `0001011` | `001` | `[31:25] = 0100000` |
| ABS | `0001011` | `010` | `[31:25] = 0100000` |
| ABSW | `0001011` | `011` | `[31:25] = 0100000` |
| XORN | `0001011` | `000` | `[31:25] = 0100010` |
| SH4ADD | `0001011` | `001` | `[31:25] = 0100010` |
| SH8ADD | `0001011` | `010` | `[31:25] = 0100010` |
| NANDI | `0101011` | `000` | - |
| NORI | `0101011` | `001` | - |
| XNORI | `0101011` | `010` | - |
| SLEI | `0101011` | `011` | - |
| SLEUI | `0101011` | `100` | - |
| ROLI | `0101011` | `101` | - |
| ANDNI | `0101011` | `111` | - |

| Instruction | Operation |
|---|---|
| NOT | rd = ~rs1 |
| ABS | rd = absolute value of rs1 (64-bit, signed) |
| ABSW | rd = sign-extended absolute value of rs1[31:0] |
| NAND, NOR | rd = ~(rs1 & rs2), rd = ~(rs1 \| rs2) |
| XORN | rd = rs1 ^ ~rs2 |
| SLE, SLEU | rd = 1 if rs1 <= rs2 (signed, unsigned), else 0 |
| CMPEQ, CMPNE | rd = 1 if rs1 == rs2 (rs1 != rs2), else 0 |
| SH4ADD, SH8ADD | rd = (rs1 << 4) + rs2, rd = (rs1 << 8) + rs2 |
| NANDI, NORI, XNORI | rd = ~(rs1 & imm), ~(rs1 \| imm), ~(rs1 ^ imm) |
| ANDNI | rd = rs1 & ~imm |
| SLEI, SLEUI | rd = 1 if rs1 <= imm (signed, unsigned), else 0 |
| ROLI | rd = rs1 rotated left by a 6-bit shift amount |

`imm` is the 12-bit sign-extended immediate. For ROLI and RORI, bits `[31:26]` must be `000000`.

## Notes

- Standard toolchains do not know the custom-0 and custom-1 encodings. Instructions placed in those slots need your own assembler.
- Branches, jumps and byte, halfword and word loads/stores depend on the wiring in the CPU top level.
- There is no illegal-instruction trap. Encodings not listed here are not supported and must not be executed.
