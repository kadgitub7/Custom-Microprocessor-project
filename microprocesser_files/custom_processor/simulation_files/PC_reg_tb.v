`timescale 1ns / 1ps

module PC_reg_tb();
    reg clk;
    reg reset;
    reg [31:0] D;
    wire [31:0] Q;
    wire [31:0] Q_not;
    
    PC_reg uut(.clk(clk), .reset(reset), .en(1'b1), .D(D), .Q(Q), .Q_not(Q_not));
    
    initial begin
        clk = 0;
        reset = 1;
        D = 0;
        #12;
        
        clk = 1;
        reset = 0;
        D = 0;
        #10;
        $display("clk = %b, reset = %b, D = %b, Q = %b, Q_not = %d", clk, reset, D, Q, Q_not);
        
        clk = 1;
        D = 32'b1;
        #10;
        $display("clk = %b, reset = %b, D = %b, Q = %b, Q_not = %d", clk, reset, D, Q, Q_not);
        
        clk = 0;
        D = 0;
        #10;
        $display("clk = %b, reset = %b, D = %b, Q = %b, Q_not = %d", clk, reset, D, Q, Q_not);
        
        clk = 1;
        D = 32'b1;
        #10;
        $display("clk = %b, reset = %b, D = %b, Q = %b, Q_not = %d", clk, reset, D, Q, Q_not);
        
        clk = 0;
        D = 32'b0;
        #10;
        $display("clk = %b, reset = %b, D = %b, Q = %b, Q_not = %d", clk, reset, D, Q, Q_not);
        
        clk = 1;
        D = 32'b11111;
        #10;
        $display("clk = %b, reset = %b, D = %b, Q = %b, Q_not = %d", clk, reset, D, Q, Q_not);
    end
endmodule
