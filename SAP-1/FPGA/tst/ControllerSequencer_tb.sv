module controller_sequencer_testbench;
    logic tb_clk;
    reg [3:0] tb_instr;
    logic tb_ClearStart_pb;
    logic tb_SingleStep_sw;
    logic tb_ManualAuto_sw;

    initial begin
        tb_clk = 1'b0;
        tb_instr = 4'b0000; //LDA
        tb_ClearStart_pb = 1; //0-Clear, 1-Start
        tb_SingleStep_sw = 0;
        tb_ManualAuto_sw = 1; //0-manual, 1-auto
        forever #(10) tb_clk = ~tb_clk;
    end

    //simulate states
    initial begin

        //generate CLR
        #(1ms);
        tb_ClearStart_pb = 0; //clear
        #(1ms);
        tb_ClearStart_pb = 1; //clear

        #(5ms);
        tb_ManualAuto_sw = 0; //auto

        //simulate pulses for manual mode
        repeat (50) begin
            #(1ms);
            tb_SingleStep_sw = 0;
            #(1ms);
            tb_SingleStep_sw = 1;
        end
    end

    controller_sequencer #(.DebounceDelay(8)) test(
        .base_clock(tb_clk),
        .instruction_input(tb_instr),
        .S5_CleanStart_pb(tb_ClearStart_pb),
        .S6_SingleStep_pb(tb_SingleStep_sw),
        .S7_ManualAuto_sw(tb_ManualAuto_sw),

        .CLK(),
        .CLK_bar(),
        .CLR(),
        .CLR_bar(),

        .Cp(),
        .Ep(),
        .Lm_bar(),
        .CE_bar(),

        .Li_bar(),
        .Ei_bar(),
        .La_bar(),
        .Ea(),

        .Su(),
        .Eu(),
        .Lb_bar(),
        .Lo_bar()
    );

endmodule
