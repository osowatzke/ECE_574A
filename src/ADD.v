`timescale 1ns/1ns

module ADD(a,b,sum);

    parameter DATAWIDTH = 32;
    input unsigned [DATAWIDTH-1:0] a;
    input unsigned [DATAWIDTH-1:0] b;

    output reg unsigned [DATAWIDTH-1:0] sum;

    always @(a,b) begin
        sum <= a+b;
    end
endmodule
