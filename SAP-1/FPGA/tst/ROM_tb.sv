module rom_testbench;
    logic tb_clk;
    logic CE;
    
    reg [3:0] input_address = 4'b0;
    
    initial begin
        tb_clk = 1'b0;
        forever #(10) tb_clk = ~tb_clk;
    end
    
    always_ff @ (posedge tb_clk) begin
        input_address <= input_address + 1'b1;
    end    

    //simulate states
    initial begin
        CE = 1'b1;
        #(110);

        //generate states
        forever begin
            // T1 state
            CE = 1'b0;
            #(320);
            
            CE = 1'b1;            
            #(100);
        end

    end

    ROM test(
        .ROM_address(input_address),
        .ROM_data(),
        .CE_bar(~CE)
    );

endmodule
