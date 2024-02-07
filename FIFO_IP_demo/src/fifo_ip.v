module fifo_ip #(
    parameter DW = 8;
)
(
    input   rst,
    input   wr_clk,
    input   rd_clk,
    input   wr_en,
    input   rd_en,
    input   [DW-1:0] din,
    output  [DW-1:0] dout,
    output  full,
    output  almost_full,
    output  empty,
    output  almost_emoty,
    output  [DW-1:0] rd_data_count,
    output  [DW-1:0] wr_data_count,
    output  wr_rst_busy,
    output  rd_rst_busy,

);
    
endmodule