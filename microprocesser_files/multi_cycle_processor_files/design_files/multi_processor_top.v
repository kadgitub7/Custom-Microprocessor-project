module multi_processor_top(
    input clk

);
    wire reset_PC;
    wire [31:0] PC_D;
    wire [31:0] PC_Q;
    wire [31:0] PC_Q_not;

    wire [31:0] WD;
    wire WE;
    wire [31:0] RD;

    wire [31:0] RD1;

    wire IRWrite;
    wire [31:0] extended_sign;
    wire [31:0] SrcA;
    wire [31:0] SrcB;
    wire [31:0] ALUResult;
    wire zero;
    

    reg [31:0] instruction_storage_imm;
    reg [31:0] A;
    reg [31:0] AluOut;
    reg [31:0] DataMemOut;
    reg [31:0] B;

    PC_reg PC(.clk(clk), .reset(reset_PC), .PC_write((zero & Branch) | PC_write), .D(PC_D), .Q(PC_Q), .Q_not(PC_Q_not));
    data_memory DM(.addr(Adr), .WD(B), .clk(clk), .WE(MemWrite), .RD(RD));
    register_file regfile(.clk(clk), .WE3(WE), .addr1(instruction_storage_imm[25:21]), .addr2(instruction_storage_imm[20:16]), .addr3(instruction_storage_imm[20:16]), .WD3(DataMemOut), .RD1(RD), .RD2(RD));
    sign_extend se(.instr(instruction_storage_imm[15:0]), .extended_instr(extended_sign));
    alu alu(.SrcA(SrcA), .SrcB(SrcB), .ALUControl(ALUControl), .ALUResult(ALUResult), .zero(zero));
    mux_gen data_mem_mux(.a(PC_Q[9:0]), .b(AluOut), .sel(IorD), out(Adr));

    mux_gen ALUa(.a(PC_Q), .b(A), sel(ALUSrcA), .out(SrcA));
    mux_4 ALUb(.a(B), .b(1'd4), .c(extended_sign), .d(extended_sign << 2), .sel(ALUSrcB), .out(SrcB));

    mux_gen regDST(.a(instruction_storage_imm[20:16]), .b(instruction_storage_imm[15:11]), .sel(RegDst), .out(A3));
    mux_gen regFileWD3(.a(AluOut), .b(DataMemOut), .sel(MemtoReg), .out(WD3));

    mux_gen pc_mux(.a(ALUResult), .b(AluOut), .sel(PCSrc), .out(PC_D));

    always @(posedge clk) begin
        if(IRWrite) begin
            instruction_storage_imm <= RD;
        end
        A <= RD1;
        AluOut <= ALUResult;
        DataMemOut <= RD;
        B <= RD2;

    end


endmodule