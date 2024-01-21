`timescale 1ns/1ns

module DIV_tb();

    localparam RNG_SEED   = 0;
    localparam DATAWIDTH  = 32;
    localparam RESET_TIME = 100;
    localparam CLK_PERIOD = 10;
    
    localparam DIV_ZERO_ZERO = 2'b00;
    localparam DIV_POS_ZERO  = 2'b01;
    localparam DIV_NEG_ZERO  = 2'b10;
    localparam DIV_RANDOM    = 2'b11;
    
    reg clk;
    reg rst;
    reg err;
    reg valid;
    
    reg [1:0] stateR;
    
    reg signed  [DATAWIDTH-1:0] a;
    reg signed  [DATAWIDTH-1:0] b;
    reg signed  [DATAWIDTH-1:0] qref;
    wire signed [DATAWIDTH-1:0] qout;
    
    initial begin
        clk             <= 0;
        rst             <= 1;
        #RESET_TIME rst <= 0;
    end
    
    always
        #(CLK_PERIOD/2) clk <= ~clk;

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
    
    always @(posedge clk) begin
        if (rst == 1) begin
            err     <= 0;
        end
        else begin
            if (valid == 1) begin
                if (qout !== qref) begin
                    err <= 1;
                    $error("Error Detected at Time %t: Meas = %d, Meas=%d", $realtime, qout, qref);
                end
            end
        end
    end
    
endmodule