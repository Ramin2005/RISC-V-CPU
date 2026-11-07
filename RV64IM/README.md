# RV64IM Single-Cycle Processor (VHDL)

A 64-bit single-cycle RISC-V processor written in VHDL. It implements **RV64I**, the **M** extension, a 40-instruction **custom** extension (32 custom-0 R-type and 8 custom-1 I-type instructions) and a small set of **Zba / Zbb / Zbs** instructions.

> **Status.** The processor core is complete: control path (`Control`, `ALUControl`, `MainControl`), ALU, immediate generator, register file, PC logic (`PCControl`, `PCRegister`, adders), multiplexers and the top level `CPU.vhd`. The **instruction memory and the data memory are not part of the files**: `CPU` exposes them as ports (section 4.1). The data memory must also do the load size / sign extension (section 4.2). No test bench and no simulator run yet (sections 6 and 8).

Companion spreadsheet: `RV64IM_Implementable_Instructions.xlsx` (every instruction with its control signals, the ALU map, unsupported instructions and pseudo-instructions). It is not included in the current archive.

## 1. Files

| File | Role |
|---|---|
| `ALU/ALU.vhd` | 64-operation ALU (select S, outputs Result and Zero) |
| `Control/Control.vhd` | Opcode decoder: memory, register write, PC kind, ALU operand selects, ALUOpcode |
| `Control/ALUControl.vhd` | Decodes funct3 / funct7 and ALUOpcode into the 6-bit ALUSelect |
| `Control/MainControl.vhd` | Top of the control path: instantiates Control and ALUControl |
| `ImmGen/ImmGen.vhd` | Immediate generator (I, S, B, U, J formats and shift amounts) |
| `FileRegister/FileRegister32R64BWithClear.vhd` | 32 x 64-bit register file (2 read ports, 1 write port, synchronous clear, x0 hardwired to 0) |
| `Adder/UnsignedAdder64Bit.vhd` | 64-bit adder (PC + 4 and branch target) |
| `MUX/MUX64B2To1.vhdl` | 64-bit 2-to-1 multiplexer |
| `MUX/MUX64B4To1.vhd` | 64-bit 4-to-1 multiplexer |
| `PC Register/PCRegister.vhd` | Program counter register (synchronous clear) |
| `PC Control/PCControl.vhd` | Next-PC selection (PC + 4, branch target, JAL target, JALR target) |
| `CPU.vhd` | Top level: connects all blocks, exposes the instruction and data memory ports |
| *(external)* | Instruction memory and data memory (including load/store size and extension) |

### Entity ports

