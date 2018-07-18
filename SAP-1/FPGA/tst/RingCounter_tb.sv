module ring_counter_testbench;
    logic tb_clk;
    logic tb_clr;
    
    initial begin
        tb_clk = 1'b0;
        tb_clr = 1'b0;
        forever #(10) tb_clk = ~tb_clk;
    end
    
    //simulate states
    initial begin
        #(110);       

        //generate states
        forever begin
            // T1 state
            tb_clr = 1'b1;
            #(100);
            
            tb_clr = 1'b0;
            #(500);
        end

    end

    RingCounter #(.STATES(10)) test(
        .CLK(tb_clk),
        .CLR_bar(~tb_clr),
        .state()
    );

endmodule
