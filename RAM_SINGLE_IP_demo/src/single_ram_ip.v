// 32深度,8位位宽的RAM

module single_ram_ip #(
        parameter ADDR_WIDTH = 5,
        parameter DATA_WIDTH = 8,
        parameter MEM_WIDTH = 32  
    )
(
    input   clk,
    input   ram_en,                 // ram 使能
    input   ram_we,                 // 写使能  1:0 = 写:读
    input   [ADDR_WIDTH-1:0] addr,  // 地址
    input   [DATA_WIDTH-1:0] din,   // 写入的数据
    output  [DATA_WIDTH-1:0] dout   // 读出的数据
);
    // reg [ADDR_WIDTH-1:0] addr;
    // reg [DATA_WIDTH-1:0] din;

    reg [DATA_WIDTH-1:0] mem [MEM_WIDTH-1:0];
    reg [DATA_WIDTH-1:0] dout_reg;

    reg [ADDR_WIDTH-1:0] i = 5'b0;

    always @(posedge clk) begin
        if(ram_en && ram_we) begin          // 写数据
            mem[addr] <= din;
        end
        else if(ram_en && !ram_we) begin    // 读数据
            dout_reg <= mem[i];
            if(i<31)
                i <= i + 1'b1;
            else
                i <= 1'b0;
        end
        
    end

    assign dout = dout_reg;
    
endmodule