| Entity | Port | Dir | Type |
|---|---|---|---|
| ALU | A | IN | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| ALU | B | IN | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| ALU | S | IN | `STD_LOGIC_VECTOR(5 DOWNTO 0)` |
| ALU | Result | OUT | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| ALU | Zero | OUT | `STD_LOGIC` |
| Control | Opcode | IN | `STD_LOGIC_VECTOR(6 DOWNTO 0)` |
| Control | MemRead | OUT | `STD_LOGIC` |
| Control | MemWrite | OUT | `STD_LOGIC` |
| Control | RegWrite | OUT | `STD_LOGIC` |
| Control | RegSrc | OUT | `STD_LOGIC_VECTOR(1 DOWNTO 0)` |
| Control | PCSrc | OUT | `STD_LOGIC_VECTOR(1 DOWNTO 0)` |
| Control | ALUSrcA | OUT | `STD_LOGIC` |
| Control | ALUSrcB | OUT | `STD_LOGIC` |
| Control | ALUOpcode | OUT | `STD_LOGIC_VECTOR(2 DOWNTO 0)` |
| ALUControl | funct3 | IN | `STD_LOGIC_VECTOR(2 DOWNTO 0)` |
| ALUControl | funct7 | IN | `STD_LOGIC_VECTOR(6 DOWNTO 0)` |
| ALUControl | ALUOpcode | IN | `STD_LOGIC_VECTOR(2 DOWNTO 0)` |
| ALUControl | ALUSelect | OUT | `STD_LOGIC_VECTOR(5 DOWNTO 0)` |
| MainControl | Instruction | IN | `STD_LOGIC_VECTOR(31 DOWNTO 0)` |
| MainControl | MemRead | OUT | `STD_LOGIC` |
| MainControl | MemWrite | OUT | `STD_LOGIC` |
| MainControl | RegWrite | OUT | `STD_LOGIC` |
| MainControl | RegSrc | OUT | `STD_LOGIC_VECTOR(1 DOWNTO 0)` |
| MainControl | PCSrc | OUT | `STD_LOGIC_VECTOR(1 DOWNTO 0)` |
| MainControl | ALUSrcA | OUT | `STD_LOGIC` |
| MainControl | ALUSrcB | OUT | `STD_LOGIC` |
| MainControl | ALUSelect | OUT | `STD_LOGIC_VECTOR(5 DOWNTO 0)` |
| ImmGen | Instruction | IN | `STD_LOGIC_VECTOR(31 DOWNTO 0)` |
| ImmGen | Immediate | OUT | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| FileRegister32R64BWithClear | AddressA,AddressB,AddressW | IN | `STD_LOGIC_VECTOR(4 DOWNTO 0)` |
| FileRegister32R64BWithClear | WriteEnable | IN | `STD_LOGIC` |
| FileRegister32R64BWithClear | Clk | IN | `STD_LOGIC` |
| FileRegister32R64BWithClear | Clear | IN | `STD_LOGIC` |
| FileRegister32R64BWithClear | DataIn | IN | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| FileRegister32R64BWithClear | DataOutA,DataOutB | OUT | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| UnsignedAdder64Bit | A,B | IN | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| UnsignedAdder64Bit | Sum | OUT | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| MUX64B2To1 | A,B | IN | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| MUX64B2To1 | S | IN | `STD_LOGIC` |
| MUX64B2To1 | O | OUT | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| MUX64B4To1 | A,B,C,D | IN | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| MUX64B4To1 | S | IN | `STD_LOGIC_VECTOR(1 DOWNTO 0)` |
| MUX64B4To1 | O | OUT | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| PCRegister | Clk | IN | `STD_LOGIC` |
| PCRegister | Clear | IN | `STD_LOGIC` |
| PCRegister | DataIn | IN | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| PCRegister | Q | OUT | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| PCControl | PCSrc | IN | `STD_LOGIC_VECTOR(1 DOWNTO 0)` |
| PCControl | Branch | IN | `STD_LOGIC` |
| PCControl | PCPlus4 | IN | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| PCControl | BranchAdd | IN | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| PCControl | ALUResult | IN | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| PCControl | NextPC | OUT | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| CPU | Clk | IN | `STD_LOGIC` |
| CPU | Reset | IN | `STD_LOGIC` |
| CPU | MemoryAddress | OUT | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| CPU | MemoryMask | OUT | `STD_LOGIC_VECTOR(2 DOWNTO 0)` |
| CPU | MemoryWriteEnable | OUT | `STD_LOGIC` |
| CPU | MemoryWriteData | OUT | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| CPU | MemoryReadEnable | OUT | `STD_LOGIC` |
| CPU | MemoryReadData | IN | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| CPU | InstructionAddress | OUT | `STD_LOGIC_VECTOR(63 DOWNTO 0)` |
| CPU | InstructionIn | IN | `STD_LOGIC_VECTOR(31 DOWNTO 0)` |

## 2. Instruction set (114 instructions)

| Group | Count | Notes |
|---|---|---|
| RV64I | 52 | Includes loads, stores, branches, JAL, JALR, LUI, AUIPC, FENCE, ECALL, EBREAK |
| M | 13 | Multiply, divide, remainder (64-bit and word) |
| Custom-0 | 32 | R-type, opcode `0001011` |
| Custom-1 | 8 | I-type, opcode `0101011` |
| Added encodings | 9 | `ADD.UW`, `BSETI`, `BCLRI`, `BINVI`, `BEXTI`, `RORIW` (standard encodings) and `XORN`, `SH4ADD`, `SH8ADD` (custom-0, funct7 `0100010`) |

`funct7` shown as `xxxxxx (Inst[31:26])` means the decoder looks at instruction bits 31:26 only, because bit 25 belongs to the 6-bit shift amount.

### RV64I

