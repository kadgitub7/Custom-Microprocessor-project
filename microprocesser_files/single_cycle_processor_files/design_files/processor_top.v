module processor_top(
    input clk,
    input reset_PC,
    input [31:0] PC_D,
    output [31:0] PC_Q,
    output [31:0] PC_Q_not,
    output [31:0] IM_RD
);
    PC_reg PC(.clk(clk), .reset(reset_PC), .D(PC_D), .Q(PC_Q), .Q_not(PC_Q_not));
    instruction_memory IM(.addr(PC_Q[9:0]), .RD(IM_RD));

    
endmodule