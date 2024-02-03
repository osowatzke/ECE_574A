`timescale 1ns/1ns

module circuit3_behav(a,b,c,d,e,f,g,h,sa,avg,clk,rst);

    input             clk, rst;
    input      [15:0] a, b, c, d, e, f, g, h;
    input      [ 7:0] sa;
    output reg [15:0] avg;
    
    wire       [15:0] l00, l01, l02, l03; // Only assigning 16 bits of sum to register
    wire       [31:0] l10, l11, l2, l2div2, l2div4, l2div8;

    assign l00 = a + b;
    assign l01 = c + d;
    assign l02 = e + f;
    assign l03 = g + h;
    assign l10 = l00 + l01;
    assign l11 = l02 + l03;
    assign l2 = l10 + l11;
    assign l2div2 = l2 >> sa;
    assign l2div4 = l2div2 >> sa;
    assign l2div8 = l2div4 >> sa;
    always @(posedge clk) avg <= rst ? 0 : l2div8[15:0];

endmodule