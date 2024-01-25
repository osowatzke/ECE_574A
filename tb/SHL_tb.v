`timescale 1ns/1ns

module SHL_tb();

    parameter DATAWIDTH = 32;
    
    localparam CLK_PERIOD = 10;
    localparam RESET_TIME = 100;
    localparam A_ONLY     = 2'b00;
    localparam SH_ONLY    = 2'b01;
    localparam A_AND_SH   = 2'b10;
    
    reg  [DATAWIDTH-1:0] a;
    reg  [DATAWIDTH-1:0] sh_amt;
    reg  [DATAWIDTH-1:0] d_ref;
    wire [DATAWIDTH-1:0] d_meas;
    
    reg [1:0] state;
    reg valid;
    
    wire clk;
    wire rst;
    wire err;
    
    clk_gen #(.CLK_PERIOD(CLK_PERIOD)) clk_gen_i(clk);
    rst_gen #(.RESET_TIME(RESET_TIME)) rst_gen_i(rst);
    
    always @(posedge clk) begin
        if (rst == 1) begin
            a      <= 0;
            sh_amt <= 0;
            d_ref  <= 0;
            valid  <= 0;
            state  <= A_ONLY;
        end
        else begin
            valid <= 1;
            case (state)
                A_ONLY : begin
                    a      = $urandom;
                    d_ref <= a;
                    state <= SH_ONLY;
                end
                SH_ONLY : begin
                    sh_amt = $urandom_range(1,DATAWIDTH);
                    d_ref <= a << sh_amt;
                    state <= A_AND_SH;
                end
                default : begin
                    a      = $urandom;
                    sh_amt = $urandom_range(1,DATAWIDTH);
                    d_ref <= a << sh_amt;
                    state <= A_AND_SH;
                end
            endcase
        end
    end
    
    SHL #(.DATAWIDTH(DATAWIDTH)) SHL_i(a,sh_amt,d_meas);
    error_monitor #(.DATAWIDTH(DATAWIDTH)) error_monitor_i(d_meas,d_ref,valid,err,clk,rst);
endmodule