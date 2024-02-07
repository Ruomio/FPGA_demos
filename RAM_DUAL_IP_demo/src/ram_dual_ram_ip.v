// 伪双端口ram，两组地址线，一组数据线，一个端口只读，另一个端口只写
module ram_dual_ram_ip #(parameter AW = 6, parameter DW = 8, parameter MD = 64)
(
    input   clka,
    inout   ena,
    input   wea,
    input   [AW-1:0] addra,
    input   [DW-1:0] dina,

    input   clkb,
    input   enb,
    input   [AW-1:0] addrb,
    output  [DW-1:0] doutb

);
    reg     [DW-1:0] mem [MD-1:0];   // 2^6 = 64 depth, 8*64 bit register
    reg     [DW-1:0] doutb_reg;

    // 写模块 A 端口
    always @(posedge clka ) begin
        if(ena && wea) begin
            mem[addra] <= dina;
        end
    end

    // 读模块
    always @(posedge clkb ) begin
        if(enb) begin
            doutb_reg <= mem[addrb];
        end
    end

    assign doutb = doutb_reg;



endmodule