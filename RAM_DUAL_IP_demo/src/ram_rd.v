module ram_rd #(
    parameter AW = 6,
    parameter DW = 8
)
(
    input   clk,
    input   rst,

    input                   rd_flag,
    // RAM B 端口， 读操作
    input        [DW-1:0]    ram_rd_data,
    output                   ram_rd_en,
    output  reg  [AW-1:0]    ram_rd_addr
);

    assign ram_rd_en = rd_flag;

    // RAM B端口读地址控制
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            ram_rd_addr <= 1'b0;
        end
        else if(ram_rd_en && ram_rd_addr < 6'd63) begin
            ram_rd_addr <= ram_rd_addr + 6'b1;
        end
        else begin
            ram_rd_addr <= 6'b0;
        end
    end


endmodule