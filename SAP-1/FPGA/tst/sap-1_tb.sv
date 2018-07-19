module sap1_testbench;
    logic tb_clk;
    logic tb_ClearStart_pb;
    logic tb_SingleStep_sw;
    logic tb_ManualAuto_sw;

    initial begin
        tb_clk = 1'b0;        
        forever #(10) tb_clk = ~tb_clk;
    end

    initial begin
        tb_ClearStart_pb = 1; //0-Clear, 1-Start
        tb_SingleStep_sw = 0; //single step pulse
        tb_ManualAuto_sw = 1; //0-manual, 1-auto
        #(1ms);

        tb_ClearStart_pb = 0; //clear
        #(1ms);

        tb_ClearStart_pb = 1; //clear
        #(5ms);

        $stop();


        //simulate pulses for manual mode
        /*tb_ManualAuto_sw = 0; //manual
        repeat (50) begin
            #(1ms);
            tb_SingleStep_sw = 0;
            #(1ms);
            tb_SingleStep_sw = 1;
        end

        #(5ms);
        $stop();*/
    end

    sap1 test(
        .sap_base_clock(tb_clk),
        .sap_CleanStart_pb(tb_ClearStart_pb),
        .sap_ManualAuto_sw(tb_ManualAuto_sw),
        .sap_SingleStep_pb(tb_SingleStep_sw)
        );

endmodule
