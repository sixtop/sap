module debouncer_testbench;
    logic tb_clk;
    logic tb_pushbutton;
    
    initial begin
        tb_clk = 1'b0;
        tb_pushbutton = 1'b0;
        forever #(10) tb_clk = ~tb_clk;
    end
    
    //simulate states
    initial begin
        #(110);
        
        forever begin 
            
            tb_pushbutton = 1'b1;
            #(20us);            
            tb_pushbutton = 1'b0;
            #(500);


            tb_pushbutton = 1'b1;
            #(200us);            
            tb_pushbutton = 1'b0;
            #(500);

            tb_pushbutton = 1'b1;
            #(2ms);            
            tb_pushbutton = 1'b0;
            #(500);


            tb_pushbutton = 1'b1;
            #(20ms);            
            tb_pushbutton = 1'b0;
            #(500);           
            
            
        end

    end

    debouncer test(
        .clk(tb_clk),
        .PushButton(tb_pushbutton),
        .PB_state()
    );

endmodule
