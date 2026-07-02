module PC_reg(
    input clk,
    input reset,
    input PC_write,
    input [31:0] D,
    output reg [31:0] Q,
    output reg [31:0] Q_not
);
    always @(posedge clk) begin
        if (reset) begin
            Q     <= 32'b0;
            Q_not <= {32{1'b1}}; //32 1's
        end else if (PC_write) begin
            Q     <= D;
            Q_not <= ~D;
        end
    end
endmodule