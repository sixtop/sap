module instruction_register_testbench;
    logic tb_clk;
    logic tb_clr;
    logic Li, Ei;
    
    reg [7:0] data_input = 7'b0;
    
    initial begin
        tb_clk = 1'b0;
        tb_clr = 1'b1;
        forever #(10) tb_clk = ~tb_clk;
    end
    
    always_ff @ (posedge tb_clk) begin
        data_input <= data_input + 1'b1;
    end    

    //simulate states
    initial begin
        #(110);
        tb_clr = 1'b0;

        //generate states
        forever begin
            // T1 state
            Li = 1;
            Ei = 1;
            #(100);
            
            Li = 0;
            Ei = 1;
            #(100);
            
            Li = 1;
            Ei = 0;
            #(100);

        end

    end

    InstructionRegister test(
        .CLK(tb_clk),
        .CLR(tb_clr),
        .data_in(data_input),
        .data_out(),
        .Ei_bar(Ei),
        .Li_bar(Li),
        .instr_out()
    );

endmodule