| Instruction | Opcode | funct3 | funct7 | Imm | Requires |
|---|---|---|---|---|---|
| ADD | `0110011` | `000` | `0000000` | - | Core datapath only |
| ADDI | `0010011` | `000` | `-` | I | Core datapath only |
| ADDIW | `0011011` | `000` | `-` | I | Core datapath only |
| ADDW | `0111011` | `000` | `0000000` | - | Core datapath only |
| AND | `0110011` | `111` | `0000000` | - | Core datapath only |
| ANDI | `0010011` | `111` | `-` | I | Core datapath only |
| AUIPC | `0010111` | `-` | `-` | U | Core datapath only |
| BEQ | `1100011` | `000` | `-` | B | PC logic (`Branch`, `PCControl`) |
| BGE | `1100011` | `101` | `-` | B | PC logic (`Branch`, `PCControl`) |
| BGEU | `1100011` | `111` | `-` | B | PC logic (`Branch`, `PCControl`) |
| BLT | `1100011` | `100` | `-` | B | PC logic (`Branch`, `PCControl`) |
| BLTU | `1100011` | `110` | `-` | B | PC logic (`Branch`, `PCControl`) |
| BNE | `1100011` | `001` | `-` | B | PC logic (`Branch`, `PCControl`) |
| EBREAK | `1110011` | `000` | `-` | - | None (NOP) |
| ECALL | `1110011` | `000` | `-` | - | None (NOP) |
| FENCE | `0001111` | `000` | `-` | - | None (NOP) |
| JAL | `1101111` | `-` | `-` | J | PC logic (`Branch`, `PCControl`) |
| JALR | `1100111` | `000` | `-` | I | PC logic (`Branch`, `PCControl`) |
| LB | `0000011` | `000` | `-` | I | External data memory (size and extension by `MemoryMask`) |
| LBU | `0000011` | `100` | `-` | I | External data memory (size and extension by `MemoryMask`) |
| LD | `0000011` | `011` | `-` | I | External data memory (size and extension by `MemoryMask`) |
| LH | `0000011` | `001` | `-` | I | External data memory (size and extension by `MemoryMask`) |
| LHU | `0000011` | `101` | `-` | I | External data memory (size and extension by `MemoryMask`) |
| LUI | `0110111` | `-` | `-` | U | Core datapath only |
| LW | `0000011` | `010` | `-` | I | External data memory (size and extension by `MemoryMask`) |
| LWU | `0000011` | `110` | `-` | I | External data memory (size and extension by `MemoryMask`) |
| OR | `0110011` | `110` | `0000000` | - | Core datapath only |
| ORI | `0010011` | `110` | `-` | I | Core datapath only |
| SB | `0100011` | `000` | `-` | S | External data memory (size and extension by `MemoryMask`) |
| SD | `0100011` | `011` | `-` | S | External data memory (size and extension by `MemoryMask`) |
| SH | `0100011` | `001` | `-` | S | External data memory (size and extension by `MemoryMask`) |
| SLL | `0110011` | `001` | `0000000` | - | Core datapath only |
| SLLI | `0010011` | `001` | `000000 (Inst[31:26])` | I (shift 6-bit) | Core datapath only |
| SLLIW | `0011011` | `001` | `0000000` | I (shift 5-bit) | Core datapath only |
| SLLW | `0111011` | `001` | `0000000` | - | Core datapath only |
| SLT | `0110011` | `010` | `0000000` | - | Core datapath only |
| SLTI | `0010011` | `010` | `-` | I | Core datapath only |
| SLTIU | `0010011` | `011` | `-` | I | Core datapath only |
| SLTU | `0110011` | `011` | `0000000` | - | Core datapath only |
| SRA | `0110011` | `101` | `0100000` | - | Core datapath only |
| SRAI | `0010011` | `101` | `010000 (Inst[31:26])` | I (shift 6-bit) | Core datapath only |
| SRAIW | `0011011` | `101` | `0100000` | I (shift 5-bit) | Core datapath only |
| SRAW | `0111011` | `101` | `0100000` | - | Core datapath only |
| SRL | `0110011` | `101` | `0000000` | - | Core datapath only |
| SRLI | `0010011` | `101` | `000000 (Inst[31:26])` | I (shift 6-bit) | Core datapath only |
| SRLIW | `0011011` | `101` | `0000000` | I (shift 5-bit) | Core datapath only |
| SRLW | `0111011` | `101` | `0000000` | - | Core datapath only |
| SUB | `0110011` | `000` | `0100000` | - | Core datapath only |
| SUBW | `0111011` | `000` | `0100000` | - | Core datapath only |
| SW | `0100011` | `010` | `-` | S | External data memory (size and extension by `MemoryMask`) |
| XOR | `0110011` | `100` | `0000000` | - | Core datapath only |
| XORI | `0010011` | `100` | `-` | I | Core datapath only |

### M extension

