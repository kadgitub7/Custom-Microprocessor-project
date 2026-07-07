module ex_mem_reg(
    input clk,

    input [31:0] ALUOutE,
    input [31:0] RD2_E,
    input [4:0] Rt_E,
    input [4:0] Rd_E,

    input RegDst_E,
    input MemtoReg_E,
    input RegWrite_E,
    input MemWrite_E,
    input Branch_E,

    output reg [31:0] ALUOutM,
    output reg [31:0] RD2_M,
    output reg [4:0] Rt_M,
    output reg [4:0] Rd_M,

    output reg RegDst_M,
    output reg MemtoReg_M,
    output reg RegWrite_M,
    output reg MemWrite_M,
    output reg Branch_M
);

always @(posedge clk)
begin
    ALUOutM <= ALUOutE;
    RD2_M <= RD2_E;
    Rt_M <= Rt_E;
    Rd_M <= Rd_E;

    RegDst_M <= RegDst_E;
    MemtoReg_M <= MemtoReg_E;
    RegWrite_M <= RegWrite_E;
    MemWrite_M <= MemWrite_E;
    Branch_M <= Branch_E;
end

endmodule
