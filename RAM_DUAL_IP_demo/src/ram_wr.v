module ram_wr #(
    parameter AW = 6,
    parameter DW = 8
)
(
    input   clk,
    input   rst,

    // RAM 写端口 A
    output  reg             ram_wr_en,
    output                  ram_wr_we,
    output  reg [AW-1:0]    ram_wr_addr,
    output      [DW-1:0]    ram_wr_data,
    output  reg             rd_flag
    
);

    // RAM A端口使能信号
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            ram_wr_en <= 1'b0;
        end
        else begin
            ram_wr_en <= 1'b1;
        end
    end

    // RAM A端口写使能
    assign ram_wr_we = ram_wr_en;

    // RAM A端口写地址控制
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            ram_wr_addr <= 1'b0;
        end
        else if(ram_wr_en && ram_wr_addr < 6'd63 ) begin
            ram_wr_addr <= ram_wr_addr + 1'b1;
        end
        else begin
            ram_wr_addr <= 1'b0;
        end
    end

    // RAM A端口写数据控制
    assign ram_wr_data = ram_wr_addr;

    // RAM A端口读信号控制
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            rd_flag <= 1'b0;
        end
        else if(ram_wr_addr == 6'd31) begin
            rd_flag <= 1'b1;
        end
        else begin
            rd_flag <= rd_flag;
        end
    end

    
endmodule