| Instruction | Opcode | funct3 | funct7 | Imm | Requires |
|---|---|---|---|---|---|
| DIV | `0110011` | `100` | `0000001` | - | Core datapath only |
| DIVU | `0110011` | `101` | `0000001` | - | Core datapath only |
| DIVUW | `0111011` | `101` | `0000001` | - | Core datapath only |
| DIVW | `0111011` | `100` | `0000001` | - | Core datapath only |
| MUL | `0110011` | `000` | `0000001` | - | Core datapath only |
| MULH | `0110011` | `001` | `0000001` | - | Core datapath only |
| MULHSU | `0110011` | `010` | `0000001` | - | Core datapath only |
| MULHU | `0110011` | `011` | `0000001` | - | Core datapath only |
| MULW | `0111011` | `000` | `0000001` | - | Core datapath only |
| REM | `0110011` | `110` | `0000001` | - | Core datapath only |
| REMU | `0110011` | `111` | `0000001` | - | Core datapath only |
| REMUW | `0111011` | `111` | `0000001` | - | Core datapath only |
| REMW | `0111011` | `110` | `0000001` | - | Core datapath only |

### Custom-0 (R-type, opcode `0001011`)

| Instruction | Opcode | funct3 | funct7 | Imm | Requires |
|---|---|---|---|---|---|
| ABS | `0001011` | `010` | `0100000` | - | Core datapath only |
| ABSW | `0001011` | `011` | `0100000` | - | Core datapath only |
| ANDN | `0001011` | `011` | `0100001` | - | Core datapath only |
| BCLR | `0001011` | `101` | `0100000` | - | Core datapath only |
| BEXT | `0001011` | `111` | `0100000` | - | Core datapath only |
| BINV | `0001011` | `110` | `0100000` | - | Core datapath only |
| BSET | `0001011` | `100` | `0100000` | - | Core datapath only |
| CLZ | `0001011` | `000` | `0100001` | - | Core datapath only |
| CMPEQ | `0001011` | `000` | `0100000` | - | Core datapath only |
| CMPNE | `0001011` | `001` | `0100000` | - | Core datapath only |
| CPOP | `0001011` | `010` | `0100001` | - | Core datapath only |
| CTZ | `0001011` | `001` | `0100001` | - | Core datapath only |
| MAX | `0001011` | `100` | `0000001` | - | Core datapath only |
| MAXU | `0001011` | `101` | `0000001` | - | Core datapath only |
| MIN | `0001011` | `010` | `0000001` | - | Core datapath only |
| MINU | `0001011` | `011` | `0000001` | - | Core datapath only |
| NAND | `0001011` | `001` | `0000000` | - | Core datapath only |
| NOR | `0001011` | `010` | `0000000` | - | Core datapath only |
| NOT | `0001011` | `000` | `0000000` | - | Core datapath only |
| ORC.B | `0001011` | `111` | `0000001` | - | Core datapath only |
| ORN | `0001011` | `100` | `0100001` | - | Core datapath only |
| REV8 | `0001011` | `110` | `0000001` | - | Core datapath only |
| ROL | `0001011` | `110` | `0000000` | - | Core datapath only |
| ROLW | `0001011` | `000` | `0000001` | - | Core datapath only |
| ROR | `0001011` | `111` | `0000000` | - | Core datapath only |
| RORW | `0001011` | `001` | `0000001` | - | Core datapath only |
| SH1ADD | `0001011` | `101` | `0100001` | - | Core datapath only |
| SH2ADD | `0001011` | `110` | `0100001` | - | Core datapath only |
| SH3ADD | `0001011` | `111` | `0100001` | - | Core datapath only |
| SLE | `0001011` | `100` | `0000000` | - | Core datapath only |
| SLEU | `0001011` | `101` | `0000000` | - | Core datapath only |
| XNOR | `0001011` | `011` | `0000000` | - | Core datapath only |
| SH4ADD | `0001011` | `001` | `0100010` | - | Core datapath only |
| SH8ADD | `0001011` | `010` | `0100010` | - | Core datapath only |
| XORN | `0001011` | `000` | `0100010` | - | Core datapath only |

### Custom-1 (I-type, opcode `0101011`)

