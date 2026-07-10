# Testing the Custom MIPS Processor

## Overview
The processor executes MIPS machine code loaded from `program.mem`. To test it with software:

1. **Write** MIPS assembly (manually or generate with C++)
2. **Encode** assembly to hexadecimal machine code
3. **Load** into `program.mem`
4. **Run** the processor testbench
5. **Analyze** register/memory state in simulation

## Workflow

### Step 1: Generate Instructions (C++ approach)

Compile and run `mips_gen.cpp`:
```bash
cd rom_files/
g++ -o mips_gen mips_gen.cpp
./mips_gen
```

This writes `program.mem` with a 14-instruction test program that exercises the ALU, memory, and pipeline hazard logic:

| # | Instruction | Effect |
|---|-------------|--------|
| 0 | `addi $v0, $zero, 5` | `$v0 = 5` |
| 1 | `addi $v1, $zero, 7` | `$v1 = 7` |
| 2 | `add $a0, $v0, $v1` | `$a0 = 12` |
| 3 | `sub $a1, $v1, $v0` | `$a1 = 2` |
| 4 | `addi $v0, $zero, 12` | `$v0 = 12` |
| 5 | `addi $v1, $zero, 10` | `$v1 = 10` |
| 6 | `and $a0, $v0, $v1` | `$a0 = 8` |
| 7 | `or $a1, $v0, $v1` | `$a1 = 14` |
| 8 | `addi $v0, $zero, 3` | `$v0 = 3` |
| 9 | `addi $v1, $zero, 5` | `$v1 = 5` |
| 10 | `slt $a0, $v0, $v1` | `$a0 = 1` |
| 11 | `addi $v0, $zero, 25` | `$v0 = 25` |
| 12 | `sw $v0, 0($zero)` | `mem[0] = 25` |
| 13 | `lw $v1, 0($zero)` | `$v1 = 25` |

Corresponding machine code in `program.mem`:
```
20020005    # addi $v0, $zero, 5
20030007    # addi $v1, $zero, 7
00432020    # add  $a0, $v0, $v1
00622822    # sub  $a1, $v1, $v0
2002000C    # addi $v0, $zero, 12
2003000A    # addi $v1, $zero, 10
00432024    # and  $a0, $v0, $v1
00432825    # or   $a1, $v0, $v1
20020003    # addi $v0, $zero, 3
20030005    # addi $v1, $zero, 5
0043202A    # slt  $a0, $v0, $v1
20020019    # addi $v0, $zero, 25
AC020000    # sw   $v0, 0($zero)
8C030000    # lw   $v1, 0($zero)
```

### Step 2: Run Processor Simulation

**Icarus Verilog** (run from `simulation_files/`, with `program.mem` in the same directory):
```bash
cd simulation_files/
cp ../rom_files/program.mem .

iverilog -g2012 -o processor.vvp ../simulation_files/processor_top_tb.v \
  ../design_files/processor_top.v \
  ../design_files/PC_reg.v \
  ../design_files/PC_incrementer.v \
  ../design_files/instruction_memory.v \
  ../design_files/if_id_reg.v \
  ../design_files/register_file.v \
  ../design_files/sign_extend.v \
  ../design_files/control_unit.v \
  ../design_files/id_ex_reg.v \
  ../design_files/mux_gen.v \
  ../design_files/alu.v \
  ../design_files/posit/posit_unit.v \
  ../design_files/posit/posit_addsub.v \
  ../design_files/posit/posit_mul.v \
  ../design_files/posit/posit_decoder.v \
  ../design_files/posit/posit_encoder.v \
  ../design_files/security_check/alu_integrity_checker.v \
  ../design_files/bnn/bnn_coprocessor.v \
  ../design_files/ex_mem_reg.v \
  ../design_files/data_memory.v \
  ../design_files/mem_wb_reg.v

vvp processor.vvp
```

