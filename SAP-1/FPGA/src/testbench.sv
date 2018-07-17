module testbench;
    logic tb_clk;
    logic tb_reset_b;
    reg [31:0] data;
    reg [4:0] counter;

    initial begin
        data = 32'b0001_1010_0101_1011_1011_0011_0111_0111;
        tb_clk = 1'b0;
        tb_reset_b = 1'b0;
        forever begin
            #(10);
            tb_clk = ~tb_clk;
        end
    end

    initial begin
        #(50);
        tb_reset_b = 1'b1;
    end

    always @ (negedge tb_clk, negedge tb_reset_b) begin
        if(tb_reset_b == 0)
            counter <= 4'b0;

        else begin
            if(counter == 0)
                counter <= 31;
            else
                counter <= counter - 1;
        end
    end


    seqdeta test(
        .clk(tb_clk),
        .clr(tb_reset_b),
        .din(data[counter]),
        .dout()
    );

endmodule
