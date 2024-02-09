module fifo_top #(
    parameter DW = 8
)    
(
    input sys_clk,
    input sys_rst

);

    
    
    wire clk_div_1; 
    wire clk_div_2; 
    wire clk_div_4; 
    wire locked; 
    wire rst_n;
    wire wr_rst_busy;
    wire empty;
    wire almost_empty;
    wire fifo_wr_en;
    wire [DW-1:0] fifo_wr_data;
    wire rd_rst_busy;
    wire full;
    wire almost_full;
    wire fifo_rd_en;
    wire [DW-1:0] fifo_rd_data;

    wire [DW-1:0] wr_data_count;
    wire [DW-1:0] rd_data_count;

    assign rst_n = sys_rst & locked;


    clk_ip u_clk_ip(
        .clk(sys_clk),
        .rst(sys_rst),

        .clk_div_1(clk_div_1),
        .clk_div_2(clk_div_2),
        .clk_div_4(clk_div_4),
        .locked(locked)
    );

    fifo_wr u_fifo_wr
    (
        .wr_clk(clk_div_4),
        .rst(rst_n),
        .wr_rst_busy(wr_rst_busy),
        .empty(empty),                        // 读时钟域下的信号，要延迟两个周期同步
        .almost_full(almost_full),
        .fifo_wr_en(fifo_wr_en),
        .fifo_wr_data(fifo_wr_data)
    );

    fifo_rd u_fifo_rd
    (
        .rd_clk(clk_div_2),
        .rst(rst_n),
        .rd_rst_busy(rd_rst_busy),
        .full(full),                         // 写时钟域下的信号，要延迟两个周期来同步
        .almost_empty(almost_empty),
        .fifo_rd_data(fifo_rd_data),
        .fifo_rd_en(fifo_rd_en)
    );


    fifo_ip u_fifo_ip
    (
        .rst(rst_n),
        .wr_clk(clk_div_4),
        .rd_clk(clk_div_2),
        .wr_en(fifo_wr_en),
        .rd_en(fifo_rd_en),
        .din(fifo_wr_data),
        .dout(fifo_rd_data),
        .full(full),
        .almost_full(almost_full),
        .empty(empty),
        .almost_empty(almost_empty),
        .rd_data_count(rd_data_count),
        .wr_data_count(wr_data_count),
        .wr_rst_busy(wr_rst_busy),
        .rd_rst_busy(rd_rst_busy)
    );  

endmodule
