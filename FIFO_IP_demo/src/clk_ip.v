module clk_ip (
    input   clk,
    input   rst,

    output  clk_div_1,
    output  reg clk_div_2,
    output  reg clk_div_4,
    output  reg locked
);
    reg [1:0]count = 2'b0;

    // locked  是否稳定
    always @(posedge clk or negedge rst) begin
        if(!rst)
            locked <= 1'b0;
        else
            locked <= 1'b1;
    end

    // count
    always @(posedge clk or negedge rst) begin
        if(!rst)
            count <= 2'b0;
        else 
            count <= count + 2'b1;
    end

    // div_1
    assign clk_div_1 = clk;

    // div_2
    always @(posedge clk or negedge rst) begin
        if(!rst)
            clk_div_2 <= 1'b0;
        else begin
            clk_div_2 <= ~clk_div_2;
        end
        
    end

    // div_4
    always @(posedge clk ) begin
        if(!rst)
            clk_div_4 <= 1'b0;
        else if(count == 2'b11)
            clk_div_4 <= ~clk_div_4;
        else
            clk_div_4 <= clk_div_4;
    end

    
endmodule
