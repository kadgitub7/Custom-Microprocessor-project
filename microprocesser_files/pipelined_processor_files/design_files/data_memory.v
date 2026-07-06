`timescale 1ns / 1ps

module data_memory(
    input wire [9:0] addr,
    input wire [31:0] WD,
    input clk, WE,
    output wire [31:0] RD
    );
    
    reg [31:0] SRAM [0:1023];
    
    always @(posedge clk) begin
        if(WE == 1'b1) begin
            SRAM[addr] <= WD;
        end
    end
    
    assign RD = SRAM[addr];
    
endmodule
