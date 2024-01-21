`timescale 1ns/1ns

module MOD_tb();

    localparam DATAWIDTH  = 32;
    localparam CLK_PERIOD = 10;
    localparam RESET_TIME = 100;
    
    reg  clk;
    reg  rst;
    reg  valid;
    wire err;
    
    reg  signed [DATAWIDTH-1:0] a;
    reg  signed [DATAWIDTH-1:0] b;
    wire signed [DATAWIDTH-1:0] rem;
    reg  signed [DATAWIDTH-1:0] rem_ref;
    
    initial begin
        clk             <= 0;
        rst             <= 1;
        #RESET_TIME rst <= 0;
    end
    
    always
        #(CLK_PERIOD/2) clk = ~clk;
        
    always @(posedge clk) begin
        if (rst == 1) begin
            a       <= 0;
            b       <= 0;
            rem_ref <= 0;
            valid   <= 0;
        end
        else begin
            a        = $random;
            b        = $random;
            b        = $random;
            rem_ref <= a % b;
            valid   <= 1;
        end
    end
    
    MOD #(.DATAWIDTH(DATAWIDTH)) MOD_i(a, b, rem);
    
    error_monitor error_mon(rem, rem_ref, valid, err, clk, rst);

endmodule