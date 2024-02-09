module fifo_rd #(
    parameter DW = 8
)(
    input rd_clk,
    input rst,
    input rd_rst_busy,
    input full,                         // 写时钟域下的信号，要延迟两个周期来同步
    input almost_empty,
    input [DW-1:0] fifo_rd_data,
    output reg fifo_rd_en
);
    reg full_d0;
    reg full_d1;

    // 延迟两个周期
    always @(posedge rd_clk or negedge rst) begin
        if(!rst) begin
            full_d0 <= 1'b0;
            full_d1 <= 1'b0;
        end
        else begin 
            full_d0 <= full;
            full_d1 <= full_d0;
        end
    end

    /*
    // 1. 只要队列非空就读，读空停止
    always @(posedge rd_clk or negedge rst) begin
        if(!rst)
            fifo_rd_en <= 1'b0;
        else if(almost_empty || rd_rst_busy)
            fifo_rd_en <= 1'b0;
        else
            fifo_rd_en <= 1'b1;
    end
    */

    // fifo_rd_en, 写满之后开始读，读空之后停止读
    always @(posedge rd_clk or negedge rst ) begin
        if(!rst) 
            fifo_rd_en <= 1'b0;
        else if(!rd_rst_busy) begin
            if(full_d1)
                fifo_rd_en <= 1'b1;
            else if(almost_empty)
                fifo_rd_en <= 1'b0;
        end
    end





endmodule
