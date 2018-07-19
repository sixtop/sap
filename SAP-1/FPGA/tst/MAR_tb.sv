module mar_testbench;
    logic tb_clk;
    logic Lm;

    logic [3:0] input_address;
    //wire [3:0] output_address;

    initial begin
        tb_clk = 1'b0;
        forever #(10) tb_clk = ~tb_clk;
    end

    initial begin
        input_address = 4'b0;
        forever #(20) input_address <= input_address + 1'b1;
    end

    //simulate states
    initial begin
        Lm = 1'b1;
        #(110);

        //generate states
        repeat (50) begin
            // T1 state
            Lm = 1'b0;
            #(60);

            // TX state
            Lm = 1'b1;
            #(120);
        end
    end

    MAR test(
        .mar_input(input_address),
        .mar_output(),
        .Lm_bar(~Lm),
        .CLK(tb_clk)        
    );

endmodule
