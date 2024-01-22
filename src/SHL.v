`timescale 1ns/1ns

module SHL(a,sh_amt,d);

    parameter DATAWIDTH = 32;
    input unsigned [DATAWIDTH-1:0] a;
    input sh_amt;

    output reg unsigned [DATAWIDTH-1:0] d;

    always @(a,b) begin
        d <= a << sh_amt;
    end
endmodule
