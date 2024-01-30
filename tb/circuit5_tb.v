`timescale 1ns/1ns

module circuit5_tb();

    localparam CLK_PERIOD = 10;
    localparam RESET_TIME = 100;

    wire clk;
    wire rst;

    reg [63:0] a, b, c, d, zero;
    reg [1:0] count;
    reg valid;

    wire err;
    wire [63:0] z_ref, z_meas;

    clk_gen #(.CLK_PERIOD(CLK_PERIOD)) clk_gen_i(clk);
    rst_gen #(.RESET_TIME(RESET_TIME)) rst_gen_i(rst);

    always @(posedge clk) a    <= rst ? 0 : $random;
    always @(posedge clk) b    <= rst ? 0 : $random;
    always @(posedge clk) c    <= rst ? 0 : $random;
    always @(posedge clk) d    <= rst ? 0 : $random;
    always @(posedge clk) zero <= rst ? 0 : $random;

    circuit5 circuit5_i(a,b,c,d,zero,z_meas,clk,rst);

    circuit5_behav circuit5_behav_i(a,b,c,d,zero,z_ref,clk,rst);

    always @(posedge clk) begin
        if (rst == 1) begin
            valid <= 0;
            count <= 0;
        end
        else begin
            if (count == 2)
                valid <= 1;
            else
                count <= count + 1;
        end
    end

    error_monitor #(.DATAWIDTH(64)) error_monitor_x(z_meas, z_ref, valid, err, clk, rst);

endmodule