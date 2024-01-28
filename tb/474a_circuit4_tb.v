`timescale 1ns/1ns

module circuit4_tb();

    localparam CLK_PERIOD = 10;
    localparam RESET_TIME = 100;

    wire clk;
    wire rst;

    reg [63:0] a, b, c;
    reg valid;

    wire err, err_x, err_z;
    wire [31:0] x_ref, z_ref;
    wire [31:0] x_meas, z_meas;

    clk_gen #(.CLK_PERIOD(CLK_PERIOD)) clk_gen_i(clk);
    rst_gen #(.RESET_TIME(RESET_TIME)) rst_gen_i(rst);

    always @(posedge clk) a <= rst ? 0 : $random;
    always @(posedge clk) b <= rst ? 0 : $random;
    always @(posedge clk) c <= rst ? 0 : $random;

    circuit4 circuit4_i(a,b,c,z_meas,x_meas,clk,rst);

    circuit4_behav circuit4_behav_i(a,b,c,z_ref,x_ref,clk,rst);

    always @(posedge clk) valid <= ~rst;

    error_monitor #(.DATAWIDTH(64)) error_monitor_x(x_meas, x_ref, valid, err_x, clk, rst);
    error_monitor #(.DATAWIDTH(64)) error_monitor_z(z_meas, z_ref, valid, err_z, clk, rst);

    assign err = err_x & err_z;

endmodule