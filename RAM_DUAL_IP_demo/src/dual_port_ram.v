module dual_port_ram #(
    parameter AW = 6,
    parameter DW = 8
)
(
    input   sys_clk,
    input   sys_rst

);
    wire ram_wr_en;
    wire ram_wr_we;
    wire [AW-1:0] ram_wr_addr;
    wire [DW-1:0] ram_wr_data;
    wire rd_flag;
    wire [DW-1:0] ram_rd_data;
    wire ram_rd_en;
    wire [AW-1:0] ram_rd_addr;


    ram_wr u_ram_wr(
        .clk(sys_clk),
        .rst(sys_rst),

        // RAM 写端口 A
        .ram_wr_en(ram_wr_en),
        .ram_wr_we(ram_wr_we),
        .ram_wr_addr(ram_wr_addr),
        .ram_wr_data(ram_wr_data),
        .rd_flag(rd_flag) 
    );

    ram_rd u_ram_rd (
        .clk(sys_clk),
        .rst(sys_rst),

        .rd_flag(rd_flag),
        // RAM B 端口， 读操作
        .ram_rd_data(ram_rd_data),
        .ram_rd_en(ram_rd_en),
        .ram_rd_addr(ram_rd_addr)
    );



    ram_dual_ram_ip u_ram_dual_ram_ip(
        .clka(sys_clk),
        .ena(ram_wr_en),
        .wea(ram_wr_we),
        .addra(ram_wr_addr),
        .dina(ram_wr_data),

        .clkb(sys_clk),
        .enb(rd_flag),
        .addrb(ram_rd_addr),
        .doutb(ram_rd_data)

    );

endmodule