| Instruction | Opcode | funct3 | funct7 | Imm | Requires |
|---|---|---|---|---|---|
| ANDNI | `0101011` | `111` | `-` | I | Core datapath only |
| NANDI | `0101011` | `000` | `-` | I | Core datapath only |
| NORI | `0101011` | `001` | `-` | I | Core datapath only |
| ROLI | `0101011` | `101` | `-` | I (shift 6-bit) | Core datapath only |
| RORI | `0101011` | `110` | `-` | I (shift 6-bit) | Core datapath only |
| SLEI | `0101011` | `011` | `-` | I | Core datapath only |
| SLEUI | `0101011` | `100` | `-` | I | Core datapath only |
| XNORI | `0101011` | `010` | `-` | I | Core datapath only |

### Added standard encodings

| Instruction | Opcode | funct3 | funct7 | Imm | Requires |
|---|---|---|---|---|---|
| ADD.UW | `0111011` | `000` | `0000100` | - | Core datapath only |
| BCLRI | `0010011` | `001` | `010010 (Inst[31:26])` | I (shift 6-bit) | Core datapath only |
| BEXTI | `0010011` | `101` | `010010 (Inst[31:26])` | I (shift 6-bit) | Core datapath only |
| BINVI | `0010011` | `001` | `011010 (Inst[31:26])` | I (shift 6-bit) | Core datapath only |
| BSETI | `0010011` | `001` | `001010 (Inst[31:26])` | I (shift 6-bit) | Core datapath only |
| RORIW | `0011011` | `101` | `0110000` | I (shift 5-bit) | Core datapath only |

Full descriptions of every instruction are in the spreadsheet.

## 3. Control path

### 3.1 Signal encodings

| Signal | Value | Meaning |
|---|---|---|
| RegSrc | `00` | ALU result |
| RegSrc | `01` | Data memory |
| RegSrc | `10` | PC + 4 |
| RegSrc | `11` | Immediate (LUI) |
| ALUSrcA | `0` | rs1 |
| ALUSrcA | `1` | PC (AUIPC, JAL) |
| ALUSrcB | `0` | rs2 |
| ALUSrcB | `1` | Immediate |
| PCSrc | `00` | Sequential |
| PCSrc | `01` | Conditional branch |
| PCSrc | `10` | JAL (target = ALU result = `PC + imm`) |
| PCSrc | `11` | JALR (target = ALU result with bit 0 cleared) |
| ALUOpcode | `000` | Address add / default (ADD) |
| ALUOpcode | `001` | Branch compare |
| ALUOpcode | `010` | OP |
| ALUOpcode | `011` | OP-IMM |
| ALUOpcode | `100` | OP-32 |
| ALUOpcode | `101` | OP-IMM-32 |
| ALUOpcode | `110` | Custom-0 |
| ALUOpcode | `111` | Custom-1 |

### 3.2 Control: opcode to signals

| Opcode | Name | MemRead | MemWrite | RegWrite | RegSrc | PCSrc | ALUSrcA | ALUSrcB | ALUOpcode |
|---|---|---|---|---|---|---|---|---|---|
| `0110011` | -- OP | 0 | 0 | 1 | `00` | `00` | 0 | 0 | `010` |
| `0111011` | OP 32-Bit | 0 | 0 | 1 | `00` | `00` | 0 | 0 | `100` |
| `0010011` | -- OP IMM | 0 | 0 | 1 | `00` | `00` | 0 | 1 | `011` |
| `0011011` | OP IMM 32-Bit | 0 | 0 | 1 | `00` | `00` | 0 | 1 | `101` |
| `0010111` | -- AUIPC | 0 | 0 | 1 | `00` | `00` | 1 | 1 | `000` |
| `0110111` | LUI | 0 | 0 | 1 | `11` | `00` | 0 | 0 | `000` |
| `0000011` | -- Load | 1 | 0 | 1 | `01` | `00` | 0 | 1 | `000` |
| `0100011` | Store | 0 | 1 | 0 | `00` | `00` | 0 | 1 | `000` |
| `1100011` | -- BRANCH | 0 | 0 | 0 | `00` | `01` | 0 | 0 | `001` |
| `1100111` | JALR | 0 | 0 | 1 | `10` | `11` | 0 | 1 | `000` |
| `1101111` | JAL | 0 | 0 | 1 | `10` | `10` | 1 | 1 | `000` |
| `0001011` | -- Custom 0 (R-Type) | 0 | 0 | 1 | `00` | `00` | 0 | 0 | `110` |
| `0101011` | Custom 1 (I-Type) | 0 | 0 | 1 | `00` | `00` | 0 | 1 | `111` |
| other | NOP (FENCE, SYSTEM, ...) | 0 | 0 | 0 | `00` | `00` | 0 | 0 | `000` |

