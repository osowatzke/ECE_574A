`timescale 1ns/1ns

module DIV_tb();

    localparam DATAWIDTH  = 32;
    localparam RESET_TIME = 100;
    localparam CLK_PERIOD = 10;

    localparam DIV_ZERO_ZERO = 2'b00;
    localparam DIV_POS_ZERO  = 2'b01;
    localparam DIV_NEG_ZERO  = 2'b10;
    localparam DIV_RANDOM    = 2'b11;

    wire clk;
    wire rst;
    wire err;
    reg  valid;

    reg [1:0] stateR;

    reg signed  [DATAWIDTH-1:0] a;
    reg signed  [DATAWIDTH-1:0] b;
    reg signed  [DATAWIDTH-1:0] qref;
    wire signed [DATAWIDTH-1:0] qout;

    clk_gen #(.CLK_PERIOD(CLK_PERIOD)) clk_gen_i(clk);

    rst_gen #(.RESET_TIME(RESET_TIME)) rst_gen_i(rst);

    DIV #(.DATAWIDTH(DATAWIDTH)) DIV_i(a,b,qout);

    always @(posedge clk) begin
        if (rst == 1) begin
            stateR  <= DIV_ZERO_ZERO;
            a       <= 0;
            b       <= 0;
            qref    <= 0;
            valid   <= 0;
        end
        else begin
            valid   <= 1;
            case(stateR)
                DIV_ZERO_ZERO: begin
                    stateR <= DIV_POS_ZERO;
                    a       = 0;
                    b       = 0;
                end
                DIV_POS_ZERO: begin
                    stateR <= DIV_NEG_ZERO;
                    a       = 1;
                    b       = 0;
                end
                DIV_NEG_ZERO: begin
                    stateR <= DIV_RANDOM;
                    a       = -1;
                    b       =  0;
                end
                default: begin
                    a       = $random;
                    b       = $random;
                end
            endcase
            qref   <= a/b;
        end
    end

    error_monitor error_mon(qout, qref, valid, err, clk, rst);

endmodule