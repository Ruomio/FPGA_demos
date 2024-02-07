module testbench ();
    
    reg sys_clk;
    reg sys_rst;

    always #1 sys_clk <= ~sys_clk;
    initial begin
        sys_clk <= 1'b0;
        sys_rst <= 1'b0;
        #200;
        sys_rst <= 1'b1;
    end 


    initial begin
        sys_clk = 1'b0;
        sys_rst = 1'b0;
        #200;
        sys_rst = 1'b1;
    end
    top u_top (
        .sys_clk(sys_clk),
        .sys_rst(sys_rst)
    );

    initial begin
        $dumpfile("sim/wave.vcd");
        $dumpvars(0, testbench);
        #1000 $finish;
    end



endmodule
