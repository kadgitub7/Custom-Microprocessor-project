`timescale 1ns / 1ps

module instruction_memory_tb();

    reg [31:0] addr;
    wire [31:0] RD;
    
    instruction_memory uut(.addr(addr), .RD(RD));
    
    initial begin
        addr = 32'b0;
        #10;
        $display("addr = %b | RD = %h", addr, RD);
        
        addr = 32'b0100;
        #10;
        $display("addr = %b | RD = %h", addr, RD);
        
        addr = 32'b1000;
        #10;
        $display("addr = %b | RD = %h", addr, RD);
    end
endmodule
