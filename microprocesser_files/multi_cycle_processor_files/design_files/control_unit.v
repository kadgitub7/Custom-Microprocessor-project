module control_unit(
    input clk,
    input reset,
    input [5:0] opcode,
    input [5:0] funct,
    output wire MemtoReg,
    output wire RegDst,
    output wire IorD,
    output wire PCSrc,
    output wire [1:0] ALUSrcB,
    output wire ALUSrcA,
    output wire IRWrite,
    output wire MemWrite,
    output wire PCWrite,
    output wire Branch,
    output wire RegWrite,
    output wire [2:0] ALUControl
);    
    wire [1:0] ALUOp;
    
    reg [2:0] state;

    reg FETCH = 3'b000;
    reg DECODE = 3'b001;
    reg MemoryAdr = 3'b010;
    reg MemRead = 3'b011;
    reg MemWriteState = 3'b100;
    reg MemWrite = 3'b101;
    reg EXECUTE = 3'b110;
    reg ALUWriteBack = 3'b111;


    always @(posedge clk) begin
        if (reset) begin
            state <= FETCH;
        end else begin
            case (state)
                FETCH: 
                    IorD <= 1'b0; // Fetch instruction
                    ALUSrcA <= 1'b0; // Use PC as ALU input A
                    ALUSrcB <= 2'b01; // Use 4 as ALU input B
                    ALUOp <= 2'b00; // ALU performs addition
                    PCSrc <= 1'b0; // Next PC is PC + 4
                    PCWrite <= 1'b1; // Enable PC write
                    IRWrite <= 1'b1; // Enable instruction register write
                    state <= DECODE;
                DECODE:
                    if (Opcode == 6'b100011 || Opcode == 6'b101011) begin
                        state <= MemoryAdr; // MEMORYAdr
                    end 
                    else if (Opcode == 6'b000000) begin
                        state <= EXECUTE; // R-type instruction
                    end 
                MemoryAdr:
                    ALUSrcA <= 1'b1; // Use register A as ALU input A
                    ALUSrcB <= 2'b10; // Use sign-extended immediate as AL
                    ALUOp <= 2'b00; // ALU performs addition 
                    if (Opcode == 6'b100011) begin
                        state <= 3'b011; // MemRead
                    end
                    else if (Opcode == 6'b101011) begin
                        state <= 3'b101; // MemWriteState
                    end
                MemRead:
                    IorD <= 1'b1; // Enable memory read
                    state <= 3'b100; // WriteBack
                MemWriteState:
                    RegDst <= 1'b0; // Write to register file
                    MemtoReg <= 1'b1; // Write data from memory to register
                    RegWrite <= 1'b1; // Enable register write
                    state <= FETCH; // Go back to FETCH
                MemWrite:
                    IorD <= 1'b1; // Enable memory write
                    MemWrite <= 1'b1; // Enable memory write
                    state <= FETCH; // Go back to FETCH
                EXECUTE:
                    ALUSrcA <= 1'b1; // Use register A as ALU input A
                    ALUSrcB <= 2'b00; // Use register B as ALU input B
                    ALUOp <= 2'b10; // ALU performs operation based on funct field
                    state <= ALUWriteBack; // Go back to FETCH
                ALUWriteBack:
                    RegDst <= 1'b1; // Write to register file
                    MemtoReg <= 1'b0; // Write data from ALU to register
                    RegWrite <= 1'b1; // Enable register write
                    state <= FETCH; // Go back to FETCH
                default: state <= FETCH;
            endcase
        end
    end



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