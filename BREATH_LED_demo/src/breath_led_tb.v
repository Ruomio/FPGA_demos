`timescale 1ns/1ns

module testbench ();
    
    reg clk;
    reg reset;
    wire [5:0] led;

    breath_led #(.CNT_2US_MAX(1), .CNT_2MS_MAX(10), .CNT_2S_MAX(10)) u_breath_led(
        .clk(clk),
        .reset(reset),
        .led(led)
    );

    initial begin
        clk = 1'b0;
        reset = 1'b0;
        // led[5:0] = 6'b111111;
        #200;
        reset = 1'b1;
    end

    always #1 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, testbench);
        #6000 $finish;
    end

endmodule
