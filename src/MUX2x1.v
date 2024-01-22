`timescale 1ns/1ns

module MUX2x1(a,b,sel,d);

    parameter DATAWIDTH = 32;
    input unsigned [DATAWIDTH-1:0] a;
    input unsigned [DATAWIDTH-1:0] b;
    input sel;

    output reg unsigned [DATAWIDTH-1:0] d;

    always @(a,b,sel) begin
        if (sel) begin
            d <= a;
        end
        else begin
            d <= b;
        end
    end
endmodule
