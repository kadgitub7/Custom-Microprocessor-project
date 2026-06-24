`timescale 1ns / 1ps
module sign_extend_tb();
    reg [15:0] instr;
    wire [31:0] extended_instr;

    sign_extend uut (
        .instr(instr),
        .extended_instr(extended_instr)
    );

    initial begin
        instr = 16'b1010101010101010;
        #10;
        $display("Input: %b, Output: %b", instr, extended_instr);

        instr = 16'b0101010101010;
        #10;
        $display("Input: %b, Output: %b", instr, extended_instr);

        instr = 16'b10101010;
        #10;
        $display("Input: %b, Output: %b", instr, extended_instr);

        instr = 16'b01010;
        #10;
        $display("Input: %b, Output: %b", instr, extended_instr);
        
        $finish;
    end
endmodule
