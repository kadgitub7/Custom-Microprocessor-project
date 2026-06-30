# PROJECT TIMELINE & OBJECTIVES

**Short Disclaimer**
This .md file is for people that want to understand what process as well as stuggles I went through to complete this project. Through this approach I will learn a lot and hit many roadblocks, which I hope to overcome. By following this file, you can see what my objectives, by path to implementation, and learning is.

## Performance Metrics
Different microprocessors have different metrics to measure from. Companies often advertise the specific metrics that are good for their processor.

Execution time is often a very important metric. It is calculated as such: 

Execution time = (# of intructions)*(Cycles/instruction)*(Seconds/Cycle)

The main point to emphasize is that you want to reduce the amount of hardware components that can still achieve the same output. We also want to make those components more effecient so that they are faster and take up less memory.

## Single Cycle Processor

### 1. Design the state elements:

#### a) Program Counter Register -> 32 bit D flip flop register with synchronous reset

- Utilized a 32 bit D master slave flip flop. When the clock is high on the positive rising edge, we sample the input D and assign it to Q. If the reset is high then Q goes to 0. D is a 32 bit value.
- The main purpose of this is to have single instructions stored so that we are then able to sequential conduct instructions. This PC stores the next intruction to follow.

| File Type | Location |
|-----------|----------|
| Design | microprocesser_files\single_cycle_processor_files\design_files\PC_reg.v |
| Simulation | microprocesser_files\single_cycle_processor_files\simulation_files\PC_reg_tb.v |
| Output | microprocesser_files\single_cycle_processor_files\simulation_files\output\PC_reg_tb_output.txt |
| Waveform | microprocesser_files\single_cycle_processor_files\simulation_files\waveform\PC_reg_tb_waveform.png |


#### b) Instruction Memory -> memory ROM file which contains the intruction decoding to machine code

- Input a 32 bit instruction and decode it from a look up table to output the corresponding machine code command. To accuractely do this, the approach is to take the input and strip the last two bits. This calibrates it so that it represents the exact index in the .mem file. For this processor there are 4 bytes per command. Therefore instructions go 0,4,8 ... To make these values align with 0,1,2 ... we need to strip the last two bits.
- The file program.mem has all the instructions decoded into machine code, this file needs to be added to for the full intruction set

| File Type | Location |
|-----------|----------|
| Design | microprocesser_files\single_cycle_processor_files\design_files\instruction_memory.v |
| Simulation | microprocesser_files\single_cycle_processor_files\simulation_files\instruction_memory_tb.v |
| Output | microprocesser_files\single_cycle_processor_files\simulation_files\output\instruction_memory_tb_output.txt |
| Waveform | microprocesser_files\single_cycle_processor_files\simulation_files\waveform\instruction_memory_tb_waveform.png |
| Memory File |microprocesser_files\single_cycle_processor_files\simulation_files\rom_files\program.mem |

#### c) Register File, responsing to multi read and write actions

- This is a system that is connected with the entire process of taking in instructions and calling actual function from the ALU. It acts to be able to read on mulitple ports the results of various operations as well as to write value after an operation is complete.
- This block consists of ways to use 5 bit values to index into the specific index fo the register file as well as enables and clock based writing.

| File Type | Location |
|-----------|----------|
| Design | microprocesser_files\single_cycle_processor_files\design_files\register_file.v |
| Simulation | microprocesser_files\single_cycle_processor_files\simulation_files\register_file_tb.v |
| Output | microprocesser_files\single_cycle_processor_files\simulation_files\output\register_file_tb_output.txt |
| Waveform | microprocesser_files\single_cycle_processor_files\simulation_files\waveform\register_file_tb_waveform.png |

#### d) Data Memory File. This file stored a large memory which can both be written to or else read combinationally

- This is an SRAM which holds the majority of information for the processor. Anything that is too big to store in the register file can be kept here. It takes longer to get the information from this section but it is larger.
- The writing is used whenever there is an enable, the reading is done otherwise.

| File Type | Location |
|-----------|----------|
| Design | microprocesser_files\single_cycle_processor_files\design_files\data_memory.v |
| Simulation | microprocesser_files\single_cycle_processor_files\simulation_files\data_memory_tb.v |
| Output | microprocesser_files\single_cycle_processor_files\simulation_files\output\data_memory_tb_output.txt |
| Waveform | microprocesser_files\single_cycle_processor_files\simulation_files\waveform\data_memory_tb_waveform.png |

### 2. Connect the state elements together:

#### a) Connecting the Program counter to the instruction memory
- The program counter holds the instructions to the next instruction to execute. We then get the address which is fed through the output of the program counter to get the exact address of the instruction to execute in the instruction memory.

| File Type | Location |
|-----------|----------|
| Design | microprocesser_files\single_cycle_processor_files\design_files\processor_top.v |

#### b) Create Sign Extend module

- This is a simple combinational module which is used to take the instruction output from the instruction memory and then it concatenates the instruction with 16 * the MVB. This makes the sign of the bit extended which is outputed.

| File Type | Location |
|-----------|----------|
| Design | microprocesser_files\single_cycle_processor_files\design_files\sign_extend.v |
| Simulation | microprocesser_files\single_cycle_processor_files\simulation_files\sign_extend_tb.v |
| Output | microprocesser_files\single_cycle_processor_files\simulation_files\output\sign_extend_tb_output.txt |
| Waveform | microprocesser_files\single_cycle_processor_files\simulation_files\waveform\sign_extend_tb_waveform.png |


#### c) Create ALU module

- The ALU is the central computing element of the proccessor. It includes the ability to take certain control commands and perform action such as ADD, SUBTRACT, AND, OR, COMPARE.
- This is done through a full adder, AND, OR gates, and compliment(NOT gates) inside the module which compute all the various value in parallel. Then these are fed through a multiplexer which process which output should be given as final based on the control signal which is a select line for the MUX.

| File Type | Location |
|-----------|----------|
| Design | microprocesser_files\single_cycle_processor_files\design_files\alu.v |
| Simulation | microprocesser_files\single_cycle_processor_files\simulation_files\alu_tb.v |
| Output | microprocesser_files\single_cycle_processor_files\simulation_files\output\alu_tb_output.txt |
| Waveform | microprocesser_files\single_cycle_processor_files\simulation_files\waveform\alu_tb_waveform.png |

#### c) Wire Top module and Create control unit

- The top module was wired based on teh schematic in the textbook referenced. The wiring is done in a control flow where the elementary block are fed into each other. Different adders and mulitplexers are used to discern different inputs and to chose/compute the result.
- The control unit was made using the truth table in the textbook and is wired to the top module appropriately.

| File Type | Location |
|-----------|----------|
| Design | microprocesser_files\single_cycle_processor_files\design_files\processor_top.v |
| Design | microprocesser_files\single_cycle_processor_files\design_files\control_unit.v |

## Multicycle Processor
### 0. Rationale behind multi cycle processor
There are three main disadvantages with the single cycle processor.
1) It requires the same time to do long instructions as does short instructions. Which means that short instructions take longer than they need to
2) There are three adder elements. One in the ALU and two for the Program counter setter. Adders are expensive circuits and should be minimized when able. 
3) There are mulitple memory blocks for different reasons. It is more efficient to have a single one that is large and holds all the information and can both be read and written to.

The mulitcycle processor does this efficiently, it utilizes registers in teh middle processes so that long instructions go through the same time, but a short instruction can be finished early and exit with the result.
It uses only 1 adder to do all its operations and uses 1 large memory file for everything.