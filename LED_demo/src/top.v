// top.v
module top
(
    input clk,
    output [5:0] led
);

localparam WAIT_TIME = 13500000;
reg [23:0] clockCounter = 0;
reg [5:0] cur_state = 6'b111111;	// 这个六位二进制数的每一位都表示一个 LED


always @(posedge clk) begin
    clockCounter <= clockCounter + 1;
    if (clockCounter == WAIT_TIME) begin
        clockCounter <= 0;
            cur_state <= cur_state << 1;
        if (cur_state == 6'b000000) begin
            cur_state <= 6'b111111;
        end
    end
end

assign led[5:0] = cur_state[5:0];

endmodule

