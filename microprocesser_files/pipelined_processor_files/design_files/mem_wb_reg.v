module mem_wb_reg(
    input clk,

    input [31:0] ReadDataM,
    input [31:0] ALUOutM,
    input [4:0] Rt_M,
    input [4:0] Rd_M,

    input MemtoReg_M,
    input RegWrite_M,

    output reg [31:0] ReadDataW,
    output reg [31:0] ALUOutW,
    output reg [4:0] Rt_W,
    output reg [4:0] Rd_W,

    output reg MemtoReg_W,
    output reg RegWrite_W
);

always @(posedge clk)
begin
    ReadDataW <= ReadDataM;
    ALUOutW <= ALUOutM;
    Rt_W <= Rt_M;
    Rd_W <= Rd_M;

    MemtoReg_W <= MemtoReg_M;
    RegWrite_W <= RegWrite_M;
end

endmodule
