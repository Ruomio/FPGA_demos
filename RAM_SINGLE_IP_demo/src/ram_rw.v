// 调用 single_ram_ip 模块

module ram_rw(
    input sys_clk,
    input sys_rst,
    input [7:0] ram_rd_data,

    output reg ram_en,
    output ram_we,
    output reg [4:0] addr,
    output reg [7:0] ram_wr_data
);
    

    reg [5:0] cnt;      // 计数，0~31 写数据, 31~63读数据

    // ram 使能
    always @(posedge sys_clk or negedge sys_rst) begin
        if(!sys_rst)
            ram_en <= 1'b0;
        else
            ram_en <= 1'b1;
    end

    // cnt计数
    always @(posedge sys_clk or negedge sys_rst) begin
        if(!sys_rst)
            cnt <= 1'b0;
        else if(!ram_en || cnt == 6'd63)
            cnt <= 1'b0;
        else
            cnt <= cnt + 1'b1;
    end

    // ram_we 写使能
    assign ram_we = (ram_en && cnt < 32) ? 1'b1 : 1'b0;

    /* always @(posedge sys_clk or negedge sys_rst) begin
        if(!sys_rst)
            ram_we <= 1'b0;
        else if(cnt < 31 && ram_en)
            ram_we <= 1'b1;
        else
            ram_we <= 1'b0;
    end */

    // 地址变化
    always @(posedge sys_clk or negedge sys_rst) begin
        if(!sys_rst)
            addr <= 1'b0;
        else if(ram_en && cnt < 6'd31)
            addr <= addr + 1'b1;
        else
            addr <= 1'b0;
         
    end

    // 写数据
    always @(posedge sys_clk or negedge sys_rst) begin
        if(!sys_rst)
            ram_wr_data <= 1'b0;
        else if(ram_we && ram_wr_data < 6'd31)
            ram_wr_data <= ram_wr_data + 1'b1;
        else
            ram_wr_data <= 1'b0;
         
    end


endmodule