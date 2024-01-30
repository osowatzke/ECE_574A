`timescale 1ns/1ns

module circuit5_behav(a,b,c,d,zero,z,clk,rst);

    input             clk, rst;
    input      [63:0] a, b, c, d, zero;
    output reg [63:0] z;
    wire       [63:0] e, f, g, zwire;
    wire              gEQz;

    assign e = a / b;
    assign f = c / d;
    assign g = a % b;
    assign gEQz = g == zero;
    assign zwire = gEQz ? e : f;
    always @(posedge clk) z <= rst ? 0 : zwire;

endmodule