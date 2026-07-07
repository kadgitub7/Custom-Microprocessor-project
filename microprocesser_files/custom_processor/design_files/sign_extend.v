`timescale 1ns / 1ps

module sign_extend(
    input [15:0] instr,
    output [31:0] extended_instr
);
    // copy the last bit by 16 and append it before the actual instruction to make it 32 bits
    assign extended_instr = {{16{instr[15]}} , instr};
endmodule
