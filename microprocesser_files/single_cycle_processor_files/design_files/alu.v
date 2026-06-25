`timescale 1ns / 1ps

module alu(
    input [31:0] SrcA,
    input [31:0] SrcB,
    input wire [2:0] ALUControl,
    
    output zero,
    output reg [31:0] ALUResult
    );
    
    always @(*) begin
        case (ALUControl)
            3'b000: ALUResult = SrcA & SrcB;
            3'b001: ALUResult = SrcA | SrcB;
            3'b010: ALUResult = SrcA + SrcB;
            3'b100: ALUResult = SrcA & ~SrcB;
            3'b101: ALUResult = SrcA | ~SrcB;
            3'b110: ALUResult = SrcA - SrcB;
            3'b111: ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 32'b1:32'b0;
            default: ALUResult = SrcA + SrcB;
        endcase
    end
    
    assign zero = (ALUResult == 32'b0);
    
endmodule
