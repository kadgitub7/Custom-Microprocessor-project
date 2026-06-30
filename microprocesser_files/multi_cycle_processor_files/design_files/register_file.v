`timescale 1ns / 1ps

module register_file(
    input wire [4:0] addr1,addr2,addr3,
    input wire [31:0] WD3,
    input clk,WE3,
    output reg [31:0] RD1,RD2
    );
    // 32 x 32 bit register storage
    reg [31:0] register_storage [0:31];
    
    // initialize all values to 0 to start
    integer i;
    initial begin
        for(i = 0;i<32;i=i+1) begin
            register_storage[i] = 32'b0;
        end
    end
    
    // if there is a positive edge of clock and write enable as well as the address is not 0 we write the data to the array index at the location we want
    always @(posedge clk) begin
        if(WE3 && addr3 != 5'b0) begin
            register_storage[addr3] <= WD3;
        end
    end
    
    // combinationally read the value at the address index in the register storage
    always @(*) begin
        RD1 = register_storage[addr1];
        RD2 = register_storage[addr2];
    end
    
endmodule
