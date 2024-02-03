`timescale 1ns / 1ns

module circuit2(a, b, c, z, x, clk, rst);

    input  clk, rst;
    input  [31:0] a, b, c;
    output [31:0] z, x;
    wire   [31:0] d, e, f, g, h, xwire, zwire;
    wire   dLTe, dEQe;
    wire   dLTe_32, dEQe_32;
    
    assign dLTe_32 = {{31{1'b0}},dLTe};
    assign dEQe_32 = {{31{1'b0}},dEQe};

    ADD    #(.DATAWIDTH(32)) ADD_1(a, b, d);        // d = a + b
    ADD    #(.DATAWIDTH(32)) ADD_2(a, c, e);        // e = a + c
    SUB    #(.DATAWIDTH(32)) SUB_1(a, b, f);        // f = a - b
    COMP   #(.DATAWIDTH(32)) COMP_1(d, e, , dLTe, dEQe); // dLTe = d < e, dEQe = d == e
    MUX2x1 #(.DATAWIDTH(32)) MUX2x1_1(d, e, dLTe, g); // g = dLTe ? d : e
    MUX2x1 #(.DATAWIDTH(32)) MUX2x1_2(g, f, dEQe, h); // h = dEQe ? g : f
    SHL    #(.DATAWIDTH(32)) SHL_1(g, dLTe_32, xwire);  // xwire = g << dLTe
    SHR    #(.DATAWIDTH(32)) SHR_1(h, dEQe_32, zwire);  // zwire = h >> dEQe
    REG    #(.DATAWIDTH(32)) REG_x(x, xwire, clk, rst); // x = xwire
    REG    #(.DATAWIDTH(32)) REG_z(z, zwire, clk, rst); // z = zwire

endmodule