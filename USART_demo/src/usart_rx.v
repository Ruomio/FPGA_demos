module usart (
    input clk,              // 27M
    input usart_rxp,

    output[5:0] led
);

    parameter BaudRateDiv = 234;    // 27M / 115200 = 234

    reg[$clog2(BaudRateDiv+1)-1:0] BaudRateCnt = 0;     // 计数器 0-234, 即时钟震动234下，波特率才进一

    // 跨时钟域处理 打两拍，即使用两个周期前的数值
    reg rx_r, rx_rr;
    always @(posedge clk) begin
        rx_r <= usart_rxp;
        rx_rr <= rx_r;
    end
    
    reg [5:0] led_reg = 6'b111111;
    // assign led = ~led_reg;

    localparam RX_STATE_IDLE = 0;
    localparam RX_STATE_START = 1;
    localparam RX_STATE_READ = 2;
    localparam RX_STATE_STOP = 3;

    reg [1:0] status = 0;
    reg [7:0] rx_data = 8'b11000000;
    reg [2:0] rx_cur_index = 0;
    reg rx_data_valid = 0;


    always @(posedge clk) begin
        case (status)
            RX_STATE_IDLE:begin
                if(rx_rr==0) begin
                    status <= RX_STATE_START;
                    BaudRateCnt <= 0;
                    rx_data_valid <= 1'b0;
                end
            end
            RX_STATE_START:begin
                BaudRateCnt <= BaudRateCnt+1'b1;
                if(BaudRateCnt == BaudRateDiv/2 - 1) begin  // 计数一半判断，避免开端电平不稳定的情况
                    status <= RX_STATE_READ;
                    BaudRateCnt <= 0;   // 重新计数
                    rx_cur_index <= 0;
                end
            
            end
            RX_STATE_READ:begin
                BaudRateCnt <= BaudRateCnt+1'b1;
                if(BaudRateCnt == BaudRateDiv - 1) begin
                    // rx_data <= (rx_data>>1) | ({rx_rr, 7'b0000000});
                    rx_data <= {rx_rr, rx_data[7:1]};

                    BaudRateCnt <= 0;
                    rx_cur_index <= rx_cur_index+1'b1;

                    if(rx_cur_index == 7) begin
                        status <= RX_STATE_STOP;    
                    end
                end
            end
            RX_STATE_STOP:begin
                // rx_data_valid <= 1'b0;
                BaudRateCnt <= BaudRateCnt+1'b1;
                if(BaudRateCnt == BaudRateDiv-1) begin
                    status <= RX_STATE_IDLE;
                    if(rx_rr == 1'b1) begin
                        rx_data_valid <= 1'b1;
                    end
                end
            end
        endcase
    end

    always @(posedge clk ) begin
        if(rx_data_valid == 1) begin
            led_reg <= rx_data[5:0];
        end
    end


    assign led = ~led_reg;
    
endmodule

module top (
    input clk,              // 27M
    input usart_rxp,

    output[5:0] led
);
    usart usart_instance(.clk(clk), .usart_rxp(usart_rxp), .led(led));
    
endmodule

