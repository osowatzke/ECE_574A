`timescale 1ns / 1ps
module circuit1(a, b, c, z, x);
        input [7:0] a, b, c;
        
        output [7:0] z;
        output [15:0] x;
        
        wire [7:0] d, e;
        wire [15:0] f, g;
        wire [15:0] xwire;
        
        ADD #(.DATAWIDTH(8)) ADD_1(a, b, d); // d = a + b
        ADD #(.DATAWIDTH(8)) ADD_2(a, c, e); // e = a + c
        COMP #(.DATAWIDTH(8)) COMP_1(d,e,gt,,); // g = d > e
        MUX2x1 #(.DATAWIDTH(8)) MUX2x1_1(e,d,g,z); // z = g ? d : e
        MUL #(.DATAWIDTH(16)) MUL_1(a, c, f); // f = a * c
        SUB #(.DATAWIDTH(16)) SUB_1(f, d, xwire); // xwire = f - d
        ADD #(.DATAWIDTH(16)) ADD_3(x, 0, xwire); // x = xwire
        
endmodule
