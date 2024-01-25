module MUX2x1_tb();

    parameter DATAWIDTH = 32;
    
    localparam CLK_PERIOD = 10;
    localparam RESET_TIME = 100;
    localparam A_ONLY     = 2'b00;
    localparam B_ONLY     = 2'b01;
    localparam SEL_ONLY   = 2'b10;
    localparam A_B_SEL    = 2'b11;
    
    reg  [DATAWIDTH-1:0] a;
    reg  [DATAWIDTH-1:0] b;
    reg  [DATAWIDTH-1:0] dRef;
    wire [DATAWIDTH-1:0] dMeas;
    
    reg [1:0] state;
    reg valid;
    reg sel;
        
    wire clk;
    wire rst;
    wire err;
    
    clk_gen #(.CLK_PERIOD(CLK_PERIOD)) clk_gen_i(clk);
    rst_gen #(.RESET_TIME(RESET_TIME)) rst_gen_i(rst);
    
    always @(posedge clk) begin
        if (rst == 1) begin
            a     <= 0;
            b     <= 0;
            sel   <= 0;
            valid <= 0;
            dRef  <= 0;
            state <= A_ONLY;
        end
        else begin
            valid <= 1;
            case (state)
                A_ONLY : begin
                    a      = $urandom;
                    dRef  <= a;
                    state <= SEL_ONLY;
                end
                B_ONLY : begin
                    b      = $urandom;
                    dRef  <= b;
                    state <= A_B_SEL;
                end
                SEL_ONLY : begin
                    sel   <= 1;
                    dRef  <= 0;
                    state <= B_ONLY;
                end
                default : begin
                    a      = $urandom;
                    b      = $urandom;
                    sel    = $urandom_range(0,1);
                    dRef  <= sel ? b : a;
                    state <= A_B_SEL;
                end
            endcase
        end
    end
    
    MUX2x1 #(.DATAWIDTH(DATAWIDTH)) MUX2x1(a,b,sel,dMeas);
    error_monitor #(.DATAWIDTH(DATAWIDTH)) error_monitor_i(dMeas,dRef,valid,err,clk,rst);
endmodule