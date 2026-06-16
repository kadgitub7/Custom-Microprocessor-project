`timescale 1ns / 1ps

module register_file_tb();
    reg [4:0] addr1,addr2,addr3;
    reg [31:0] WD3;
    reg clk,WE3;
    wire [31:0] RD1,RD2;
    
    register_file uut(.addr1(addr1), .addr2(addr2), .addr3(addr3), .WD3(WD3), .clk(clk), .WE3(WE3), .RD1(RD1), .RD2(RD2));
    
    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        addr1 = 0;
        addr2 = 0;
        addr3 = 0;
        WD3 = 0;
        WE3 = 0;
        #10;
        $display("addr1 = %b, addr2 = %b, addr3 = %b, WD3 = %b, clk = %b, WE3 = %b | RD1 = %b, RD2 = %b", addr1, addr2, addr3, WD3, clk, WE3, RD1, RD2);

        addr1 = 0;
        addr2 = 0;
        addr3 = 5'b00001;
        WD3 = 32'b1;
        WE3 = 1;
        #10;
        $display("addr1 = %b, addr2 = %b, addr3 = %b, WD3 = %b, clk = %b, WE3 = %b | RD1 = %b, RD2 = %b", addr1, addr2, addr3, WD3, clk, WE3, RD1, RD2);
        
        addr1 = 5'b1;
        addr2 = 0;
        addr3 = 0;
        WD3 = 0;
        WE3 = 0;
        #10;
        $display("addr1 = %b, addr2 = %b, addr3 = %b, WD3 = %b, clk = %b, WE3 = %b | RD1 = %b, RD2 = %b", addr1, addr2, addr3, WD3, clk, WE3, RD1, RD2);
        
        addr1 = 0;
        addr2 = 5'b1;
        addr3 = 0;
        WD3 = 0;
        WE3 = 0;
        #10;
        $display("addr1 = %b, addr2 = %b, addr3 = %b, WD3 = %b, clk = %b, WE3 = %b | RD1 = %b, RD2 = %b", addr1, addr2, addr3, WD3, clk, WE3, RD1, RD2);
        
        addr1 = 0;
        addr2 = 0;
        addr3 = 5'b00011;
        WD3 = 32'b111;
        WE3 = 1;
        #10;
        $display("addr1 = %b, addr2 = %b, addr3 = %b, WD3 = %b, clk = %b, WE3 = %b | RD1 = %b, RD2 = %b", addr1, addr2, addr3, WD3, clk, WE3, RD1, RD2);
        
        addr1 = 0;
        addr2 = 0;
        addr3 = 5'b11110;
        WD3 = 32'b1;
        WE3 = 0;
        #10;
        $display("addr1 = %b, addr2 = %b, addr3 = %b, WD3 = %b, clk = %b, WE3 = %b | RD1 = %b, RD2 = %b", addr1, addr2, addr3, WD3, clk, WE3, RD1, RD2);
        
        addr1 = 5'b11110;
        addr2 = 0;
        addr3 = 0;
        WD3 = 0;
        WE3 = 0;
        #10;
        $display("addr1 = %b, addr2 = %b, addr3 = %b, WD3 = %b, clk = %b, WE3 = %b | RD1 = %b, RD2 = %b", addr1, addr2, addr3, WD3, clk, WE3, RD1, RD2);
        
        addr1 = 0;
        addr2 = 5'b11110;
        addr3 = 0;
        WD3 = 0;
        WE3 = 0;
        #10;
        $display("addr1 = %b, addr2 = %b, addr3 = %b, WD3 = %b, clk = %b, WE3 = %b | RD1 = %b, RD2 = %b", addr1, addr2, addr3, WD3, clk, WE3, RD1, RD2);
        
        $finish;
    end
endmodule
