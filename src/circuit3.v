`timescale 1ns / 1ns

module circuit3(a, b, c, d, e, f, g, h, sa, avg, clk, rst);
    
    input  clk, rst;
    input  [7:0] sa;
    input  [15:0] a, b, c, d, e, f, g, h;

    output [15:0] avg;

    wire   [31:0] l00, l01, l02, l03, l10, l11, l2, l2div2, l2div4, l2div8;
    wire   [31:0] sa_32, avg_32; 

    wire   [15:0] l00_16, l01_16, l02_16, l03_16; 

    assign l00 = {{16{1'b0}}, l00_16};
    assign l01 = {{16{1'b0}}, l01_16};
    assign l02 = {{16{1'b0}}, l02_16};
    assign l03 = {{16{1'b0}}, l03_16};
    assign sa_32 = {{24{1'b0}}, sa};
    assign avg = avg_32[15:0];

    // Making adder width equal to the maximum width of
    // the inputs without considering the output width.
    // This is consistent with the assignment description,
    // but produces results inconsistent with the verilog
    // implementation for ADD_1, ADD_2, ADD_3, ADD_4.
    // Discussed this with Dr. Tosi, and he confirmed
    // that this was the implementation that he wanted.
    ADD    #(.DATAWIDTH(16)) ADD_1(a, b, l00_16);                     // l00 = a + b
    ADD    #(.DATAWIDTH(16)) ADD_2(c, d, l01_16);                     // l01 = c + d
    ADD    #(.DATAWIDTH(16)) ADD_3(e, f, l02_16);                     // l02 = e + f
    ADD    #(.DATAWIDTH(16)) ADD_4(g, h, l03_16);                     // l03 = g + h
    ADD    #(.DATAWIDTH(32)) ADD_5(l00, l01, l10);                    // l10 = l00 + l01
    ADD    #(.DATAWIDTH(32)) ADD_6(l02, l03, l11);                    // l11 = l02 + l03
    ADD    #(.DATAWIDTH(32)) ADD_7(l10, l11, l2);                     // l2 = l10 + l11
    SHR    #(.DATAWIDTH(32)) SHR_1(l2, sa_32, l2div2);                // l2div2 = l2 >> sa
    SHR    #(.DATAWIDTH(32)) SHR_2(l2div2, sa_32, l2div4);            // l2div4 = l2div2 >> sa
    SHR    #(.DATAWIDTH(32)) SHR_3(l2div4, sa_32, l2div8);            // l2div8 = l2div4 >> sa
    REG    #(.DATAWIDTH(32)) REG_1(avg_32, l2div8, clk, rst);         // avg = l2div8

endmodule