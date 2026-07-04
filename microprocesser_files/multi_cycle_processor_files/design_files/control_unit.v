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
    
    reg [2:0] state;
    reg [2:0] next_state;
    
    wire [1:0] ALUOp;

    // State parameters
    parameter FETCH = 3'b000;
    parameter DECODE = 3'b001;
    parameter MemoryAdr = 3'b010;
    parameter MemRead = 3'b011;
    parameter MemWrite_State = 3'b100;
    parameter Mem_Write = 3'b101;
    parameter EXECUTE = 3'b110;
    parameter ALUWriteBack = 3'b111;

    // Sequential state update
    always @(posedge clk) begin
        if (reset) begin
            state <= FETCH;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            FETCH: 
                next_state = DECODE;
            DECODE:
                if (opcode == 6'b100011 || opcode == 6'b101011) begin
                    next_state = MemoryAdr;
                end 
                else if (opcode == 6'b000000) begin
                    next_state = EXECUTE;
                end
                else begin
                    next_state = FETCH;
                end
            MemoryAdr:
                if (opcode == 6'b100011) begin
                    next_state = MemRead;
                end
                else if (opcode == 6'b101011) begin
                    next_state = Mem_Write;
                end
                else begin
                    next_state = FETCH;
                end
            MemRead:
                next_state = MemWrite_State;
            MemWrite_State:
                next_state = FETCH;
            Mem_Write:
                next_state = FETCH;
            EXECUTE:
                next_state = ALUWriteBack;
            ALUWriteBack:
                next_state = FETCH;
            default: 
                next_state = FETCH;
        endcase
    end

    // Output control signals (combinational based on current state)
    assign IRWrite = (state == FETCH) ? 1'b1 : 1'b0;
    assign PCWrite = (state == FETCH) ? 1'b1 : 1'b0;
    assign Branch = 1'b0; // No branch instruction support in basic implementation
    
    assign ALUSrcA = (state == FETCH || state == DECODE) ? 1'b0 : 1'b1;
    assign ALUSrcB = (state == FETCH) ? 2'b01 :
                     (state == MemoryAdr) ? 2'b10 :
                     (state == EXECUTE) ? 2'b00 :
                     2'b00;
    
    assign IorD = (state == FETCH) ? 1'b0 : 1'b1;
    assign PCSrc = 1'b0; // Always use ALU result for next PC (addition result)
    
    assign RegDst = (state == ALUWriteBack) ? 1'b1 : 1'b0;
    assign RegWrite = (state == MemWrite_State || state == ALUWriteBack) ? 1'b1 : 1'b0;
    assign MemtoReg = (state == MemWrite_State) ? 1'b1 : 1'b0;
    assign MemWrite = (state == Mem_Write) ? 1'b1 : 1'b0;

    // ALU operation control
    assign ALUOp = (opcode == 6'b000000) ? 2'b10 : // R-type instructions
                   (opcode == 6'b000100) ? 2'b01 : // BEQ instruction
                   2'b00; // Default to load/store instructions

    // ALU control signals based on ALUOp and funct field
    assign ALUControl = (ALUOp == 2'b00) ? 3'b010 : // Load/Store: ADD
                        (ALUOp == 2'b01) ? 3'b110 : // Branch: SUB
                        (ALUOp == 2'b10) ? ((funct == 6'b100000) ? 3'b010 : // R-type: ADD
                                            (funct == 6'b100010) ? 3'b110 : // R-type: SUB
                                            (funct == 6'b100100) ? 3'b000 : // R-type: AND
                                            (funct == 6'b100101) ? 3'b001 : // R-type: OR
                                            3'b000) : // Default to AND for unknown funct
                        3'b000; // Default to AND for unknown ALUOp

endmodule