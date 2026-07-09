module processor_top(
    input clk,
    input reset_PC
);

    // ========== FETCH STAGE (F) ==========
    wire [31:0] PC_F, PC_F_next, PC_plus4_F, InstrF;
    
    PC_reg PC_F_reg(.clk(clk), .reset(reset_PC), .D(PC_F_next), .Q(PC_F), .Q_not());
    instruction_memory IM(.addr(PC_F), .RD(InstrF));
    PC_incrementer pc_inc(.PC_in(PC_F), .PC_out(PC_plus4_F));

    // ========== IF/ID PIPELINE REGISTER ==========
    wire [31:0] InstrD, PCPlus4D;
    
    if_id_reg if_id(
        .clk(clk),
        .InstrF(InstrF),
        .PCPlus4F(PC_plus4_F),
        .InstrD(InstrD),
        .PCPlus4D(PCPlus4D)
    );

    // ========== DECODE STAGE (D) ==========
    wire [31:0] RD1_D, RD2_D, SignImm_D;
    wire [4:0] Rs_D, Rt_D, Rd_D;
    wire RegDst_D, ALUSrc_D, MemtoReg_D, RegWrite_D, MemWrite_D, Branch_D;
    wire [2:0] ALUControl_D;

    assign Rs_D = InstrD[25:21];
    assign Rt_D = InstrD[20:16];
    assign Rd_D = InstrD[15:11];

    register_file regfile(
        .clk(clk),
        .WE3(RegWrite_W),
        .addr1(Rs_D),
        .addr2(Rt_D),
        .addr3(WriteRegW),
        .WD3(WB_DataW),
        .RD1(RD1_D),
        .RD2(RD2_D)
    );

    sign_extend se(.instr(InstrD[15:0]), .extended_instr(SignImm_D));

    control_unit control(
        .opcode(InstrD[31:26]),
        .funct(InstrD[5:0]),
        .RegDst(RegDst_D),
        .ALUSrc(ALUSrc_D),
        .MemtoReg(MemtoReg_D),
        .RegWrite(RegWrite_D),
        .MemWrite(MemWrite_D),
        .Branch(Branch_D),
        .ALUControl(ALUControl_D)
    );

    // ========== ID/EX PIPELINE REGISTER ==========
    wire [31:0] RD1_E, RD2_E, SignImm_E, PCPlus4E;
    wire [4:0] Rs_E, Rt_E, Rd_E;
    wire RegDst_E, ALUSrc_E, MemtoReg_E, RegWrite_E, MemWrite_E, Branch_E;
    wire [2:0] ALUControl_E;

    id_ex_reg id_ex(
        .clk(clk),
        .RD1_D(RD1_D),
        .RD2_D(RD2_D),
        .SignImm_D(SignImm_D),
        .PCPlus4_D(PCPlus4D),
        .Rs_D(Rs_D),
        .Rt_D(Rt_D),
        .Rd_D(Rd_D),
        .RegDst_D(RegDst_D),
        .ALUSrc_D(ALUSrc_D),
        .MemtoReg_D(MemtoReg_D),
        .RegWrite_D(RegWrite_D),
        .MemWrite_D(MemWrite_D),
        .Branch_D(Branch_D),
        .ALUControl_D(ALUControl_D),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .SignImm_E(SignImm_E),
        .PCPlus4_E(PCPlus4E),
        .Rs_E(Rs_E),
        .Rt_E(Rt_E),
        .Rd_E(Rd_E),
        .RegDst_E(RegDst_E),
        .ALUSrc_E(ALUSrc_E),
        .MemtoReg_E(MemtoReg_E),
        .RegWrite_E(RegWrite_E),
        .MemWrite_E(MemWrite_E),
        .Branch_E(Branch_E),
        .ALUControl_E(ALUControl_E)
    );

    // ========== EXECUTE STAGE (E) ==========
    wire [31:0] SrcA_E, SrcB_E, ALUOutE;
    wire [31:0] ALUOutE_posit_ext;
    wire [31:0] ALUOutE_final;
    wire zero_E;
    wire [1:0] ALUControl_E_posit;
    wire [7:0] ALUOutE_posit;
    wire usePositE;
    wire alu_fault_E;
    wire parity_bit_E;
    wire [1:0] bnn_op_E;
    wire [31:0] bnn_acc_E;
    wire bnn_done_E;

    mux_gen alu_a_mux(.a(RD1_E), .b(PCPlus4E), .sel(1'b0), .out(SrcA_E));
    mux_gen alu_b_mux(.a(RD2_E), .b(SignImm_E), .sel(ALUSrc_E), .out(SrcB_E));

    assign ALUControl_E_posit = (ALUControl_E == 3'b111) ? 2'b01 : 2'b00;
    assign usePositE = (ALUControl_E == 3'b011 || ALUControl_E == 3'b111);
    assign ALUOutE_posit_ext = {24'b0, ALUOutE_posit};
    assign bnn_op_E = (ALUControl_E == 3'b100) ? ((InstrD[31:26] == 6'b111100) ? 2'b00 :
                                              (InstrD[31:26] == 6'b111101) ? 2'b01 : 2'b10) : 2'b11;

    alu alu_e(
        .SrcA(SrcA_E),
        .SrcB(SrcB_E),
        .ALUControl(ALUControl_E),
        .ALUResult(ALUOutE),
        .zero(zero_E)
    );

    posit_unit #(.WIDTH(8), .ES(2)) posit_unit_e(
        .a_i(SrcA_E[7:0]),
        .b_i(SrcB_E[7:0]),
        .op_i(ALUControl_E_posit),
        .result_o(ALUOutE_posit)
    );

    alu_integrity_checker #(.WIDTH(32)) alu_checker_e(
        .alu_result_i(ALUOutE),
        .posit_result_i(ALUOutE_posit_ext),
        .use_posit_i(usePositE),
        .checked_result_o(ALUOutE_final),
        .fault_o(alu_fault_E),
        .parity_bit_o(parity_bit_E)
    );

    bnn_coprocessor #(.WIDTH(32)) bnn_cop_e(
        .clk(clk),
        .reset(reset_PC),
        .op_i(bnn_op_E),
        .data_a_i(SrcA_E),
        .data_b_i(SrcB_E),
        .acc_o(bnn_acc_E),
        .done_o(bnn_done_E)
    );

    mux_gen #(.WIDTH(32)) bnn_result_mux(
        .a(ALUOutE_final),
        .b(bnn_acc_E),
        .sel(ALUControl_E == 3'b100),
        .out(ALUOutE_final)
    );

    // ========== EX/MEM PIPELINE REGISTER ==========
    wire [31:0] ALUOutM, RD2_M;
    wire [4:0] Rt_M, Rd_M;
    wire RegDst_M, MemtoReg_M, RegWrite_M, MemWrite_M, Branch_M;

    ex_mem_reg ex_mem(
        .clk(clk),
        .ALUOutE(ALUOutE_final),
        .RD2_E(RD2_E),
        .Rt_E(Rt_E),
        .Rd_E(Rd_E),
        .RegDst_E(RegDst_E),
        .MemtoReg_E(MemtoReg_E),
        .RegWrite_E(RegWrite_E),
        .MemWrite_E(MemWrite_E),
        .Branch_E(Branch_E),
        .ALUOutM(ALUOutM),
        .RD2_M(RD2_M),
        .Rt_M(Rt_M),
        .Rd_M(Rd_M),
        .RegDst_M(RegDst_M),
        .MemtoReg_M(MemtoReg_M),
        .RegWrite_M(RegWrite_M),
        .MemWrite_M(MemWrite_M),
        .Branch_M(Branch_M)
    );

    // ========== MEMORY STAGE (M) ==========
    wire [31:0] ReadDataM;

    data_memory DM(
        .addr(ALUOutM[9:0]),
        .WD(RD2_M),
        .clk(clk),
        .WE(MemWrite_M),
        .RD(ReadDataM)
    );

    // ========== MEM/WB PIPELINE REGISTER ==========
    wire [31:0] ReadDataW, ALUOutW;
    wire [4:0] Rt_W, Rd_W;
    wire RegDst_W, MemtoReg_W, RegWrite_W;

    mem_wb_reg mem_wb(
        .clk(clk),
        .ReadDataM(ReadDataM),
        .ALUOutM(ALUOutM),
        .Rt_M(Rt_M),
        .Rd_M(Rd_M),
        .RegDst_M(RegDst_M),
        .MemtoReg_M(MemtoReg_M),
        .RegWrite_M(RegWrite_M),
        .ReadDataW(ReadDataW),
        .ALUOutW(ALUOutW),
        .Rt_W(Rt_W),
        .Rd_W(Rd_W),
        .RegDst_W(RegDst_W),
        .MemtoReg_W(MemtoReg_W),
        .RegWrite_W(RegWrite_W)
    );

    // ========== WRITEBACK STAGE (W) ==========
    wire [31:0] WB_DataW;
    wire [4:0] WriteRegW;

    mux_gen write_reg_mux(
        .a(Rt_W),
        .b(Rd_W),
        .sel(RegDst_W),
        .out(WriteRegW)
    );

    mux_gen wb_mux(
        .a(ALUOutW),
        .b(ReadDataW),
        .sel(MemtoReg_W),
        .out(WB_DataW)
    );

    // ========== PC NEXT LOGIC ==========
    assign PC_F_next = PC_plus4_F;

endmodule