### 3.3 ALUControl decode rules

- `ALUOpcode = 000`: ADD (loads, stores, AUIPC, JALR, JAL).
- `001` (branch): by funct3. BEQ gives EQ, BNE gives NEQ, BLT and BGE give SLT, BLTU and BGEU give SLTU.
- `010` (OP), `100` (OP-32), `110` (custom-0): by funct7 first, then funct3.
- `011` (OP-IMM): by funct3. For shifts (funct3 `001` and `101`) the decoder uses `Instruction[31:26]` (SLLI, SRLI, SRAI, BSETI, BCLRI, BINVI, BEXTI).
- `101` (OP-IMM-32): by funct3; shifts use funct7 (SRLIW `0000000`, SRAIW `0100000`, RORIW `0110000`).
- `111` (custom-1): by funct3 only.
- Any combination not listed gives `ALUSelect = 000000` (ADD).

### 3.4 ImmGen formats

| Format | Output (64 bits, always sign-extended from `inst[31]`) |
|---|---|
| I | `inst[31:20]` |
| S | `inst[31:25], inst[11:7]` |
| B | `inst[31], inst[7], inst[30:25], inst[11:8], 0` |
| U | `inst[31:12], 12'b0` |
| J | `inst[31], inst[19:12], inst[20], inst[30:21], 0` |
| Shift 6-bit | `inst[25:20]` zero-extended (OP-IMM funct3 `001`/`101`, custom-1 ROLI/RORI) |
| Shift 5-bit | `inst[24:20]` zero-extended (OP-IMM-32 funct3 `001`/`101`) |

### 3.5 ALU operation map (ALUSelect)

| S | Operation | S | Operation | S | Operation | S | Operation |
|---|---|---|---|---|---|---|---|
| 0 (`000000`) | ADD | 16 (`010000`) | REMU | 32 (`100000`) | SLTU | 48 (`110000`) | MAXU |
| 1 (`000001`) | SUB | 17 (`010001`) | REMW | 33 (`100001`) | SLE | 49 (`110001`) | CLZ |
| 2 (`000010`) | ADDW | 18 (`010010`) | REMUW | 34 (`100010`) | SLEU | 50 (`110010`) | CTZ |
| 3 (`000011`) | SUBW | 19 (`010011`) | NOT | 35 (`100011`) | SLL | 51 (`110011`) | CPOP |
| 4 (`000100`) | ABS | 20 (`010100`) | AND | 36 (`100100`) | SRL | 52 (`110100`) | SH1ADD |
| 5 (`000101`) | ABSW | 21 (`010101`) | OR | 37 (`100101`) | SRA | 53 (`110101`) | SH2ADD |
| 6 (`000110`) | MUL | 22 (`010110`) | XOR | 38 (`100110`) | ROL | 54 (`110110`) | SH3ADD |
| 7 (`000111`) | MULH | 23 (`010111`) | ANDN | 39 (`100111`) | ROR | 55 (`110111`) | SH4ADD |
| 8 (`001000`) | MULHSU | 24 (`011000`) | ORN | 40 (`101000`) | SLLW | 56 (`111000`) | SH8ADD |
| 9 (`001001`) | MULHU | 25 (`011001`) | XORN | 41 (`101001`) | SRLW | 57 (`111001`) | ADDUW |
| 10 (`001010`) | MULW | 26 (`011010`) | NAND | 42 (`101010`) | SRAW | 58 (`111010`) | BSET |
| 11 (`001011`) | DIV | 27 (`011011`) | NOR | 43 (`101011`) | ROLW | 59 (`111011`) | BCLR |
| 12 (`001100`) | DIVU | 28 (`011100`) | XNOR | 44 (`101100`) | RORW | 60 (`111100`) | BINV |
| 13 (`001101`) | DIVW | 29 (`011101`) | EQ | 45 (`101101`) | MIN | 61 (`111101`) | BEXT |
| 14 (`001110`) | DIVUW | 30 (`011110`) | NEQ | 46 (`101110`) | MINU | 62 (`111110`) | REV8 |
| 15 (`001111`) | REM | 31 (`011111`) | SLT | 47 (`101111`) | MAX | 63 (`111111`) | ORC.B |

The ALU outputs `Zero = 1` when the result is 0. Comparison operations (EQ, NEQ, SLT, SLTU, SLE, SLEU) return 1 or 0 in bit 0.

## 4. Execution rules (as implemented in `CPU.vhd`)

