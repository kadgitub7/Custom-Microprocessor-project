`timescale 1ns / 1ps

module bnn_coprocessor_tb;

    reg clk;
    reg reset;
    reg [1:0] op_i;
    reg [31:0] data_a_i;
    reg [31:0] data_b_i;
    wire [31:0] acc_o;
    wire done_o;

    bnn_coprocessor #(.WIDTH(32)) uut (
        .clk(clk),
        .reset(reset),
        .op_i(op_i),
        .data_a_i(data_a_i),
        .data_b_i(data_b_i),
        .acc_o(acc_o),
        .done_o(done_o)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        op_i = 2'b00;
        data_a_i = 32'b1010_0000_0000_0000_0000_0000_0000_0000;
        data_b_i = 32'b1001_0000_0000_0000_0000_0000_0000_0000;
        #10;
        reset = 0;
        #10;
        $display("XNOR op acc=%b done=%b", acc_o, done_o);

        op_i = 2'b01;
        data_a_i = 32'd5;
        #10;
        $display("ACCUM op acc=%d done=%b", acc_o, done_o);

        op_i = 2'b10;
        data_a_i = 32'd3;
        #10;
        $display("ACTIVATE op acc=%b done=%b", acc_o, done_o);

        $finish;
    end
endmodule
