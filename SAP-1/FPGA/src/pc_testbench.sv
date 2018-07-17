module testbench;
    logic tb_clk, tb_clk_bar;
    logic tb_reset, tb_reset_bar;
    logic Cp;
    logic Ep;
    wire [3:0] out;

    //set up clock and clock_bar
    initial begin
        tb_clk = 1'b0;
        forever #(10) tb_clk = ~tb_clk;
    end
    assign tb_clk_bar = ~tb_clk;

    //send reset signal
    initial begin
        tb_reset = 1'b1; //low clear_bar;
        Ep = 1'b0;
        Cp = 1'b0;
        #(100);
        tb_reset = 1'b0;

        //generate states
        forever begin            
            // T1 state
            Ep = 1'b1;
            Cp = 1'b0;
            #(60);

            // T2 state
            Ep = 1'b0;
            Cp = 1'b1;
            #(120);

            // X state
            Ep = 1'b0;
            Cp = 1'b0;
            #(180);
        end

    end
    assign tb_reset_bar = ~tb_reset;

    ProgramCounter test(
        .CLK_bar(tb_clk_bar),
        .CLR_bar(tb_reset_bar),
        .Cp(Cp),
        .Ep(Ep),
        .W_bus(out)
    );

endmodule
