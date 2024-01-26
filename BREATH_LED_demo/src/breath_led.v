module breath_led (
    input clk,
    input reset,
    output [5:0] led
);
    reg [5:0] led_reg = 6'b111111;
    reg inc_dec_flag = 1'b0;
    reg [6:0] cnt_2us;
    reg [9:0] cnt_2ms;
    reg [9:0] cnt_2s;
    

    // parameter [24:0] WATE_TIME = 13500000-1;
    parameter CNT_2US_MAX = 7'd54;     // 27M * 2us = 54
    parameter CNT_2MS_MAX = 10'd1000;   // 27M * 2ms = 54_000
    parameter CNT_2S_MAX = 10'd1000;    // 27M * 2S = 54_000_000

    always @(posedge clk or negedge reset) begin
        if(!reset)
            cnt_2us <= 7'b0000000;
        else if(cnt_2us == CNT_2US_MAX - 1'b1)
            cnt_2us <= 7'b0000000;
        else
            cnt_2us <= cnt_2us + 1'b1;

    end

    always @(posedge clk or negedge reset) begin
        if(!reset)
            cnt_2ms <= 10'b0;
        else if((cnt_2us == CNT_2US_MAX - 1) && (cnt_2ms == CNT_2MS_MAX - 1))
            cnt_2ms <= 10'b0;
        else if(cnt_2us == CNT_2US_MAX -1 )
            cnt_2ms <= cnt_2ms + 1'b1;
        else
            cnt_2ms <= cnt_2ms;
    end

    always @(posedge clk or negedge reset) begin
        if(!reset)
            cnt_2s <= 10'b0000000000;
        else if((cnt_2us == CNT_2US_MAX-1) && (cnt_2ms == CNT_2MS_MAX-1) && (cnt_2s == CNT_2S_MAX-1))
            cnt_2s <= 10'b0;
        else if((cnt_2us == CNT_2US_MAX-1) && (cnt_2ms == CNT_2MS_MAX-1))
            cnt_2s <= cnt_2s + 1'b1;
        else
            cnt_2s <= cnt_2s;
    end

    always @(posedge clk or negedge reset) begin
        if(!reset)
            inc_dec_flag <= 1'b0;
        else if((cnt_2us == CNT_2US_MAX-1) && (cnt_2ms == CNT_2MS_MAX-1) && (cnt_2s == CNT_2S_MAX-1))
            inc_dec_flag <= ~inc_dec_flag;
        else
            inc_dec_flag <= inc_dec_flag;
    end

    always @(posedge clk or negedge reset) begin
        if(!reset)
            led_reg[5:0] <= 6'b111111;
        else if((inc_dec_flag == 1'b0 && cnt_2ms <= cnt_2s) || (inc_dec_flag == 1'b1 && cnt_2ms >= cnt_2s))
            led_reg[5:0] <= 6'b000000;
        else
            led_reg[5:0] <= 6'b111111; 
    end

    assign led[5:0] = led_reg[5:0];

    
endmodule


module top (
    input clk,
    input reset,
    output [5:0] led
);
    breath_led u_breath_led(.clk(clk), .reset(reset), .led(led));
endmodule