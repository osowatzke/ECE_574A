`timescale 1ns/1ns

module MOD_tb();

    localparam DATAWIDTH  = 32;
    localparam CLK_PERIOD = 10;
    localparam RESET_TIME = 100;

    wire clk;
    wire rst;
    reg  valid;
    wire err;

    wire signed [DATAWIDTH-1:0] a;
    wire signed [DATAWIDTH-1:0] b;
    wire signed [DATAWIDTH-1:0] rem;
    reg  signed [DATAWIDTH-1:0] rem_ref;

    clk_gen #(.CLK_PERIOD(CLK_PERIOD)) clk_gen_i(clk);

    rst_gen #(.RESET_TIME(RESET_TIME)) rst_gen_i(rst);

    rand_gen #(.DATAWIDTH(DATAWIDTH)) rand_gen_a(a, clk, rst);

    rand_gen #(.DATAWIDTH(DATAWIDTH)) rand_gen_b(b, clk, rst);
    
    MOD #(.DATAWIDTH(DATAWIDTH)) MOD_i(a, b, rem);

    always @(a,b)
        rem_ref = a % b;

    always @(posedge clk) begin
        if (rst == 1)
            valid <= 0;
        else
            valid <= 1;
    end

    error_monitor error_mon(rem, rem_ref, valid, err, clk, rst);

endmodule