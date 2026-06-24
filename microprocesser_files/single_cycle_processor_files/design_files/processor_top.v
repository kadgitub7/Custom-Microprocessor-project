module processor_top(
    input clk,
    input reset_PC,
    input [31:0] PC_D,
    input WE3,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD3,
    output [31:0] RD1,
    output [31:0] RD2,
    output [31:0] IM_RD_out,
    output [31:0] PC_Q,
    output [31:0] PC_Q_not,
    output [31:0] IM_RD
);
    PC_reg PC(.clk(clk), .reset(reset_PC), .D(PC_D), .Q(PC_Q), .Q_not(PC_Q_not));
    instruction_memory IM(.addr(PC_Q[9:0]), .RD(IM_RD));

    register_file regfile(.clk(clk), .WE3(WE3), .A1(IM_RD[25:21]), .A2(A2), .A3(A3), .WD3(WD3), .RD1(RD1), .RD2(RD2));
    sign_extend se(.instr(IM_RD[15:0]), .extended_instr(IM_RD_out));


endmodule