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
    assign ALUSrc = (opcode == 6'b100011 || opcode == 6'b101011) ? 1'b1 : 1'b0; // LW or SW
    assign MemtoReg = (opcode == 6'b100011) ? 1'b1 : 1'b0; // LW instruction
    assign RegWrite = (opcode == 6'b000000 || opcode == 6'b100011) ? 1'b1 : 1'b0; // R-type or LW
    assign MemWrite = (opcode == 6'b101011) ? 1'b1 : 1'b0; // SW instruction
    assign Branch = (opcode == 6'b000100) ? 1'b1 : 1'b0; // BEQ instruction
    assign ALUOp = (opcode == 6'b000000) ? 2'b10 : // R-type instructions
                   (opcode == 6'b000100) ? 2'b01 : // BEQ instruction
                   2'b00; // Default to load/store instructions

    assign ALUControl = (ALUOp == 2'b00) ? 3'b010 : // Load/Store: ADD
                        (ALUOp == 2'b01) ? 3'b110 : // Branch: SUB
                        (ALUOp == 2'b10) ? ((funct == 6'b100000) ? 3'b010 : // R-type: ADD
                                            (funct == 6'b100010) ? 3'b110 : // R-type: SUB
                                            (funct == 6'b100100) ? 3'b000 : // R-type: AND
                                            (funct == 6'b100101) ? 3'b001 : // R-type: OR
                                            3'b000) : // Default to AND for unknown funct
                        3'b000; // Default to AND for unknown ALUOp

endmodule