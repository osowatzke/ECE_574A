`timescale 1ns/1ns

module ADD_tb();

    parameter DATAWIDTH = 32;

    localparam CLK_PERIOD = 10;
    localparam RESET_TIME = 100;
    localparam A_ONLY  = 2'b00;
    localparam B_ONLY  = 2'b01;
    localparam A_AND_B = 2'b10;

    reg  [DATAWIDTH-1:0] a;
    reg  [DATAWIDTH-1:0] b;
    reg  [DATAWIDTH-1:0] sumRef;
    wire [DATAWIDTH-1:0] sumMeas;

    reg [1:0] state;
    reg valid;

    wire clk;
    wire rst;
    wire err;

    clk_gen #(.CLK_PERIOD(CLK_PERIOD)) clk_gen_i(clk);
    rst_gen #(.RESET_TIME(RESET_TIME)) rst_gen_i(rst);

    always @(posedge clk) begin
        if (rst == 1) begin
            a       <= 0;
            b       <= 0;
            valid   <= 0;
            sumRef  <= 0;
            state   <= A_ONLY;
        end
        else begin
            valid   <= 1;
            case (state)
                A_ONLY  : begin
                    a       = $urandom;
                    sumRef <= a;
                    state  <= B_ONLY;
                end
                B_ONLY  : begin
                    b       = $urandom;
                    sumRef <= a + b;
                    state  <= A_AND_B;
                end
                default : begin
                    a       = $urandom;
                    b       = $urandom;
                    sumRef <= a + b;
                    state  <= A_AND_B;
                end
            endcase
        end
    end

    ADD #(.DATAWIDTH(DATAWIDTH)) ADD_i(a,b,sumMeas);
    error_monitor #(.DATAWIDTH(DATAWIDTH)) error_monitor_i(sumMeas,sumRef,valid,err,clk,rst);
endmodule