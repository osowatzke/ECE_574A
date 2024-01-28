`timescale 1ns/1ns

module circuit1_behav(a,b,c,z,x,clk,rst);
    
    input             clk, rst;
    input      [ 7:0] a, b, c;
    output     [ 7:0] z;
    output reg [15:0] x;
    wire       [ 7:0] d, e;
    wire       [15:0] f, g;
    wire       [15:0] xwire;
    
    assign d = a + b;
    assign e = a + c;
    assign g = d > e;
    assign z = g ? d : e;
    assign f = a * c;
    assign xwire = f - d;
    always @(posedge clk) x = xwire;
    
endmodule 