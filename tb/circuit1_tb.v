`timescale 1ns/1ns

module circuit1_tb();

    localparam CLK_PERIOD = 10;
    localparam RESET_TIME = 100;

    wire clk;
    wire rst;

    reg [7:0] a, b, c;
    reg valid;

    wire err, err_x, err_z;
    wire [15:0] x_ref, x_meas;
    wire [ 7:0] z_ref, z_meas;

    clk_gen #(.CLK_PERIOD(CLK_PERIOD)) clk_gen_i(clk);
    rst_gen #(.RESET_TIME(RESET_TIME)) rst_gen_i(rst);

    always @(posedge clk) a <= rst ? 0 : $random;
    always @(posedge clk) b <= rst ? 0 : $random;
    always @(posedge clk) c <= rst ? 0 : $random;

    circuit1 circuit1_i(a,b,c,z_meas,x_meas,clk,rst);

    circuit1_behav circuit1_behav_i(a,b,c,z_ref,x_ref,clk,rst);

    always @(posedge clk) valid <= ~rst;

    error_monitor #(.DATAWIDTH(16)) error_monitor_x(x_meas, x_ref, valid, err_x, clk, rst);
    error_monitor #(.DATAWIDTH(8)) error_monitor_z(z_meas, z_ref, valid, err_z, clk, rst);

    assign err = err_x & err_z;

endmodule