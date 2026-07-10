`timescale 1ns / 1ps


module instruction_memory #(
    parameter MEM_FILE = "program.mem"
)(
    input wire [31:0] addr,
    output wire [31:0] RD
    );
    
    reg [31:0] rom [0:63]; //[0:63] represents index from 0 - 63, [31:0] represent size
    
    initial begin
        $readmemh(MEM_FILE, rom);
    end
    
    assign RD = rom[addr[31:2]]; // get the index for shortened addr bit because by dropping the last two bits we can match the index since MIPS has new instruction every byte
endmodule
