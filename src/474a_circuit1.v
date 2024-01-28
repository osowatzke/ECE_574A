`timescale 1ns / 1ns
module circuit1(a, b, c, z, x, clk, rst);

        input clk, rst;
        input [7:0] a, b, c;
        
        output [7:0] z;
        output [15:0] x;
        
        wire g;
        wire [7:0] d, e;
        wire [15:0] f;
        wire [15:0] xwire;
        wire [15:0] a_16, c_16, d_16;
        
        ADD #(.DATAWIDTH(8)) ADD_1(a, b, d); // d = a + b
        ADD #(.DATAWIDTH(8)) ADD_2(a, c, e); // e = a + c
        COMP #(.DATAWIDTH(8)) COMP_1(d,e,g,,); // g = d > e
        MUX2x1 #(.DATAWIDTH(8)) MUX2x1_1(e,d,g,z); // z = g ? d : e
        assign a_16 = {{8{1'b0}}, a};
        assign c_16 = {{8{1'b0}}, c};
        MUL #(.DATAWIDTH(16)) MUL_1(a_16, c_16, f); // f = a * c
        assign d_16 = {{8{1'b0}}, d};
        SUB #(.DATAWIDTH(16)) SUB_1(f, d_16, xwire); // xwire = f - d
        REG #(.DATAWIDTH(16)) REG_0(x, xwire, clk, rst); // x = xwire
        
endmodule
