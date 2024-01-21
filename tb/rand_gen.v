`timescale 1ns/1ns

module rand_gen(rand_val, clk, rst);

    parameter DATAWIDTH = 32;

    input clk;
    input rst;

    output reg signed [DATAWIDTH-1:0] rand_val;

    always @(posedge clk) begin
        if (rst == 1)
            rand_val <= 0;
        else
            rand_val <= $random;
    end

endmodule