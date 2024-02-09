module top(
    input sys_clk,
    input sys_rst
);

    fifo_top u_fifo_top(
        .sys_clk(sys_clk),
        .sys_rst(sys_rst)
    );


endmodule
