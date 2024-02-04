module single_port_ram (
    input sys_clk,
    input sys_rst
);

    wire [7:0] ram_rd_data;
    wire ram_en;
    wire ram_we;
    wire [4:0] addr;
    wire [7:0] ram_wr_data;

    ram_rw u_ram_rw(
        .sys_clk(sys_clk),
        .sys_rst(sys_rst),
        .ram_rd_data(ram_rd_data),
        .ram_en(ram_en),
        .ram_we(ram_we),
        .addr(addr),
        .ram_wr_data(ram_wr_data)
    );

    single_ram_ip u_single_ram_ip
    (
        .clk(sys_clk),
        .ram_en(ram_en),                 // ram 使能
        .ram_we(ram_we),                 // 写使能  1:0 = 写:读
        .addr(addr),                     // 地址
        .din(ram_wr_data),               // 写入的数据
        .dout(ram_rd_data)               // 读出的数据
    );

    
endmodule

module top (
    input sys_clk,
    input sys_rst
);

    single_port_ram u_single_port_ram (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst)
    );
    
endmodule