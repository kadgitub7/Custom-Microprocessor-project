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

