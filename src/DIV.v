module DIV(a, b, qout);
    
    parameter DATAWIDTH = 32;
    
    input      [DATAWIDTH-1:0] a;
    input      [DATAWIDTH-1:0] b;
    output reg [DATAWIDTH-1:0] qout;
    
    reg        [DATAWIDTH-1:0] shiftVar
    reg        [DATAWIDTH-1:0] remVar;
    
    integer i;
    always @(a,b) begin
        for (i = 0; i < DATAWIDTH; ++i) begin
            shiftVar = (b >> i);
            if (a >= shiftVar) begin
                qout[i] <= 1;                
                remVar = a - shiftVar;
            end
        end
    end
endmodule