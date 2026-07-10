module posit_mul #(
    parameter WIDTH = 8,
    parameter ES = 2
) (
    input [WIDTH-1:0] a_i,
    input [WIDTH-1:0] b_i,
    output wire [WIDTH-1:0] result_o
);

    wire signed [31:0] a_val;
    wire signed [31:0] b_val;
    reg signed [31:0] prod_val;

    posit_decoder #(.WIDTH(WIDTH), .ES(ES)) u_dec_a (
        .posit_i(a_i),
        .value_o(a_val)
    );

    posit_decoder #(.WIDTH(WIDTH), .ES(ES)) u_dec_b (
        .posit_i(b_i),
        .value_o(b_val)
    );

    posit_encoder #(.WIDTH(WIDTH), .ES(ES)) u_enc (
        .value_i(prod_val),
        .posit_o(result_o)
    );

    always @(*) begin
        prod_val = a_val * b_val;
    end
endmodule
