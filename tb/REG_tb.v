`timescale 1ns/1ns

module REG_tb();

    localparam CLK_PERIOD = 10;
    localparam RESET_TIME = 100;
    localparam DATAWIDTH  = 32;
   
    wire clk;
    wire rst;
    reg  valid;
    reg  err;
    
    reg  [DATAWIDTH-1:0] d;
    reg  [DATAWIDTH-1:0] q_ref;
    wire [DATAWIDTH-1:0] q_meas;

    initial begin
        valid <= 0;
        err   <= 0;
    end
        
    clk_gen #(.CLK_PERIOD(CLK_PERIOD)) clk_gen_i(clk);
    
    rst_gen #(.RESET_TIME(RESET_TIME)) rst_gen_i(rst);
    
    REG #(.DATAWIDTH(DATAWIDTH)) REG_i(q_meas,d,clk,rst);
    
    always @(posedge clk) begin
        valid       <= 1;
        if (rst == 1) begin
            d       <= 0;
            q_ref   <= 0;
        end
        else begin
            d       <= d + 1;
            q_ref   <= d;
        end
        if ((valid == 1) && (q_meas != q_ref)) begin
            err     <= 1;
            $error("Error Detected at Time %t: Meas = %d, Meas=%d", $realtime, q_meas, q_ref);
        end
    end
endmodule