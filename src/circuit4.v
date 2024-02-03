`timescale 1ns/1ns

module circuit4(a,b,c,z,x,clk,rst);

    input  clk, rst;
    input  [63:0] a, b, c;

    output [31:0] z, x;

    wire [63:0] d, e, f, g, h;
    wire dLTe, dEQe;
    wire [63:0] dLTe_64, dEQe_64;
    wire [63:0] xrin, zrin;
    wire [63:0] greg, hreg;
    wire [63:0] x_64, z_64;

    assign dLTe_64 = {{63{1'b0}},dLTe};
    assign dEQe_64 = {{63{1'b0}},dEQe};
    assign x = x_64[31:0];
    assign z = z_64[31:0];

    ADD    #(.DATAWIDTH(64)) ADD_1(a, b, d);                // d = a + b    
    ADD    #(.DATAWIDTH(64)) ADD_2(a, c, e);                // e = a + c 
    SUB    #(.DATAWIDTH(64)) ADD_3(a, b, f);                // f = a - b 
    COMP   #(.DATAWIDTH(64)) COMP_1(d, e, , ,dEQe);         // dEQe = d == e
    
    // Using gt output of modified comparator for d < e.
    // This is consistent with comments in sample
    // behavioral netlist.
    COMP   #(.DATAWIDTH(64)) COMP_2(d, e, dLTe, , );        // dLTe = d < e
    MUX2x1 #(.DATAWIDTH(64)) MUX2x1_1(e, d, dLTe, g);       // g = dLTe ? d : e
    MUX2x1 #(.DATAWIDTH(64)) MUX2x1_2(f, g, dEQe, h);       // h = dEQe ? g : f 
    REG    #(.DATAWIDTH(64)) REG_1(greg, g, clk, rst);      // greg = g
    REG    #(.DATAWIDTH(64)) REG_2(hreg, h, clk, rst);      // hreg = h
    SHL    #(.DATAWIDTH(64)) SHL_1(hreg, dLTe_64, xrin);    // xrin = hreg << dLTe
    SHR    #(.DATAWIDTH(64)) SHR_1(greg, dEQe_64, zrin);    // zrin = greg >> dEQe
    REG    #(.DATAWIDTH(64)) REG_3(x_64, xrin, clk, rst);   // x = xrin
    REG    #(.DATAWIDTH(64)) REG_4(z_64, zrin, clk, rst);   // z = zrin

endmodule