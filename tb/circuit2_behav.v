`timescale 1ns/1ns

module circuit2_behav(a,b,c,z,x,clk,rst);

    input             clk, rst;
    input      [31:0] a, b, c;
    output reg [31:0] z, x;
    wire       [31:0] d, e, f, g, h;
    wire              dLTe, dEQe;
    wire       [31:0] zwire, xwire;

    assign d = a + b;
    assign e = a + c;
    assign f = a - b;
    assign dEQe = d == e;
    assign dLTe = d < e;
    assign g = dLTe ? d : e;
    assign h = dEQe ? g : f;
    assign xwire = g << dLTe;
    assign zwire = h >> dEQe;
    always @(posedge clk) x <= rst ? 0 : xwire;
    always @(posedge clk) z <= rst ? 0 : zwire;

endmodule