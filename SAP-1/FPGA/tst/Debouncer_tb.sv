module debouncer_testbench;
    logic tb_clk;
    logic tb_clr;
    logic tb_pushbutton;
    
    initial begin
        tb_clk = 1'b0;
        tb_clr = 1'b0;
        tb_pushbutton = 1'b0;
        forever #(10) tb_clk = ~tb_clk;
    end
    
    //simulate states
    initial begin
        #(110);
        tb_clr = 1'b1;


        repeat (10) begin 
            
            tb_pushbutton = 1'b1;
            #(1500);            
            tb_pushbutton = 1'b0;
            #(500);
        end
        
        repeat (2) begin 
            
            tb_pushbutton = 1'b1;
            #(240);            
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
        
        $stop;

    end

    debouncer #(.WIDTH(16)) test(
        .clk(tb_clk),
        .clr(tb_clr),
        .PushButton(tb_pushbutton),
        .PB_state(),
        .PB_down(),
        .PB_up()
    );

endmodule
