`timescale 1ns / 1ns
module circuit6(a, b, c, zero, z);
        input [63:0] a, b, c, zero;
        
        output [63:0] z;
        
        wire [63:0] e, f, g, zwire;
        wire gEQz;
        
        SUB #(.DATAWIDTH(64)) SUB_1(a, 1, e); // e = a - 1
        ADD #(.DATAWIDTH(64)) ADD_1(c, 1, f); // f = c + 1
        MOD #(.DATAWIDTH(64)) MOD_1(a,c,g); // g = a % c
        COMP #(.DATAWIDTH(64)) COMP_1(g,zero,,,gEQz); // gEQz = g == zero
        MUX2x1 #(.DATAWIDTH(64)) MUX2x1_1(f,e,gEQz,zwire); // zwire = gEQz ? e : f
        ADD #(.DATAWIDTH(64)) ADD_2(zwire, 0, z); // z = zwire
        
endmodule
