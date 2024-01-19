`timescale 1ns/1ns

module REG_tb();

    localparam CLK_PERIOD = 10;
    localparam RESET_TIME = 100;
    localparam DATAWIDTH  = 32;
   
    reg Clk;
    reg Rst;
    reg valid;
    reg err;
    
    reg  [DATAWIDTH-1:0] d;
    wire [DATAWIDTH-1:0] q;
    reg  [DATAWIDTH-1:0] q_ref;

    initial begin
        Clk             <= 0;
        Rst             <= 1;
        valid           <= 0;
        err             <= 0;
        #RESET_TIME Rst <= 0;
    end
        
    always
        #(CLK_PERIOD/2) Clk <= ~Clk;
    
    REG #(.DATAWIDTH(DATAWIDTH)) REG_i(q,d,Clk,Rst);
    
    always @(posedge Clk) begin
        valid       <= 1;
        if (Rst == 1) begin
            d       <= 0;
            q_ref   <= 0;
        end
        else begin
            d       <= d + 1'b1;
            q_ref   <= d;
        end
        if ((valid == 1) && (q != q_ref)) begin
            err     <= 1;
            $error("Error Detected at Time %t: Meas = %d, Meas=%d", $realtime, q, q_ref);
        end
    end
endmodule