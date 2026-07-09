`timescale 1ns / 1ps

module bnn_coprocessor #(
    parameter WIDTH = 32
)(
    input clk,
    input reset,
    input [1:0] op_i,
    input [WIDTH-1:0] data_a_i,
    input [WIDTH-1:0] data_b_i,
    output reg [WIDTH-1:0] acc_o,
    output reg done_o
);

    reg [WIDTH-1:0] acc_reg;
    reg [WIDTH-1:0] xnor_result;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            acc_reg <= {WIDTH{1'b0}};
            done_o <= 1'b0;
        end else begin
            case (op_i)
                2'b00: begin
                    xnor_result = {WIDTH{1'b0}};
                    for (i = 0; i < WIDTH; i = i + 1) begin
                        xnor_result[i] = ~(data_a_i[i] ^ data_b_i[i]);
                    end
                    acc_reg <= xnor_result;
                    done_o <= 1'b1;
                end
                2'b01: begin
                    acc_reg <= acc_reg + data_a_i;
                    done_o <= 1'b1;
                end
                2'b10: begin
                    if (acc_reg >= data_a_i) begin
                        acc_reg <= {WIDTH{1'b1}};
                    end else begin
                        acc_reg <= {WIDTH{1'b0}};
                    end
                    done_o <= 1'b1;
                end
                default: begin
                    acc_reg <= acc_reg;
                    done_o <= 1'b0;
                end
            endcase
        end
    end

    always @(*) begin
        acc_o = acc_reg;
    end
endmodule
