`timescale 1ns / 1ps

module alu_integrity_checker_tb;

    reg [31:0] alu_result_i;
    reg [31:0] posit_result_i;
    reg use_posit_i;
    wire [31:0] checked_result_o;
    wire fault_o;
    wire parity_bit_o;

    alu_integrity_checker #(.WIDTH(32)) uut (
        .alu_result_i(alu_result_i),
        .posit_result_i(posit_result_i),
        .use_posit_i(use_posit_i),
        .checked_result_o(checked_result_o),
        .fault_o(fault_o),
        .parity_bit_o(parity_bit_o)
    );

    initial begin
        $display("Starting alu integrity checker testbench");

        alu_result_i = 32'h00000005;
        posit_result_i = 32'h00000005;
        use_posit_i = 0;
        #10;
        $display("Case 1: normal ALU path -> result=%0d fault=%b parity=%b", checked_result_o, fault_o, parity_bit_o);

        alu_result_i = 32'h00000005;
        posit_result_i = 32'h00000007;
        use_posit_i = 1;
        #10;
        $display("Case 2: posit path mismatch -> result=%0d fault=%b parity=%b", checked_result_o, fault_o, parity_bit_o);

        alu_result_i = 32'h0000000A;
        posit_result_i = 32'h0000000A;
        use_posit_i = 1;
        #10;
        $display("Case 3: posit path match -> result=%0d fault=%b parity=%b", checked_result_o, fault_o, parity_bit_o);

        $display("Finished alu integrity checker testbench");
        $finish;
    end

endmodule
