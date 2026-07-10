`timescale 1ns / 1ps

module alu_integrity_checker #(
    parameter WIDTH = 32
)(
    input [WIDTH-1:0] alu_result_i,
    input [WIDTH-1:0] posit_result_i,
    input use_posit_i,
    output reg [WIDTH-1:0] checked_result_o,
    output reg fault_o,
    output reg parity_bit_o
);

    wire parity_alu;
    wire parity_posit;

    assign parity_alu = alu_result_i[0] ^ alu_result_i[1] ^ alu_result_i[2] ^ alu_result_i[3] ^
                        alu_result_i[4] ^ alu_result_i[5] ^ alu_result_i[6] ^ alu_result_i[7] ^
                        alu_result_i[8] ^ alu_result_i[9] ^ alu_result_i[10] ^ alu_result_i[11] ^
                        alu_result_i[12] ^ alu_result_i[13] ^ alu_result_i[14] ^ alu_result_i[15] ^
                        alu_result_i[16] ^ alu_result_i[17] ^ alu_result_i[18] ^ alu_result_i[19] ^
                        alu_result_i[20] ^ alu_result_i[21] ^ alu_result_i[22] ^ alu_result_i[23] ^
                        alu_result_i[24] ^ alu_result_i[25] ^ alu_result_i[26] ^ alu_result_i[27] ^
                        alu_result_i[28] ^ alu_result_i[29] ^ alu_result_i[30] ^ alu_result_i[31];

    assign parity_posit = posit_result_i[0] ^ posit_result_i[1] ^ posit_result_i[2] ^ posit_result_i[3] ^
                          posit_result_i[4] ^ posit_result_i[5] ^ posit_result_i[6] ^ posit_result_i[7] ^
                          posit_result_i[8] ^ posit_result_i[9] ^ posit_result_i[10] ^ posit_result_i[11] ^
                          posit_result_i[12] ^ posit_result_i[13] ^ posit_result_i[14] ^ posit_result_i[15] ^
                          posit_result_i[16] ^ posit_result_i[17] ^ posit_result_i[18] ^ posit_result_i[19] ^
                          posit_result_i[20] ^ posit_result_i[21] ^ posit_result_i[22] ^ posit_result_i[23] ^
                          posit_result_i[24] ^ posit_result_i[25] ^ posit_result_i[26] ^ posit_result_i[27] ^
                          posit_result_i[28] ^ posit_result_i[29] ^ posit_result_i[30] ^ posit_result_i[31];

    always @(*) begin
        if (use_posit_i) begin
            checked_result_o = posit_result_i;
            parity_bit_o = parity_posit;
            fault_o = (parity_alu != parity_posit);
        end else begin
            checked_result_o = alu_result_i;
            parity_bit_o = parity_alu;
            fault_o = 1'b0;
        end
    end
endmodule
