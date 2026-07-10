module posit_unit #(
    parameter WIDTH = 8,
    parameter ES = 2
) (
    input [WIDTH-1:0] a_i,
    input [WIDTH-1:0] b_i,
    input [1:0] op_i,
    output [WIDTH-1:0] result_o
);

    wire [WIDTH-1:0] addsub_result;
    wire [WIDTH-1:0] mul_result;

    posit_addsub #(.WIDTH(WIDTH), .ES(ES)) u_addsub (
        .a_i(a_i),
        .b_i(b_i),
        .addsub_i(op_i[0]),
        .result_o(addsub_result)
    );

    posit_mul #(.WIDTH(WIDTH), .ES(ES)) u_mul (
        .a_i(a_i),
        .b_i(b_i),
        .result_o(mul_result)
    );

    assign result_o = (op_i == 2'b00) ? addsub_result : mul_result;
endmodule
