`timescale 1ns / 1ps

module posit_unit_tb;

    reg [7:0] a_i;
    reg [7:0] b_i;
    reg [1:0] op_i;
    wire [7:0] result_o;

    posit_unit #(.WIDTH(8), .ES(2)) uut (
        .a_i(a_i),
        .b_i(b_i),
        .op_i(op_i),
        .result_o(result_o)
    );

    initial begin
        $display("Starting posit unit testbench");

        a_i = 8'h05;
        b_i = 8'h03;
        op_i = 2'b00;
        #10;
        $display("Case 1: add -> result=%h", result_o);

        a_i = 8'h05;
        b_i = 8'h03;
        op_i = 2'b01;
        #10;
        $display("Case 2: mul -> result=%h", result_o);

        a_i = 8'h00;
        b_i = 8'h03;
        op_i = 2'b00;
        #10;
        $display("Case 3: zero input -> result=%h", result_o);

        $display("Finished posit unit testbench");
        $finish;
    end

endmodule
