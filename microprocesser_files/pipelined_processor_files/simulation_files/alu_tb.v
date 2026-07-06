`timescale 1ns / 1ps

module alu_tb();
   
    reg [31:0] SrcA,SrcB;
    reg [2:0] ALUControl;
    
    wire zero;
    wire [31:0] ALUResult;
    
    alu uut(.SrcA(SrcA), .SrcB(SrcB), .ALUControl(ALUControl), .zero(zero), .ALUResult(ALUResult));
    
    initial begin
        // AND
        SrcA = 32'b0;
        SrcB = 32'b0;
        ALUControl = 3'b000;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        SrcA = 32'b0;
        SrcB = 32'b1;
        ALUControl = 3'b000;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        SrcA = 32'b1;
        SrcB = 32'b0;
        ALUControl = 3'b000;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        SrcA = 32'b1;
        SrcB = 32'b1;
        ALUControl = 3'b000;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        // OR
        SrcA = 32'b0;
        SrcB = 32'b0;
        ALUControl = 3'b001;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        SrcA = 32'b0;
        SrcB = 32'b1;
        ALUControl = 3'b001;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        SrcA = 32'b1;
        SrcB = 32'b0;
        ALUControl = 3'b001;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        SrcA = 32'b1;
        SrcB = 32'b1;
        ALUControl = 3'b001;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        // ADD
        SrcA = 32'b1;
        SrcB = 32'b0;
        ALUControl = 3'b010;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        SrcA = 32'b1;
        SrcB = 32'b1;
        ALUControl = 3'b010;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        // Compliment AND
        SrcA = 32'b0;
        SrcB = 32'b0;
        ALUControl = 3'b100;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        SrcA = 32'b0;
        SrcB = 32'b1;
        ALUControl = 3'b100;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        SrcA = 32'b1;
        SrcB = 32'b0;
        ALUControl = 3'b100;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        SrcA = 32'b1;
        SrcB = 32'b1;
        ALUControl = 3'b100;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        // Compliment OR
        SrcA = 32'b0;
        SrcB = 32'b0;
        ALUControl = 3'b101;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        SrcA = 32'b0;
        SrcB = 32'b1;
        ALUControl = 3'b101;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        SrcA = 32'b1;
        SrcB = 32'b0;
        ALUControl = 3'b101;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        SrcA = 32'b1;
        SrcB = 32'b1;
        ALUControl = 3'b101;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        // Subtraction
        SrcA = 32'b1;
        SrcB = 32'b0;
        ALUControl = 3'b110;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        SrcA = 32'b1;
        SrcB = 32'b1;
        ALUControl = 3'b110;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        // Comparison
        SrcA = 32'b1;
        SrcB = 32'b0;
        ALUControl = 3'b111;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        
        SrcA = 32'b0;
        SrcB = 32'b1;
        ALUControl = 3'b111;
        #10;
        $display("SrcA = %b, SrcB = %b, ALUControl = %b, zero = %b, ALUResult = %b", SrcA, SrcB, ALUControl, zero, ALUResult);
        $finish;
    end
endmodule