**Vivado**
1. Add all files under `design_files/` (including `posit/`, `bnn/`, `security_check/`) and `simulation_files/processor_top_tb.v`.
2. Set `processor_top_tb` as the simulation top.
3. Copy `rom_files/program.mem` into the Vivado simulation working directory before each run, **or** override the memory file path:
   ```verilog
   instruction_memory #(.MEM_FILE("path/to/rom_files/program.mem")) IM(...);
   ```
4. Run behavioral simulation for at least 500 ns.

### Step 3: Observe Results

The testbench prints final register states. Expected output:
```
===== SIMULATION COMPLETE =====
Final register state:
R0 (zero) = 0
R2 (v0)   = 25
R3 (v1)   = 25
R4 (a0)   = 1
R5 (a1)   = 14
R6 (a2)   = 0
R7 (a3)   = 0
```

## Supported Instructions

| Type | Instruction | Opcode / Funct |
|------|-------------|----------------|
| I-type | `addi` | opcode `001000` (0x08) |
| I-type | `lw` | opcode `100011` (0x23) |
| I-type | `sw` | opcode `101011` (0x2B) |
| I-type | `beq` | opcode `000100` (0x04) |
| R-type | `add` | funct `100000` (0x20) |
| R-type | `sub` | funct `100010` (0x22) |
| R-type | `and` | funct `100100` (0x24) |
| R-type | `or` | funct `100101` (0x25) |
| R-type | `slt` | funct `101010` (0x2A) |
| R-type | posit add | funct `101100` |
| R-type | posit mul | funct `101101` |
| Custom | BNN xnor | opcode `111100` |
| Custom | BNN accum | opcode `111101` |
| Custom | BNN activate | opcode `111110` |

## MIPS Instruction Format

### R-type (Arithmetic)
```
[opcode(6)] [rs(5)] [rt(5)] [rd(5)] [shamt(5)] [funct(6)]
```
Example: `add $rd, $rs, $rt`

### I-type (Immediate)
```
[opcode(6)] [rs(5)] [rt(5)] [immediate(16)]
```
Example: `addi $rt, $rs, imm`

## Register Names
| Name | Alias | Number |
|------|-------|--------|
| `$zero` | `$0` | 0 |
| `$v0` | `$2` | 2 |
| `$v1` | `$3` | 3 |
| `$a0` | `$4` | 4 |
| `$a1` | `$5` | 5 |

## Testing Data Paths

The current `mips_gen` program tests:
1. **ALU path** — `addi`, `add`, `sub`, `and`, `or`, `slt`
2. **Memory path** — `sw`, `lw`
3. **Pipeline hazards** — forwarding, load-use stall, register bypass

To test additional paths, extend `mips_gen.cpp` with:

| Path | How to test |
|------|-------------|
| **Posit** | R-type with funct `101100` (add) or `101101` (mul) |
| **BNN** | Opcodes `111100` (xnor), `111101` (accum), `111110` (activate) |
| **Integrity checker** | Posit instructions (checker compares ALU vs posit output) |
| **Branch** | `beq` with opcode `000100` |

Example snippet for posit/BNN (add to `mips_gen.cpp`):
```assembly
# Posit add (custom R-type, funct=101100)
# BNN xnor  (custom opcode=111100)
# beq       (opcode=000100)
```

## File Organization

```
custom_processor/
  design_files/
    processor_top.v                    # 5-stage pipeline top
    control_unit.v                     # Instruction decode
    alu.v                              # ALU
    register_file.v                    # 32-register file with bypass
    instruction_memory.v               # Loads program.mem
    posit/                             # Posit arithmetic units
    security_check/
      alu_integrity_checker.v          # ALU/posit integrity checker
    bnn/
      bnn_coprocessor.v                # BNN co-processor
  rom_files/
    program.mem                        # Machine code (generated)
    mips_gen.cpp                       # C++ instruction generator
  simulation_files/
    processor_top_tb.v                 # Top-level testbench
    *.v                                # Unit testbenches
```

## Notes

- `$readmemh` may warn that `program.mem` has fewer than 64 words — this is harmless.
- The processor includes forwarding, load-use stalls, and register-file bypass to handle pipeline hazards correctly.
- Posit, BNN, and branch instructions are implemented but not covered by the default `mips_gen` test program.
