module fifo_wr #(
    parameter DW = 8
)(
    input wr_clk,
    input rst,
    input wr_rst_busy,
    input empty,                        // 读时钟域下的信号，要延迟两个周期同步
    input almost_full,
    output reg fifo_wr_en,
    output reg [DW-1:0] fifo_wr_data
);
    
    reg empty_d0;
    reg empty_d1;
    
    // delay two period
    always @(posedge wr_clk or negedge rst) begin
        if(!rst) begin
            empty_d0 <= 1'b0;
            empty_d1 <= 1'b0;
        end
        else begin
            empty_d0 <= empty;
            empty_d1 <= empty_d0;
        end
    end
    
    /*
    // 1. unfull  --> write
    always @(posedge wr_clk or negedge rst) begin
        if(!rst)
            fifo_wr_en <= 1'b0;
        else if(almost_full || wr_rst_busy)
            fifo_wr_en < 1'b0;
        else
            fifo_wr_en <= 1'b1;
    end
    */

    // 2. only empty  --> write
    always @(posedge wr_clk or negedge rst) begin
        if(!rst)
            fifo_wr_en <= 1'b0;
        else if(!wr_rst_busy) begin
            if(empty_d1)
                fifo_wr_en <= 1'b1;
            else if(almost_full)
                fifo_wr_en <= 1'b0;
        end
        else
            fifo_wr_en <= fifo_wr_en;
    end

    // fifo_wr_data
    always @(posedge wr_clk) begin
        if(!rst)
            fifo_wr_data <= 8'b0;
        else if(fifo_wr_en && fifo_wr_data < 8'd254)
            fifo_wr_data <= fifo_wr_data + 8'b1;
        else
            fifo_wr_data <= 8'b0;
    end
endmodule
