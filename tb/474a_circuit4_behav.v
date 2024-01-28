`timescale 1ns/1ns

module circuit4_behav(a,b,c,z,x,clk,rst);
    
    input             clk, rst;
    input      [63:0] a, b, c;
    output reg [31:0] z, x;
    wire       [63:0] d, e, f, g, h;
    wire              dLTe, dEQe;
    wire       [63:0] xrin, zrin;
    reg        [63:0] greg, hreg;
    
    assign d = a + b;
    assign e = a + c;
    assign f = a - b;
    assign dEQe = d == e;
    assign dLTe = d < e;
    assign g = dLTe ? d : e;
    assign h = dEQe ? g : f;
    always @(posedge clk) greg <= rst ? 0 : g;
    always @(posedge clk) hreg <= rst ? 0 : h;
    assign xrin = hreg << dLTe;
    assign zrin = greg >> dEQe;
    always @(posedge clk) x <= rst ? 0 : xrin[31:0];
    always @(posedge clk) z <= rst ? 0 : zrin[31:0];
endmodule 