`timescale 1ns / 1ps

module data_memory_tb();
    reg [9:0] addr;
    reg [31:0] WD;
    reg clk, WE;
    wire [31:0] RD;
    
    data_memory uut(.addr(addr), .WD(WD), .clk(clk), .WE(WE), .RD(RD));
    
    always begin
        #5 clk = ~clk;
    end
    
    initial begin
        clk = 0;
        addr = 0;
        WD = 0;
        WE = 0;
        #10;
        $display("addr = %b, WD = %b, WE = %b, RD = %b", addr, WD, WE, RD);
        #8;

        addr = 10'b1;
        WD = 32'b11;
        WE = 1;
        #2;
        $display("addr = %b, WD = %b, WE = %b, RD = %b", addr, WD, WE, RD);
        #8;

        addr = 10'b1;
        WD = 0;
        WE = 0;
        #2;
        $display("addr = %b, WD = %b, WE = %b, RD = %b", addr, WD, WE, RD);
        #8;

        addr = 10'b11;
        WD = 32'b01;
        WE = 1;
        #2;
        $display("addr = %b, WD = %b, WE = %b, RD = %b", addr, WD, WE, RD);
        #8;

        addr = 10'b11;
        WD = 0;
        WE = 0;
        #2;
        $display("addr = %b, WD = %b, WE = %b, RD = %b", addr, WD, WE, RD);
        #8;
        $finish;
    end
    
endmodule
