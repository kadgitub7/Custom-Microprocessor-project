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

