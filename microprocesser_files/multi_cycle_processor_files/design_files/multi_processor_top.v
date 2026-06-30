module multi_processor_top(
    input clk

);
    wire reset_PC;
    wire [31:0] PC_D;
    wire [31:0] PC_Q;
    wire [31:0] PC_Q_not;

    wire [31:0] WD;
    wire WE;
    wire [31:0] RD;

    wire [31:0] RD1;

    wire IRWrite;

    reg [31:0] instruction_storage_imm;
    reg [31:0] A;

    PC_reg PC(.clk(clk), .reset(reset_PC), .D(PC_D), .Q(PC_Q), .Q_not(PC_Q_not));
    data_memory DM(.addr(PC_Q[9:0]), .WD(WD), .clk(clk), .WE(WE), .RD(RD));
    register_file regfile(.clk(clk), .WE3(WE), .addr1(instruction_storage_imm[25:21]), .addr2(instruction_storage_imm[20:16]), .addr3(instruction_storage_imm[15:11]), .WD3(WD), .RD1(RD), .RD2(RD));

    always @(posedge clk) begin
        if(IRWrite) begin
            instruction_storage_imm <= RD;
        end
        A <= RD1;
    end


endmodule