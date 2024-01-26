`timescale 1ns/1ns


module testbench ();

    // 六个位宽为8的数组
    reg [7:0] usart_tx_mem[5:0];

    initial begin
        usart_tx_mem[0] = 8'h55;
        usart_tx_mem[1] = 8'hAA;
        usart_tx_mem[2] = 8'h12;
        usart_tx_mem[3] = 8'h34;
        usart_tx_mem[4] = 8'h55;
        usart_tx_mem[5] = 8'hAA;
    end

    task send_byte(input [7:0] b);
        integer i;
        for (i=0; i<10; i=i+1) begin
            case (i)
                0: usart_tx <= 1'b0;
                9: usart_tx <= 1'b1;
                default: usart_tx <= b[i-1];
            endcase
            #20;
        end
    endtask

    task send_bytes();
        integer i;
        for (i=0 ; i<6; i=i+1 ) begin
            send_byte(usart_tx_mem[i]);
        end
    endtask

    reg clk;
    reg usart_tx;
    wire [5:0] led;

    always #1 clk <= ~clk;

    initial begin
        clk = 0;
        usart_tx = 1;

        #20;
        send_bytes();
    end

    

    usart #(.BaudRateDiv(10)) usart_tb(
        .clk(clk),              // 27M
        .usart_rxp(usart_tx),

        .led(led)
    );


    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,testbench);
        #6000 $finish;
    end

endmodule