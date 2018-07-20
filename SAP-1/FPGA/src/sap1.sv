
module sap1 (
        input logic sap_base_clock,
        input logic sap_CleanStart_pb,         // Clean/Start switch
        input logic sap_SingleStep_pb,         // Single step switch
        input logic sap_ManualAuto_sw          // Manual/Auto switch
    );
    
    //Control Word
    logic Cp,Ep,Lm_bar,CE_bar,Li_bar,Ei_bar,La_bar,Ea,Su,Eu,Lb_bar,Lo_bar;
    
    //Sync Signals
    logic CLR,CLR_bar,CLK,CLK_bar;

    //instruction register
    logic [3:0] ir_data_output;
    logic [3:0] ir_inst_output;

    //Adder sub output
    logic [7:0] adder_res;

    controller_sequencer conseq(
        //inputs from FPGA
        .base_clock      (sap_base_clock),
        .S5_CleanStart_pb(sap_CleanStart_pb),
        .S6_SingleStep_pb(sap_SingleStep_pb),
        .S7_ManualAuto_sw(sap_ManualAuto_sw),

        //input instruction bus
        .instruction_input(ir_inst_output),

        //output sync signals
        .CLR             (CLR),
        .CLR_bar         (CLR_bar),
        .CLK             (CLK),
        .CLK_bar         (CLK_bar),

        //output control Word
        .Cp              (Cp),
        .Ep              (Ep),
        .Lm_bar          (Lm_bar),
        .CE_bar          (CE_bar),
        .Li_bar          (Li_bar),
        .Ei_bar          (Ei_bar),
        .La_bar          (La_bar),
        .Ea              (Ea),
        .Su              (Su),
        .Eu              (Eu),
        .Lb_bar          (Lb_bar),
        .Lo_bar          (Lo_bar)
    );

    logic [3:0] program_counter;
    ProgramCounter pc(
        .CLK_bar(CLK_bar),
        .CLR_bar(CLR_bar),
        .Cp     (Cp),
        .Ep     (Ep),
        .W_bus  (program_counter)
    );
    
    //MAR receives input from program counter and instruction register!
    logic [3:0] mar_input;
    logic [3:0] mar_rom_address;
    assign mar_input = Ep ? program_counter : ~Ei_bar ? ir_data_output : 4'hF;
    MAR mar(
        .CLK         (CLK),
        .CLR_bar     (CLR_bar),
        .Lm_bar      (Lm_bar),
        .mar_input   (mar_input),
        .mar_output  (mar_rom_address)
        );
    
    //ROM with instruction/data sequence
    logic [7:0] rom_output_data;
    ROM rom(
        .CE_bar           (CE_bar),
        .rom_input_address(mar_rom_address),
        .rom_output_data  (rom_output_data)
    );


    InstructionRegister ir(
        .CLK      (CLK),
        .CLR      (CLR),
        .Li_bar   (Li_bar),
        .Ei_bar   (Ei_bar),

        .data_in  (rom_output_data),

        .data_out (ir_data_output),
        .instr_out(ir_inst_output)
    );

    logic [7:0] acc_adder_out, accumulator_out;
    logic [7:0] accumulator_in;
    assign accumulator_in = ~CE_bar ? rom_output_data : Eu ? adder_res : 8'hFF;
    Accumulator acc(
        .CLK           (CLK),
        .CLR_bar       (CLR_bar),
        .La_bar        (La_bar),
        .Ea            (Ea),
        .data_in       (accumulator_in),
        .data_out      (accumulator_out),
        .adder_sub_out (acc_adder_out)
    );

    logic [7:0] b_register_out;
    BRegister breg(
        .CLK     (CLK),
        .CLR_bar (CLR_bar),
        .Lb_bar  (Lb_bar),
        .data_in (rom_output_data),
        .data_out(b_register_out)
    );

    
    AdderSubtracter addsub(
        .Su       (Su),
        .Eu       (Eu),
        .a_data_in(acc_adder_out),
        .b_data_in(b_register_out),
        .data_out (adder_res)
        );
    
    logic [7:0] output_register;
    OutputRegister out(
    	.Lo_bar  (Lo_bar),
    	.data_in (accumulator_out),
    	.data_out(output_register)
        );

endmodule