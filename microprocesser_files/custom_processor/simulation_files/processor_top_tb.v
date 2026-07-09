`timescale 1ns / 1ps

module processor_top_tb;

    reg clk;
    reg reset_PC;

    processor_top uut(
        .clk(clk),
        .reset_PC(reset_PC)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset_PC = 1;
        #20;
        reset_PC = 0;
        
        // Run for enough cycles to execute program
        #500;
        
        $display("===== SIMULATION COMPLETE =====");
        $display("Final register state:");
        $display("R0 (zero) = %d", uut.regfile.register_storage[0]);
        $display("R2 (v0)   = %d", uut.regfile.register_storage[2]);
        $display("R3 (v1)   = %d", uut.regfile.register_storage[3]);
        $display("R4 (a0)   = %d", uut.regfile.register_storage[4]);
        $display("R5 (a1)   = %d", uut.regfile.register_storage[5]);
        $display("R6 (a2)   = %d", uut.regfile.register_storage[6]);
        $display("R7 (a3)   = %d", uut.regfile.register_storage[7]);
        
        $finish;
    end
endmodule
