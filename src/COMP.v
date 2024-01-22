`timescale 1ns/1ns

module COMP(a,b,gt,lt,eq);

    parameter DATAWIDTH = 32;
    input unsigned [DATAWIDTH-1:0] a;
    input unsigned [DATAWIDTH-1:0] b;

    output gt,lt,eq;

    always @(a,b) begin
        gt <= 0; lt <= 0; eq <= 0;
        
        if (a>b) begin
            gt <= 1;
        end
        else if (a<b) begin
            lt <= 1;
        end
        else begin
            eq <= 1;
        end
    end
endmodule
