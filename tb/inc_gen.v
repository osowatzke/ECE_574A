`timescale 1ns/1ns

module inc_gen(val, clk, rst);

    parameter DATAWIDTH = 32;
    
    input clk;
    input rst;
    
    output reg signed [DATAWIDTH-1:0] val;
    
    always @(posedge clk) begin
        if (rst == 1)
            val <= 0;
        else
            val <= val + 1'b1;
    end
    
endmodule