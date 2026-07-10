module control_unit(
    input [5:0] opcode,
    input [5:0] funct,
    output wire RegDst,
    output wire ALUSrc,
    output wire MemtoReg,
    output wire RegWrite,
    output wire MemWrite,
    output wire Branch,
    output wire [2:0] ALUControl
);    
    wire [1:0] ALUOp;
    
    assign RegDst = (opcode == 6'b000000) ? 1'b1 : 1'b0; // R-type instructions
    assign ALUSrc = (opcode == 6'b100011 || opcode == 6'b101011 || opcode == 6'b001000) ? 1'b1 : 1'b0; // LW, SW, or ADDI
    assign MemtoReg = (opcode == 6'b100011) ? 1'b1 : 1'b0; // LW instruction
    assign RegWrite = (opcode == 6'b000000 || opcode == 6'b100011 || opcode == 6'b001000) ? 1'b1 : 1'b0; // R-type, LW, or ADDI
    assign MemWrite = (opcode == 6'b101011) ? 1'b1 : 1'b0; // SW instruction
    assign Branch = (opcode == 6'b000100) ? 1'b1 : 1'b0; // BEQ instruction
    wire is_posit_add = (opcode == 6'b000000 && funct == 6'b101100);
    wire is_posit_mul = (opcode == 6'b000000 && funct == 6'b101101);
    wire is_bnn_xnor = (opcode == 6'b111100);
    wire is_bnn_accum = (opcode == 6'b111101);
    wire is_bnn_activate = (opcode == 6'b111110);
    wire is_bnn = is_bnn_xnor || is_bnn_accum || is_bnn_activate;

    assign ALUOp = (opcode == 6'b000000) ? 2'b10 : // R-type instructions
                   (opcode == 6'b000100) ? 2'b01 : // BEQ instruction
                   is_bnn ? 2'b11 : // BNN co-processor instructions
                   2'b00; // Default to load/store instructions

    assign ALUControl = (ALUOp == 2'b00) ? 3'b010 : // Load/Store/ADDI: ADD
                        (ALUOp == 2'b01) ? 3'b110 : // Branch: SUB
                        (ALUOp == 2'b11) ? 3'b100 : // BNN co-processor op
                        (ALUOp == 2'b10) ? (is_posit_add ? 3'b011 : // R-type custom: POSIT ADD
                                            is_posit_mul ? 3'b111 : // R-type custom: POSIT MUL
                                            (funct == 6'b100000) ? 3'b010 : // R-type: ADD
                                            (funct == 6'b100010) ? 3'b110 : // R-type: SUB
                                            (funct == 6'b100100) ? 3'b000 : // R-type: AND
                                            (funct == 6'b100101) ? 3'b001 : // R-type: OR
                                            (funct == 6'b101010) ? 3'b111 : // R-type: SLT
                                            3'b000) : // Default to AND for unknown funct
                        3'b000; // Default to AND for unknown ALUOp

endmodule