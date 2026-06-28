module processor_top(
    input clk,
    input reset_PC,
    input [2:0] ALUControl,
    input WE3,

    output [31:0] RD1,
    output [31:0] RD2,
    output [31:0] IM_RD_out,
    output [31:0] PC_Q,
    output [31:0] IM_RD
);
    wire RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, PCSrc, zero, WE_DM;
    wire [31:0] SrcB, ALUResult, PC_D, A3, PC_Q_not, PC_plus4, WB_Data, MemReadData, PC_branch;

    PC_reg PC(.clk(clk), .reset(reset_PC), .D(PC_D), .Q(PC_Q), .Q_not(PC_Q_not));
    instruction_memory IM(.addr(PC_Q), .RD(IM_RD));

    register_file regfile(.clk(clk), .WE3(WE3), .addr1(IM_RD[25:21]), .addr2(IM_RD[20:16]), .addr3(A3), .WD3(WB_Data), .RD1(RD1), .RD2(RD2));
    sign_extend se(.instr(IM_RD[15:0]), .extended_instr(IM_RD_out));
    
    alu alu(.SrcA(RD1), .SrcB(SrcB), .ALUControl(ALUControl), .ALUResult(ALUResult), .zero(zero));
    data_memory DM(.addr(ALUResult[9:0]), .WD(RD2), .clk(clk), .WE(WE_DM), .RD(MemReadData));

    PC_incrementer pc_inc(.PC_in(PC_Q), .PC_out(PC_plus4));

    mux_gen reg_file_mux(.a(IM_RD[20:16]), .b(IM_RD[15:11]), .sel(RegDst), .out(A3));
    mux_gen alu_mux(.a(RD2), .b(IM_RD_out), .sel(ALUSrc), .out(SrcB));
    mux_gen data_mem_mux(.a(ALUResult), .b(MemReadData), .sel(MemtoReg), .out(WB_Data));
    
    adder pc_branch_adder(.a(IM_RD_out << 2), .b(PC_Q_not), .sum(PC_branch));
    and_gen branch_and(.a(Branch), .b(zero), .out(PCSrc));
    mux_gen pc_mux(.a(PC_plus4), .b(PC_branch), .sel(PCSrc), .out(PC_D));
endmodule