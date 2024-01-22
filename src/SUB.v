`timescale 1ns/1ns

module SUB(a,b,diff);

    parameter DATAWIDTH = 32;
    input unsigned [DATAWIDTH-1:0] a;
    input unsigned [DATAWIDTH-1:0] b;

    output reg unsigned [DATAWIDTH-1:0] diff;

    always @(a,b) begin
        diff <= a-b;
    end
endmodule
