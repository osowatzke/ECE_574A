`timescale 1ns/1ns

module MOD(a, b, rem);

    parameter DATAWIDTH = 32;

    input signed [DATAWIDTH-1:0] a;
    input signed [DATAWIDTH-1:0] b;
    
    output reg signed [DATAWIDTH-1:0] rem;
    
    always @(a,b) begin
        rem <= a % b;
    end
endmodule