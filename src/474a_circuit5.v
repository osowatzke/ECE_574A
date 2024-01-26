`timescale 1ns / 1ns
module circuit5(a, b, c, d, zero, z);
        input [63:0] a, b, c, d, zero;
        
        output [63:0] z;
        
        wire [63:0] e, f, g, zwire;
        wire gEQz;
        
        DIV #(.DATAWIDTH(64)) DIV_1(a, b, e); // e = a / b
        DIV #(.DATAWIDTH(64)) DIV_2(c, d, f); // f = c / d
        MOD #(.DATAWIDTH(64)) MOD_1(a,b,g); // g = a % b
        COMP #(.DATAWIDTH(64)) COMP_1(g,zero,,,gEQz); // gEQz = g == zero
        MUX2x1 #(.DATAWIDTH(64)) MUX2x1_1(f,e,gEQz,zwire); // zwire = gEQz ? e : f
        ADD #(.DATAWIDTH(64)) ADD_1(zwire, 0, z); // z = zwire
        
endmodule
