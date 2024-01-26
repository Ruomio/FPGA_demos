module ram_rw (
    input   clk,
    input   rst_n,

    input   [7:0] ram_rd_data,  // 读出的数据
    
    output  ram_en,             // ram 使能
    output  ram_we,             // 写使能  
    output  [4:0] ram_addr,
    output  [7:0] ram_wr_data   // 写入的数据
);
    
endmodule