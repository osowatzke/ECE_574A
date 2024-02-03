`timescale 1ns / 1ns

module circuit6(a, b, c, zero, z, clk, rst);

        input  clk, rst;
        input  [63:0] a, b, c, zero;
        
        output [63:0] z;
        
        wire   [63:0] e, f, g, zwire;
        wire   gEQz;
        
        DEC    #(.DATAWIDTH(64)) DEC_1(a, e);                 // e = a - 1
        INC    #(.DATAWIDTH(64)) INC_1(c, f);                 // f = c + 1
        MOD    #(.DATAWIDTH(64)) MOD_1(a, c, g);              // g = a % c
        COMP   #(.DATAWIDTH(64)) COMP_1(g, zero, , ,gEQz);    // gEQz = g == zero
        MUX2x1 #(.DATAWIDTH(64)) MUX2x1_1(f, e, gEQz, zwire); // zwire = gEQz ? e : f
        REG    #(.DATAWIDTH(64)) REG_1(z, zwire, clk, rst);   // z = zwire
        
endmodule
