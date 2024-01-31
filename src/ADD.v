`timescale 1ns/1ns

module ADD #(parameter DATAWIDTH = 32)(a, b, sum);

    input [DATAWIDTH-1:0] a;
    input [DATAWIDTH-1:0] b;

    output reg [DATAWIDTH-1:0] sum;

    always @(a,b) begin
        sum <= a+b;
    end
endmodule
