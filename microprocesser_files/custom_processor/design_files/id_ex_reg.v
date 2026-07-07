module id_ex_reg(
    input clk,

    input [31:0] RD1_D,
    input [31:0] RD2_D,
    input [31:0] SignImm_D,
    input [31:0] PCPlus4_D,

    input [4:0] Rs_D,
    input [4:0] Rt_D,
    input [4:0] Rd_D,

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
    RD1_E <= RD1_D;
    RD2_E <= RD2_D;
    SignImm_E <= SignImm_D;
    PCPlus4_E <= PCPlus4_D;

    Rs_E <= Rs_D;
    Rt_E <= Rt_D;
    Rd_E <= Rd_D;

    RegDst_E <= RegDst_D;
    ALUSrc_E <= ALUSrc_D;
    MemtoReg_E <= MemtoReg_D;
    RegWrite_E <= RegWrite_D;
    MemWrite_E <= MemWrite_D;
    Branch_E <= Branch_D;
    ALUControl_E <= ALUControl_D;
end

endmodule