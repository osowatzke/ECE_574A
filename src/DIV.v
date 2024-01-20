module DIV(a, b, qout);
    
    parameter DATAWIDTH = 32;
    
    input signed      [DATAWIDTH-1:0] a;
    input signed      [DATAWIDTH-1:0] b;
    output reg signed [DATAWIDTH-1:0] qout;
    
    reg qSignVar;
    
    reg [DATAWIDTH-1:0] aMagVar;
    reg [DATAWIDTH-1:0] bMagVar;
    reg [DATAWIDTH-1:0] qMagVar;
    
    reg [2*DATAWIDTH-2:0] shiftVar;
    reg [2*DATAWIDTH-2:0] remVar;
    
    integer i;
    always @(a,b) begin
        if (b == 0) begin
            if (a == 0)
                qout <= 1;
            else if (a > 0)
                qout <= {1'b0, {(DATAWIDTH-1){1'b1}}}; 
            else
                qout <= {1'b1, {(DATAWIDTH-1){1'b0}}};
        end
        else begin
            qSignVar  = a[DATAWIDTH-1] ^ b[DATAWIDTH-1];
            if (a > 0)
                aMagVar = $unsigned(a);
            else
                aMagVar = $unsigned(-a);
            if (b > 0)
                bMagVar = $unsigned(b);
            else
                bMagVar = $unsigned(-b);
            remVar      = {{(DATAWIDTH-1){1'b0}}, aMagVar};
            shiftVar    = {bMagVar, {(DATAWIDTH-1){1'b0}}};
            qMagVar     = 0;
            for ( i = DATAWIDTH - 1; i >= 0; i = i - 1 ) begin
                if (remVar >= shiftVar) begin
                    qMagVar[i] = 1;                
                    remVar     = remVar - shiftVar;
                end
                shiftVar       = (shiftVar >> 1);
            end
            if (qSignVar == 1)
                qout     <= -$signed(qMagVar);
            else begin
                if (qMagVar[DATAWIDTH-1] > 0)
                    qout <= {1'b0, {(DATAWIDTH-1){1'b1}}}; 
                else
                    qout <= $signed(qMagVar);
            end
        end
    end
endmodule