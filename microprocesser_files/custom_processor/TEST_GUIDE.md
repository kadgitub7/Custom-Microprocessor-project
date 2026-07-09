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

This writes `program.mem` with a simple test program:
- Load 5 into `$v0` (register 2)
- Load 6 into `$v1` (register 3)
- Add them: `$a0 = $v0 + $v1` (result = 11 in register 4)

### Step 2: Run Processor Simulation

Use your Verilog simulator (Icarus, Vivado, etc.):
```bash
iverilog -o processor processor_top_tb.v processor_top.v [all design files...]
vvp processor
```

### Step 3: Observe Results

The testbench prints final register states:
```
===== SIMULATION COMPLETE =====
Final register state:
R0 (zero) = 0
R2 (v0)   = 5
R3 (v1)   = 6
R4 (a0)   = 11
...
```

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

To test all processor paths:

1. **ALU path**: Use arithmetic operations (add, sub, and, or)
2. **Memory path**: Use lw/sw instructions
3. **Posit path**: Use custom opcodes 101100 (posit add) or 101101 (posit mul)
4. **BNN path**: Use opcodes 111100 (xnor), 111101 (accum), 111110 (activate)
5. **Integrity checker**: Compare posit and ALU outputs

Example program to test multiple paths:
```assembly
addi $v0, $zero, 5      # ALU: load immediate
addi $v1, $zero, 3      # ALU: load immediate
add $a0, $v0, $v1       # ALU: arithmetic
sw $a0, 0($zero)        # Memory: store
lw $a1, 0($zero)        # Memory: load
# Custom instructions would go here for posit/BNN
```

## File Organization

```
custom_processor/
  design_files/
    processor_top.v         # Main processor + all stages
    alu.v                   # ALU
    alu_integrity_checker.v # Checker module
    posit/                  # Posit arithmetic
    bnn_coprocessor.v       # BNN co-processor
  rom_files/
    program.mem             # Machine code
    mips_gen.cpp            # C++ instruction generator
  simulation_files/
    processor_top_tb.v      # Top-level testbench
    *.v                     # Unit testbenches
```
