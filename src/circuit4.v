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

    ADD    #(.DATAWIDTH(64)) ADD_0(a, b, d);
    ADD    #(.DATAWIDTH(64)) ADD_1(a, c, e);
    SUB    #(.DATAWIDTH(64)) ADD_2(a, b, f);
    COMP   #(.DATAWIDTH(64)) COMP_0(d, e, , ,dEQe);
    COMP   #(.DATAWIDTH(64)) COMP_1(d, e, ,dLTe, );
    MUX2x1 #(.DATAWIDTH(64)) MUX2x1_0(e, d, dLTe, g);
    MUX2x1 #(.DATAWIDTH(64)) MUX2x1_1(f, g, dEQe, h);
    REG    #(.DATAWIDTH(64)) REG_0(greg, g, clk, rst);
    REG    #(.DATAWIDTH(64)) REG_1(hreg, h, clk, rst);
    SHL    #(.DATAWIDTH(64)) SHL_0(hreg, dLTe_64, xrin);
    SHR    #(.DATAWIDTH(64)) SHR_0(greg, dEQe_64, zrin);
    REG    #(.DATAWIDTH(64)) REG_2(x_64, xrin, clk, rst);
    REG    #(.DATAWIDTH(64)) REG_3(z_64, zrin, clk, rst);

endmodule