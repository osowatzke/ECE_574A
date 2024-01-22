`timescale 1ns/1ns

module MUL(a,b,prod);

    parameter DATAWIDTH = 32;
    input signed [DATAWIDTH-1:0] a;
    input signed [DATAWIDTH-1:0] b;

    output reg signed [DATAWIDTH-1:0] prod;

    always @(a,b) begin
        prod <= a*b;
    end
endmodule