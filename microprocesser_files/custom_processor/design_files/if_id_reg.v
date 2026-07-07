module if_id_reg(
    input clk,

    input [31:0] InstrF,
    input [31:0] PCPlus4F,

    output reg [31:0] InstrD,
    output reg [31:0] PCPlus4D
);

always @(posedge clk)
begin
    InstrD <= InstrF;
    PCPlus4D <= PCPlus4F;
end

endmodule
