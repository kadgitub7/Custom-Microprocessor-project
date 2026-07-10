module id_ex_reg(
    input clk,
    input reset,
    input flush,

    input [31:0] RD1_D,
    input [31:0] RD2_D,
    input [31:0] SignImm_D,
    input [31:0] PCPlus4_D,

    input [4:0] Rs_D,
    input [4:0] Rt_D,
    input [4:0] Rd_D,
    input [5:0] opcode_D,
    input [5:0] funct_D,

    input RegDst_D,
    input ALUSrc_D,
    input MemtoReg_D,
    input RegWrite_D,
    input MemWrite_D,
    input Branch_D,
    input [2:0] ALUControl_D,

    output reg [31:0] RD1_E,
    output reg [31:0] RD2_E,
    output reg [31:0] SignImm_E,
    output reg [31:0] PCPlus4_E,

    output reg [4:0] Rs_E,
    output reg [4:0] Rt_E,
    output reg [4:0] Rd_E,
    output reg [5:0] opcode_E,
    output reg [5:0] funct_E,

    output reg RegDst_E,
    output reg ALUSrc_E,
    output reg MemtoReg_E,
    output reg RegWrite_E,
    output reg MemWrite_E,
    output reg Branch_E,
    output reg [2:0] ALUControl_E
);

always @(posedge clk)
begin
    if (reset || flush) begin
        RD1_E <= 32'b0;
        RD2_E <= 32'b0;
        SignImm_E <= 32'b0;
        PCPlus4_E <= 32'b0;
        Rs_E <= 5'b0;
        Rt_E <= 5'b0;
        Rd_E <= 5'b0;
        opcode_E <= 6'b0;
        funct_E <= 6'b0;
        RegDst_E <= 1'b0;
        ALUSrc_E <= 1'b0;
        MemtoReg_E <= 1'b0;
        RegWrite_E <= 1'b0;
        MemWrite_E <= 1'b0;
        Branch_E <= 1'b0;
        ALUControl_E <= 3'b000;
    end else begin
        RD1_E <= RD1_D;
        RD2_E <= RD2_D;
        SignImm_E <= SignImm_D;
        PCPlus4_E <= PCPlus4_D;

        Rs_E <= Rs_D;
        Rt_E <= Rt_D;
        Rd_E <= Rd_D;
        opcode_E <= opcode_D;
        funct_E <= funct_D;

        RegDst_E <= RegDst_D;
        ALUSrc_E <= ALUSrc_D;
        MemtoReg_E <= MemtoReg_D;
        RegWrite_E <= RegWrite_D;
        MemWrite_E <= MemWrite_D;
        Branch_E <= Branch_D;
        ALUControl_E <= ALUControl_D;
    end
end

endmodule