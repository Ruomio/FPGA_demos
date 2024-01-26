// 仿真  test bench 文件
`timescale 1ns/1ns

module testbench ();
    reg clk;

    wire [5:0] led;

    // 每隔一个周期，clk反转一次
    always #1 clk = ~clk;

    initial begin
        clk = 0;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,testbench);
        #6000 $finish;
    end


    led #(.WAIT_TIME(5)) u_led
        (
            .clk(clk),
            .led(led)
        );


    
endmodule