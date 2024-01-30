`timescale 1ns/1ns

module circuit6_behav(a,b,c,zero,z,clk,rst);
    
    input             clk, rst;
    input      [63:0] a, b, c, zero;
    output reg [63:0] z;
    wire       [63:0] e, f, g, zwire;
    wire              gEQz;
    
    assign e = a - 1;
    assign f = c + 1;
    assign g = a % c;
    assign gEQz = g == zero;
    assign zwire = gEQz ? e : f;
    always @(posedge clk) z = rst ? 0 : zwire;
    
endmodule 