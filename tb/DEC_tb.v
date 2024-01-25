`timescale 1ns/1ns

module DEC_tb();

    parameter DATAWIDTH = 32;

    localparam CLK_PERIOD = 10;
    localparam RESET_TIME = 100;

    reg  [DATAWIDTH-1:0] a;
    reg  [DATAWIDTH-1:0] dRef;
    wire [DATAWIDTH-1:0] dMeas;

    reg valid;

    wire clk;
    wire rst;
    wire err;

    clk_gen #(.CLK_PERIOD(CLK_PERIOD)) clk_gen_i(clk);
    rst_gen #(.RESET_TIME(RESET_TIME)) rst_gen_i(rst);

    always @(posedge clk) begin
        if (rst == 1) begin
            a       <= 0;
            dRef    <= 0;
            valid   <= 0;
        end
        else begin
            a        = $urandom;
            dRef    <= a - 1;
            valid   <= 1;
        end
    end

    DEC #(.DATAWIDTH(DATAWIDTH)) DEC_i(a,dMeas);
    error_monitor #(.DATAWIDTH(DATAWIDTH)) error_monitor_i(dMeas,dRef,valid,err,clk,rst);
endmodule