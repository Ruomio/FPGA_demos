module top (
    input   sys_clk,
    input   sys_rst
);

    dual_port_ram u_dual_port_ram
    (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst)

    );
    
endmodule