`timescale 1ns/1ns

module REG_tb();

    localparam CLK_PERIOD = 10;
    localparam RESET_TIME = 100;
    localparam DATAWIDTH  = 32;
   
    wire clk;
    wire rst;
    reg  valid;
    reg  err;
    
    wire [DATAWIDTH-1:0] d;
    wire [DATAWIDTH-1:0] q;
    reg  [DATAWIDTH-1:0] q_ref;

    initial begin
        valid <= 0;
        err   <= 0;
    end
        
    clk_gen #(.CLK_PERIOD(CLK_PERIOD)) clk_gen_i(clk);
    
    rst_gen #(.RESET_TIME(RESET_TIME)) rst_gen_i(rst);
    
    inc_gen #(.DATAWIDTH(DATAWIDTH)) inc_gen_i(d,clk,rst);
    
    REG #(.DATAWIDTH(DATAWIDTH)) REG_i(q,d,clk,rst);
    
    always @(posedge clk) begin
        valid       <= 1;
        if (rst == 1)
            q_ref   <= 0;
        else
            q_ref   <= d;
        if ((valid == 1) && (q != q_ref)) begin
            err     <= 1;
            $error("Error Detected at Time %t: Meas = %d, Meas=%d", $realtime, q, q_ref);
        end
    end
endmodule