### 4.1 CPU ports and datapath

- **Instruction memory** (external): `InstructionAddress` = PC, `InstructionIn` = the 32-bit instruction at that address (combinational read, single cycle).
- **Data memory** (external): `MemoryAddress` = ALU result, `MemoryWriteData` = `rs2`, `MemoryMask` = `Instruction[14:12]` (funct3), `MemoryWriteEnable` = MemWrite, `MemoryReadEnable` = MemRead, `MemoryReadData` = 64-bit read data.
- **Reset**: `Reset` drives `Clear` of the register file and of the PC register. Both clears are **synchronous**, so `Reset` must be held high for at least one rising edge of `Clk`; the PC is 0 after that edge. x0 always reads 0 (the register file returns 0 for address 0 and never writes it).
- **ALU operands**: A = `ALUSrcA` ? PC : `rs1`; B = `ALUSrcB` ? Immediate : `rs2`.
- **Write-back** (`MUX64B4To1`, select `RegSrc`): `00` ALU result, `01` `MemoryReadData`, `10` PC + 4, `11` Immediate.
- **Adders**: `PC + 4` and `PC + Immediate` (`BranchAdd`, used only by conditional branches).

### 4.2 Instruction behaviour

- **Register and immediate instructions** (RV64I ALU, M, custom, Zb*): `ALUSrcA = rs1`, `ALUSrcB` = `rs2` or immediate, `RegSrc = 00`, write `rd`.
- **LUI**: `RegSrc = 11`, the immediate goes directly to `rd` (the ALU result is not used). **AUIPC**: ALU computes `PC + imm` (`ALUSrcA = 1`).
- **Loads**: address = `rs1 + imm`, `MemRead = 1`, `RegSrc = 01`. `CPU` writes `MemoryReadData` to `rd` **unchanged**, so the external data memory must select the bytes and do the sign or zero extension according to `MemoryMask` (funct3): `000` LB, `001` LH, `010` LW, `011` LD, `100` LBU, `101` LHU, `110` LWU.
- **Stores**: address = `rs1 + imm`, write data = `rs2` (full 64 bits), `MemWrite = 1`. The data memory must use only the low bytes selected by `MemoryMask`: `000` SB, `001` SH, `010` SW, `011` SD.
- **Branches**: the ALU compares `rs1` and `rs2` (`ALUOpcode = 001`). `Branch = (NOT Zero) XOR (Instruction(14) AND Instruction(12))`. Comparison results are 0 or 1, so `Zero = 1` means the comparison is false. BEQ uses EQ, BNE uses NEQ, BLT and BGE use SLT, BLTU and BGEU use SLTU; BGE (`101`) and BGEU (`111`) invert the result through the XOR term. Target = `PC + imm` (`BranchAdd`).
- **JAL**: `rd = PC + 4`; the ALU computes `PC + imm` (`ALUSrcA = 1`, `ALUSrcB = 1`) and that result is the next PC. **JALR**: `rd = PC + 4`; the ALU computes `rs1 + imm` and the next PC is that result with bit 0 cleared.
- **PCControl priority**: `PCSrc = 11` gives `ALUResult(63 DOWNTO 1) & '0'` (JALR); `PCSrc = 10` gives `ALUResult` (JAL); `PCSrc = 01` and `Branch = 1` gives `BranchAdd`; everything else gives `PC + 4`. The `Branch` input is ignored unless `PCSrc = 01`.
- **FENCE, ECALL, EBREAK**: all control signals are 0 (NOP). There are no traps and no CSRs.

## 5. Not implementable instructions

All 64 ALUSelect codes are used, so the following have no ALU operation. Most can be replaced by a short sequence of implemented instructions.

| Instruction | Extension | Workaround |
|---|---|---|
| CLMUL | Zbc | None short |
| CLMULH | Zbc | None short |
| CLMULR | Zbc | None short |
| CLZW | Zbb | SLLI t,rs,32 ; BSETI t,t,31 ; CLZ rd,t |
| CTZW | Zbb | BSETI t,rs,32 ; CTZ rd,t |
| CPOPW | Zbb | ADD.UW t,rs,x0 ; CPOP rd,t |
| SEXT.B | Zbb | SLLI rd,rs,56 ; SRAI rd,rd,56 |
| SEXT.H | Zbb | SLLI rd,rs,48 ; SRAI rd,rd,48 |
| ZEXT.H | Zbb | SLLI rd,rs,48 ; SRLI rd,rd,48 |
| SH1ADD.UW | Zba | ADD.UW t,rs1,x0 ; SH1ADD rd,t,rs2 |
| SH2ADD.UW | Zba | ADD.UW t,rs1,x0 ; SH2ADD rd,t,rs2 |
| SH3ADD.UW | Zba | ADD.UW t,rs1,x0 ; SH3ADD rd,t,rs2 |
| SLLI.UW | Zba | ADD.UW t,rs,x0 ; SLLI rd,t,shamt |

