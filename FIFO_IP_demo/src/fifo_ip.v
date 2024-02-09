module fifo_ip #(
    parameter DW = 8,
    parameter AD = 256
)
(
    input   rst,
    input   wr_clk,
    input   rd_clk,
    input   wr_en,
    input   rd_en,
    input   [DW-1:0] din,
    output  reg [DW-1:0] dout,
    output  full,
    output  almost_full,
    output  empty,
    output  almost_empty,
    output  reg [DW-1:0] rd_data_count,
    output  reg [DW-1:0] wr_data_count,
    output  wr_rst_busy,
    output  rd_rst_busy
);  
    
    reg [DW-1:0] front = 8'b0;
    reg [DW-1:0] rear = 8'b0;
    reg [DW-1:0] MEM [255:0];
    
    reg full_reg;
    reg almost_full_reg;
    reg empty_reg;
    reg almost_empty_reg;

    assign full = full_reg;
    assign almost_full = almost_full_reg;
    assign empty = empty_reg;
    assign almost_empty = almost_empty_reg;

    // full
    always @(posedge wr_clk or negedge rst) begin
        if(!rst)
            full_reg <= 1'b0;
        else if(front == 0 && rear == AD-1) begin
            empty_reg <= 1'b0;
            full_reg <= 1'b1;
        end
    end

    // alsmost_full
    always @(posedge wr_clk or negedge rst) begin
        if(!rst)
            almost_full_reg <= 1'b0;
        else if(front == 0 && rear == AD-2) begin
            almost_empty_reg <= 1'b0;
            almost_full_reg <= 1'b1;
        end
    end

    // empty
    always @(posedge rd_clk or negedge rst) begin
        if(!rst)
            empty_reg <= 1'b0;
        else if((front == 0 && rear == 0) || (front == rear)) begin
            empty_reg <= 1'b1;
            full_reg <= 1'b0;
        end
    end
    // almost_empty
    always @(posedge rd_clk or negedge rst) begin
        if(!rst)
            almost_empty_reg <= 1'b0;
        else if(front == AD-2 && rear == AD-1) begin
            almost_full_reg <= 1'b0;
            almost_empty_reg <= 1'b1;
        end
    end

    // rd/wr is reset accomplish
    reg wr_rst_busy_reg;
    reg rd_rst_busy_reg;

    assign wr_rst_busy = wr_rst_busy_reg;
    assign rd_rst_busy = rd_rst_busy_reg;



    // front rear 
    always @(posedge rd_clk or negedge rst) begin
        if(!rst) begin
            front <= 8'b0;
            rear <= 8'b0;
        end
        else if((front == rear) && (rear == AD-1)) begin
            front <= 8'b0;
            rear <= 8'b0;
        end
        else begin
            front <= front;
            rear <= rear;
        end
    end


    // empty <-- read
    always @(posedge rd_clk or negedge rst) begin
        if(!rst) begin
            rd_rst_busy_reg <= ~rst;
        end
        else if(rd_en && !empty && !rd_rst_busy) begin
            dout <= MEM[front];
            if(front < AD -1)
                front <= (front + 8'b1);
            rd_data_count <= rd_data_count + 1'b1;
        end
        else begin
            rd_rst_busy_reg <= 1'b0;
        end
    end
    
    // write   
    always @(posedge wr_clk or negedge rst) begin
        if(!rst) begin
            wr_rst_busy_reg <= ~rst;
        end
        else if(wr_en && !full && !wr_rst_busy) begin
            MEM[rear] <= din;
            if(rear < AD-1)
                rear <= (rear + 8'b1);
            wr_data_count <= wr_data_count + 1'b1;
        end
        else begin
            wr_rst_busy_reg <= 1'b0;
        end
    end


endmodule
