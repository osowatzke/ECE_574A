`timescale 1ns/1ns

module circuit3_tb();

    localparam CLK_PERIOD = 10;
    localparam RESET_TIME = 100;

    wire clk;
    wire rst;

    reg [15:0] a, b, c, d, e, f, g, h;
    reg [ 7:0] sa;
    reg valid;

    wire err;
    wire [15:0] avg_ref;
    wire [15:0] avg_meas;

    clk_gen #(.CLK_PERIOD(CLK_PERIOD)) clk_gen_i(clk);
    rst_gen #(.RESET_TIME(RESET_TIME)) rst_gen_i(rst);

    always @(posedge clk) a  <= rst ? 0 : $random;
    always @(posedge clk) b  <= rst ? 0 : $random;
    always @(posedge clk) c  <= rst ? 0 : $random;
    always @(posedge clk) d  <= rst ? 0 : $random;
    always @(posedge clk) e  <= rst ? 0 : $random;
    always @(posedge clk) f  <= rst ? 0 : $random;
    always @(posedge clk) g  <= rst ? 0 : $random;
    always @(posedge clk) h  <= rst ? 0 : $random;
    always @(posedge clk) sa <= rst ? 0 : $urandom_range(0,32);

    circuit3 circuit3_i(a,b,c,d,e,f,g,h,sa,avg_meas,clk,rst);

    circuit3_behav circuit3_behav_i(a,b,c,d,e,f,g,h,sa,avg_ref,clk,rst);

    always @(posedge clk) valid <= ~rst;

    error_monitor #(.DATAWIDTH(16)) error_monitor_i(avg_meas, avg_ref, valid, err, clk, rst);

endmodule