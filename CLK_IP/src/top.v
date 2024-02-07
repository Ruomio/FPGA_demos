module top(
    input sys_clk,
    input sys_rst
);
    
    wire clk_div_1;
    wire clk_div_2;
    wire clk_div_4;
    
    clk_ip u_clk_ip(
        .clk(sys_clk),
        .rst(sys_rst),

        .clk_div_1(clk_div_1),
        .clk_div_2(clk_div_2),
        .clk_div_4(clk_div_4)
    );

endmodule
