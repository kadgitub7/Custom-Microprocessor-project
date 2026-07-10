# Custom MIPS Microprocessor

A from-scratch MIPS microprocessor built in Verilog, developed incrementally from a single-cycle design through a multi-cycle architecture, then a pipelined implementation, and finally a custom processor with three original extensions: a posit arithmetic unit, a parity-based ALU integrity checker, and a binary neural network (BNN) coprocessor. The custom processor is designed with edge AI acceleration in mind, combining alternative number representations with lightweight neural network primitives on a classic MIPS pipeline.

All four processor variants are fully simulated and verified using Xilinx Vivado.

## Table of Contents

- [Project Overview](#project-overview)
- [Repository Structure](#repository-structure)
- [Single-Cycle Processor](#single-cycle-processor)
- [Multi-Cycle Processor](#multi-cycle-processor)
- [Pipelined Processor](#pipelined-processor)
- [Custom Processor](#custom-processor)
  - [Posit Arithmetic Unit](#posit-arithmetic-unit)
  - [ALU Integrity Checker](#alu-integrity-checker)
  - [BNN Coprocessor](#bnn-coprocessor)
- [Instruction Set](#instruction-set)
- [Simulation and Testing](#simulation-and-testing)
- [How to Run](#how-to-run)

## Project Overview

The goal of this project was to understand processor design from the ground up by building four progressively more complex MIPS processors. Each iteration addresses specific limitations of the previous one:

1. **Single-cycle** -- the baseline. Every instruction completes in one clock cycle. Simple to reason about, but wasteful because short instructions take as long as the longest one.
2. **Multi-cycle** -- breaks execution into multiple shorter cycles so that simple instructions finish sooner. Consolidates three adders into one shared ALU and unifies instruction and data memory into a single block.
3. **Pipelined** -- overlaps instruction execution across five stages (Fetch, Decode, Execute, Memory, Writeback) for higher throughput.
4. **Custom** -- extends the pipelined design with data forwarding, hazard detection, and three novel hardware modules aimed at AI workloads.

The custom processor is the main contribution. It takes the pipelined base and adds a posit number format ALU for higher-precision arithmetic, a safety checker that cross-validates ALU outputs using parity, and a BNN coprocessor for binary neural network inference at the edge.

## Repository Structure

```
Custom-Microprocessor-project/
  PROJECT-TIMELINE.md                        Development journal and design rationale
  README.md                                  This file
  microprocesser_files/
    Diagrams/                                Block diagrams (ALU, PC, register file, etc.)
    single_cycle_processor_files/
      design_files/                          12 Verilog modules
      rom_files/program.mem                  Test program (machine code)
      simulation_files/                      6 testbenches, output logs, waveform captures
    multi_cycle_processor_files/
      design_files/                          9 Verilog modules
      rom_files/program.mem
      simulation_files/                      3 testbenches, output logs, waveform captures
    pipelined_processor_files/
      design_files/                          16 Verilog modules
      rom_files/program.mem
      simulation_files/                      6 testbenches, output logs, waveform captures
    custom_processor/
      TEST_GUIDE.md                          Full testing and simulation guide
      design_files/                          16 core modules + 3 extension subdirectories
        posit/                               5 posit arithmetic modules
        security_check/                      ALU integrity checker module
        bnn/                                 BNN coprocessor module
      rom_files/
        program.mem                          14-instruction test program
        mips_gen.cpp                         C++ instruction encoder/generator
      simulation_files/                      10 testbenches, output logs, waveform captures
```

## Single-Cycle Processor

The single-cycle processor is the starting point. It implements a subset of the MIPS instruction set where every instruction -- whether a simple register add or a memory load -- completes in exactly one clock cycle.

The design consists of five main state elements wired together:

- **Program Counter (PC):** A 32-bit D flip-flop register with synchronous reset. On each rising clock edge it latches the next instruction address.
- **Instruction Memory:** A ROM that loads machine code from `program.mem` via `$readmemh`. The input address is shifted right by two to convert byte addresses to word indices, since each instruction is four bytes.
- **Register File:** A 32-entry, 32-bit register file with two read ports and one write port. Register 0 is hardwired to zero.
- **ALU:** Supports AND, OR, ADD, SUB, and SLT (set on less than). All operations compute in parallel, and a multiplexer selects the result based on the control signal.
- **Data Memory:** A 1024-word SRAM with synchronous writes and combinational reads.

A combinational control unit decodes the opcode and function fields to produce all the necessary control signals (RegDst, ALUSrc, MemtoReg, RegWrite, MemWrite, Branch, ALUControl).

The main drawback is efficiency: a fast instruction like `add` takes the same amount of time as a slow instruction like `lw`, because the clock period must accommodate the longest critical path.

## Multi-Cycle Processor

The multi-cycle design addresses three problems with the single-cycle approach:

1. **Wasted time on short instructions.** By breaking execution into discrete states, simple instructions can finish in fewer cycles than complex ones.
2. **Redundant adders.** The single-cycle design uses three separate adders (one in the ALU, two for PC arithmetic). The multi-cycle design shares a single ALU across all addition operations.
3. **Separate memories.** Instead of having distinct instruction and data memory blocks, the multi-cycle processor uses one unified memory.

The control unit is implemented as a finite state machine with eight states: FETCH, DECODE, MemoryAdr, MemRead, MemWrite_State, Mem_Write, EXECUTE, and ALUWriteBack. Intermediate values are latched in registers (A, B, AluOut, DataMemOut) between states so the ALU can be reused across different phases of execution.

A 4-input multiplexer selects the ALU's second operand from among four sources depending on the current state, enabling the same ALU to compute PC increments, branch targets, memory addresses, and arithmetic results.

## Pipelined Processor

The pipelined processor overlaps instruction execution across five stages using pipeline registers between each stage:

| Stage | Register | Description |
|-------|----------|-------------|
| Fetch | -- | Reads instruction from memory at the current PC |
| Decode | IF/ID | Reads register file, sign-extends immediate, decodes control signals |
| Execute | ID/EX | Performs ALU operation or address calculation |
| Memory | EX/MEM | Reads or writes data memory |
| Writeback | MEM/WB | Writes result back to the register file |

In the ideal case this gives a throughput of one instruction per cycle, since all five stages operate simultaneously on different instructions.

This intermediate version introduces the posit arithmetic unit in the execute stage but does not yet include forwarding or hazard detection, so it requires careful instruction scheduling to avoid data hazards. The custom processor builds directly on this design and resolves those limitations.

## Custom Processor

The custom processor is the final and most complete design. It takes the pipelined architecture and adds proper hazard handling along with three hardware extensions.

### Pipeline Hazard Handling

The processor handles three types of hazards:

**Data forwarding.** A forwarding unit detects read-after-write (RAW) dependencies from the EX/MEM and MEM/WB stages. When a result is produced but not yet written back, it is forwarded directly to the execute stage inputs. The forwarding logic checks source register addresses against destination registers in later pipeline stages and selects the most recent value.

**Load-use stalls.** When a `lw` instruction is in the execute stage and the immediately following instruction reads the loaded register, forwarding alone is not sufficient because the data is not yet available. In this case the pipeline stalls for one cycle: the PC and IF/ID register hold their values, and a bubble is inserted into the ID/EX register.

**Branch flushing.** When a branch is taken (determined in the execute stage by checking both the Branch control signal and the ALU zero flag), the IF/ID register is flushed to discard the incorrectly fetched instruction, and the PC is redirected to the branch target address.

**Register file bypass.** The register file itself implements a write-to-read bypass. If a write and a read target the same register on the same clock edge, the write data is forwarded combinationally to the read output, avoiding a one-cycle stale-read hazard.

### Posit Arithmetic Unit

The posit number format is an alternative to IEEE 754 floating point proposed by John Gustafson. Posits provide tapered precision -- they are most accurate near 1.0 and gracefully lose precision toward the extremes, which makes them well-suited for machine learning workloads where values tend to cluster around small magnitudes.

An 8-bit posit with ES=2 (two exponent bits) is structured as:

```
[sign(1)] [regime(variable)] [exponent(2)] [fraction(remaining)]
```

The regime is a run of identical bits terminated by the opposite bit. The length and direction of the run encode a scaling factor `k`, and the useed value (2^(2^ES) = 16 for ES=2) raised to the power `k` provides coarse magnitude scaling. The exponent and fraction fields refine the value from there.

The posit unit consists of five modules:

- **posit_decoder** -- Extracts the sign, regime, exponent, and fraction from an 8-bit posit and computes the equivalent signed 32-bit integer magnitude.
- **posit_encoder** -- Takes a signed 32-bit integer and encodes it back into an 8-bit posit representation.
- **posit_addsub** -- Performs posit addition or subtraction by decoding both operands to integers, performing the integer operation, and re-encoding the result.
- **posit_mul** -- Performs posit multiplication using the same decode-compute-encode strategy.
- **posit_unit** -- Top-level wrapper that selects between add/sub and multiply based on the operation code.

The posit unit operates on the lower 8 bits of the ALU source operands and produces an 8-bit result that is zero-extended to 32 bits. It is activated through custom R-type instructions with function codes `101100` (posit add) and `101101` (posit multiply).

### ALU Integrity Checker

The ALU integrity checker sits between the ALU and the rest of the pipeline, acting as a safety net for computational correctness. It is a parity-based fault detection module that can flag potential hardware errors, bit-flips, or module disagreements.

The checker works as follows:

1. It computes the XOR parity of all 32 bits of both the standard ALU result and the posit result.
2. When a posit instruction is active (`use_posit_i` is high), it compares the two parity values. A mismatch raises a `fault_o` signal, indicating that the two computation paths produced inconsistent results.
3. Regardless of fault status, it passes through the appropriate result (posit or standard ALU) along with its parity bit for downstream use.

This kind of redundancy checking is important in safety-critical or high-reliability systems where silent data corruption is unacceptable. Even though the posit and standard ALU compute different things in general, the parity comparison provides a lightweight sanity check that can catch certain classes of transient hardware faults.

### BNN Coprocessor

Binary neural networks (BNNs) constrain weights to +1 and -1, which means that multiplications reduce to simple bitwise operations. This makes BNN inference extremely hardware-efficient and a good fit for edge devices with limited power and area budgets.

The BNN coprocessor is a small, self-contained module integrated into the execute stage alongside the main ALU. It supports three operations via custom opcodes:

| Opcode | Binary | Operation | Description |
|--------|--------|-----------|-------------|
| `111100` | `2'b00` | XNOR | Bitwise XNOR of two 32-bit vectors. This is the BNN equivalent of multiplication: when inputs are encoded as 0/1 (representing -1/+1), XNOR produces 1 where both inputs agree and 0 where they differ. |
| `111101` | `2'b01` | Accumulate | Adds the input to an internal 32-bit accumulator register. Used to sum up partial products across a layer. |
| `111110` | `2'b10` | Activate | Step activation function. If the accumulator value is greater than or equal to the threshold input, outputs all 1s; otherwise outputs all 0s. |

These three operations form the core inference loop for a binary neural network layer: XNOR the input activations with the weight vector, accumulate the popcount across chunks, and apply a threshold activation to produce the output for the next layer.

The coprocessor has its own internal accumulator register that persists across instructions, allowing multi-step computations. Its result is multiplexed into the pipeline when the ALU control signals indicate a BNN operation.

## Instruction Set

The processor implements a subset of MIPS32 plus custom extensions:

### Standard MIPS Instructions

| Type | Instruction | Opcode | Funct | Description |
|------|-------------|--------|-------|-------------|
| R | `add $rd, $rs, $rt` | `000000` | `100000` | rd = rs + rt |
| R | `sub $rd, $rs, $rt` | `000000` | `100010` | rd = rs - rt |
| R | `and $rd, $rs, $rt` | `000000` | `100100` | rd = rs & rt |
| R | `or $rd, $rs, $rt` | `000000` | `100101` | rd = rs \| rt |
| R | `slt $rd, $rs, $rt` | `000000` | `101010` | rd = (rs < rt) ? 1 : 0 |
| I | `addi $rt, $rs, imm` | `001000` | -- | rt = rs + sign_ext(imm) |
| I | `lw $rt, imm($rs)` | `100011` | -- | rt = mem[rs + sign_ext(imm)] |
| I | `sw $rt, imm($rs)` | `101011` | -- | mem[rs + sign_ext(imm)] = rt |
| I | `beq $rs, $rt, offset` | `000100` | -- | if (rs == rt) PC += offset*4 |

### Custom Extensions

| Type | Instruction | Opcode | Funct | Description |
|------|-------------|--------|-------|-------------|
| R | posit add | `000000` | `101100` | 8-bit posit addition on lower bytes of rs, rt |
| R | posit mul | `000000` | `101101` | 8-bit posit multiplication on lower bytes of rs, rt |
| Custom | BNN XNOR | `111100` | -- | Bitwise XNOR of rs and rt |
| Custom | BNN accumulate | `111101` | -- | Accumulate rs into BNN accumulator |
| Custom | BNN activate | `111110` | -- | Threshold activation against rs |

### Encoding Formats

**R-type (register):**
```
[opcode(6)] [rs(5)] [rt(5)] [rd(5)] [shamt(5)] [funct(6)]
```

**I-type (immediate):**
```
[opcode(6)] [rs(5)] [rt(5)] [immediate(16)]
```

## Simulation and Testing

Each processor variant has its own set of testbenches that verify individual modules and the full integrated design.

### Custom Processor Test Results

The full processor testbench runs a 14-instruction test program that exercises the ALU, memory path, and pipeline hazard logic. The simulation completes at 520 ns with the following final register state:

```
R0 (zero) = 0
R2 (v0)   = 25
R3 (v1)   = 25
R4 (a0)   = 1
R5 (a1)   = 14
R6 (a2)   = 0
R7 (a3)   = 0
```

These values match the expected results, confirming correct execution of `addi`, `add`, `sub`, `and`, `or`, `slt`, `sw`, and `lw` instructions through the pipeline with forwarding active.

### Unit Test Coverage

The custom processor includes 10 testbenches:

| Testbench | What it verifies |
|-----------|------------------|
| `processor_top_tb.v` | Full 5-stage pipeline integration |
| `alu_tb.v` | All 7 ALU operations (22 test cases) |
| `PC_reg_tb.v` | Program counter reset, enable, and latching |
| `register_file_tb.v` | Dual-port reads, write-to-read bypass, register 0 hardwiring |
| `instruction_memory_tb.v` | ROM loading and address decoding |
| `data_memory_tb.v` | Synchronous write and combinational read |
| `sign_extend_tb.v` | 16-to-32-bit sign extension |
| `posit_unit_tb.v` | Posit add, multiply, and zero-input edge cases |
| `bnn_coprocessor_tb.v` | XNOR, accumulate, and activate operations |
| `alu_integrity_checker_tb.v` | Normal ALU path, posit fault detection, posit no-fault |

## How to Run

### Prerequisites

- [Xilinx Vivado](https://www.xilinx.com/products/design-tools/vivado.html) (used for all simulation and waveform capture), or
- [Icarus Verilog](http://iverilog.icarus.com/) (open-source alternative for behavioral simulation)
- A C++ compiler (g++ or equivalent) if you want to regenerate the test program

### Running the Custom Processor in Vivado

1. Create a new Vivado project.
2. Add all files under `microprocesser_files/custom_processor/design_files/` as design sources, including the `posit/`, `bnn/`, and `security_check/` subdirectories.
3. Add `simulation_files/processor_top_tb.v` as a simulation source and set it as the top module.
4. Copy `rom_files/program.mem` into the Vivado simulation working directory.
5. Run behavioral simulation for at least 500 ns.

### Running with Icarus Verilog

From the `custom_processor/simulation_files/` directory:

```bash
cp ../rom_files/program.mem .

iverilog -g2012 -o processor.vvp processor_top_tb.v \
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
  ../design_files/mem_wb_reg.v \
  ../design_files/adder.v \
  ../design_files/and_gen.v

vvp processor.vvp
```

### Generating a Test Program

```bash
cd microprocesser_files/custom_processor/rom_files/
g++ -o mips_gen mips_gen.cpp
./mips_gen
```

This produces a `program.mem` file with a 14-instruction test sequence. Edit `mips_gen.cpp` to add custom test programs, including posit and BNN instructions.

## Design Decisions and Tradeoffs

A few notes on choices made during the design:

- **8-bit posits instead of 16 or 32.** Keeping the posit width at 8 bits with ES=2 was a deliberate tradeoff. It keeps the encoder/decoder logic small enough to fit in the execute stage without dramatically increasing the critical path, while still demonstrating the concept. A wider posit would give more precision but at significant area and timing cost.

- **Parity-based checking instead of full redundancy.** A full dual-modular redundancy (DMR) setup where two independent ALUs compare outputs would catch more faults, but it would also double the ALU area. The parity-based approach catches single-bit errors with minimal hardware overhead.

- **BNN as a coprocessor rather than ISA-level integration.** The BNN module has its own internal accumulator state, which makes it behave more like a small coprocessor than a pure MIPS functional unit. This was a practical choice: BNN inference is inherently stateful (accumulate across a layer, then activate), and threading that state through the register file would have required multiple instructions per step with no benefit.

- **Branch resolution in the execute stage.** Resolving branches in EX rather than in decode simplifies the forwarding logic but means a taken branch wastes one fetch cycle (the incorrectly fetched instruction is flushed). For this design the simplicity was worth the one-cycle penalty.

## Acknowledgments

This project was developed as a learning exercise in digital design and computer architecture. The base MIPS architecture follows the design methodology presented in standard computer organization textbooks, with the custom extensions being original additions.
