module COMP_tb();

    parameter DATAWIDTH = 32;
    
    localparam CLK_PERIOD = 10;
    localparam RESET_TIME = 100;
    localparam A_ONLY     = 2'b00;
    localparam B_ONLY     = 2'b01;
    localparam A_AND_B    = 2'b10;
    
    reg [DATAWIDTH-1:0] a;
    reg [DATAWIDTH-1:0] b;
    
    reg gt_ref;
    reg lt_ref;
    reg eq_ref;
    
    wire gt_meas;
    wire lt_meas;
    wire eq_meas;
    
    reg [1:0] state;
    reg valid;
    
    wire clk;
    wire rst;
    reg  err;
    
    clk_gen #(.CLK_PERIOD(CLK_PERIOD)) clk_gen_i(clk);
    rst_gen #(.RESET_TIME(RESET_TIME)) rst_gen_i(rst);
    
    always @(posedge clk) begin
        if (rst == 1) begin
            a       <= 0;
            b       <= 0;
            gt_ref  <= 0;
            lt_ref  <= 0;
            eq_ref  <= 0;
            valid   <= 0;
            state   <= A_ONLY;
        end
        else begin
            valid   <= 1;
            case (state)
                A_ONLY : begin
                    a       = $urandom;
                    gt_ref <= (a > 0);
                    lt_ref <= 0;
                    eq_ref <= (a == 0);
                    state  <= B_ONLY;
                end
                B_ONLY : begin
                    b       = $urandom;
                    gt_ref <= (a > b);
                    lt_ref <= (a < b);
                    eq_ref <= (a == b);
                    state  <= A_AND_B;
                end
                default : begin
                    a       = $urandom;
                    b       = $urandom;
                    gt_ref <= (a > b);
                    lt_ref <= (a < b);
                    eq_ref <= (a == b);
                    state  <= A_AND_B;
                end
            endcase
        end
    end
    
    COMP #(.DATAWIDTH(DATAWIDTH)) COMP_i(a,b,gt_meas,lt_meas,eq_meas);
    
    always @(posedge clk) begin
        if (rst == 1)
            err <= 0;
        else begin
            if (valid == 1) begin
                if ((gt_meas != gt_ref) || (lt_meas != lt_ref) || (eq_meas != eq_meas)) begin
                    err <= 1;
                    $error("Error Detected at Time %t: gt(meas) = %d, lt(meas) = %d, eq(meas) = %d, gt(ref) = %d, lt(ref) = %d, eq(ref) = %d",
                        $realtime, gt_meas, lt_meas, eq_meas, gt_ref, lt_ref, eq_ref);
                end
            end
        end
    end
endmodule