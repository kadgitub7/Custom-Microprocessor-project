module if_id_reg(
    input clk,
    input reset,
    input en,
    input flush,

    input [31:0] InstrF,
    input [31:0] PCPlus4F,

    output reg [31:0] InstrD,
    output reg [31:0] PCPlus4D
);

always @(posedge clk)
begin
    if (reset) begin
        InstrD <= 32'b0;
        PCPlus4D <= 32'b0;
    end else if (flush) begin
        InstrD <= 32'b0;
        PCPlus4D <= 32'b0;
    end else if (en) begin
        InstrD <= InstrF;
        PCPlus4D <= PCPlus4F;
    end
end

endmodule