Implementing them in hardware needs a wider ALUSelect (7 bits) or giving up `XORN`, `SH4ADD`, `SH8ADD`.

## 6. What is still needed

The core is complete. Remaining work:

- [ ] Instruction memory and data memory models (or wrappers for the target board). The data memory must implement the byte / halfword / word / doubleword access and the sign or zero extension described in section 4.2.
- [ ] Test bench with at least one test per instruction group (ALU operations, loads and stores of every size, every branch in taken and not-taken form, JAL, JALR, LUI, AUIPC, reset behaviour).
- [ ] First simulation and synthesis run (see section 8).

## 7. Pseudo-instructions

These need no hardware: `NOP`, `MV`, `NOT`, `NEG`, `NEGW`, `SEXT.W`, `ZEXT.W` (`ADD.UW rd,rs,x0`), `SEQZ`, `SNEZ`, `SLTZ`, `SGTZ`, `SGT`, `SGTU`, `LI`, `J`, `JR`, `RET`, `CALL`, `BEQZ`, `BNEZ`, `BLEZ`, `BGEZ`, `BLTZ`, `BGTZ`, `BGT`, `BLE`, `BGTU`, `BLEU`. Expansions are in the spreadsheet (sheet *Pseudo-instructions*).

## 8. Verification status

- **Control path**: `Control` and `ALUControl` were checked with a script that translates the VHDL decode logic (CASE / IF) and runs it for every instruction in section 2 (don't-care fields tried with several values). All 114 instructions (and the ALU alias `ADDUW`) give the expected ALUSelect, and every opcode gives the signals of section 3.2. This README and `Supported Instructions.md` list the same 114 instructions with the same opcode and funct3.
- **Branch logic in `CPU.vhd`**: `Branch = (NOT Zero) XOR (Instruction(14) AND Instruction(12))` was checked for BEQ, BNE, BLT, BGE, BLTU and BGEU with edge operands (0, 1, -1, most negative, most positive); all give the correct taken / not-taken result.
- **ALU**: every select code `0..63` chooses the result signal of the same name. All operation definitions were reviewed by reading; no functional error was found.
- **Not done**: no HDL simulator or synthesis run yet, and the top level `CPU.vhd` was reviewed by reading only. Test in simulation: DIV and DIVW for most-negative / -1 (must return the dividend, REM must return 0), all shift and rotate edge amounts, and the reset sequence (the PC register and the register file are cleared only on a rising clock edge with `Reset = 1`, so their contents are undefined before the first clear).

## 9. Known limitations

- `ALUSrcB` is 1 bit: operand B cannot be forced to 0 or -1 (no `BUFFER`, `NEG` by multiply, `INC`, `DEC` as single instructions). `MUX64B4To1` can support a 2-bit version later.
- Undefined funct combinations execute as ADD and still write `rd` (no illegal-instruction trap).
- Load size and extension is not done inside the CPU: `MemoryReadData` goes straight to the write-back multiplexer, so a plain 64-bit memory gives wrong results for LB, LH, LW, LBU, LHU and LWU.
- Reset is synchronous (needs a clock edge with `Reset = 1`). There is no misaligned-address check for fetch, load or store.
- Single cycle with combinational multiply, divide and remainder: the critical path is long.
- No CSRs, traps, interrupts, privilege levels or atomic and floating-point extensions.
- Some comments in `ALU.vhd` and `ALUControl.vhd` use instruction names for ALU operations (for example BEQ for EQ); the codes are correct.

## 10. Adding an instruction

1. Choose a free (opcode, funct3, funct7) slot. Custom-0 funct7 `0100010` has free funct3 values `011` to `111`; custom-1 has none left.
2. Add a decode row in `ALUControl.vhd` using an existing ALU code (or add the operation to `ALU.vhd`).
3. If the instruction needs a new immediate format, extend `ImmGen.vhd`; if it uses a new opcode, add it to `Control.vhd`.
4. Update the spreadsheet and re-run the checks.
