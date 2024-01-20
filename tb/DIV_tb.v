`timescale 1ns/1ns

module DIV_tb();

    localparam RNG_SEED   = 0;
    localparam DATAWIDTH  = 32;
    localparam RESET_TIME = 100;
    localparam CLK_PERIOD = 10;

    reg clk;
    reg rst;
    reg err;
    
    reg signed  [DATAWIDTH-1:0] a;
    reg signed  [DATAWIDTH-1:0] b;
    reg signed  [DATAWIDTH-1:0] qref;
    wire signed [DATAWIDTH-1:0] qout;
    
    initial begin
        err             <= 0;
        clk             <= 0;
        rst             <= 1;
        #RESET_TIME rst <= 0;
    end
    
    always
        #(CLK_PERIOD/2) clk <= ~clk;

    DIV #(.DATAWIDTH(DATAWIDTH)) DIV_i(a,b,qout);
    
    always @(posedge clk) begin
        if (rst == 1) begin
            a       <= 0;
            b       <= 0;
            qref    <= 1;
        end
        else begin
            a       = $random;
            b       = $random;
            qref    <= a/b;
            if (qout != qref) begin
                err <= 1;
                $error("Error Detected at Time %t: Meas = %d, Meas=%d", $realtime, qout, qref);
            end
        end
    end
    
endmodule