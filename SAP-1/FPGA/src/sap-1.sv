
module sap1 (
        input logic sap_base_clock,
        input logic sap_CleanStart_pb,         // Clean/Start switch
        input logic sap_SingleStep_pb,         // Single step switch
        input logic sap_ManualAuto_sw,         // Manual/Auto switch
    );

	//W bus
	reg [7:0] W_bus;


	//Control Word
	logic Cp,Ep,Lm_bar,CE_bar,Li_bar,Ei_bar,La_bar,Ea,Su,Eu,Lb_bar,Lo_bar;
	controller_sequencer conseq(
		//inputs from FPGA
		.base_clock      (sap_base_clock)
		.S5_CleanStart_pb(sap_CleanStart_pb),
		.S6_SingleStep_pb(sap_SingleStep_pb),
		.S7_ManualAuto_sw(sap_ManualAuto_sw),

		//input instruction bus
		.inst            (instruction_bus),

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

	ProgramCounter pc(
		.CLK_bar(CLK_bar),
		.CLR_bar(CLR_bar),
		.Cp     (Cp),
		.Ep     (Ep),
		.W_bus  (W_bus)
		);

	logic [3:0] ROM_address, ROM_data;
	ROM rom(
		.address(ROM_address)
		.data   (ROM_data)
		);

	MAR mar(
		.CLK         (CLK),
		.Lm_bar      (Lm_bar),
		.W_low_nibble(W_bus[3:0]),
		.ROM_address (ROM_address)
		);

	logic [3:0] instruction_bus;
	InstructionRegister ir(
		.CLK      (CLK),
		.CLR      (CLR),
		.Li_bar   (Li_bar),
		.Ei_bar   (Ei_bar),

		.data_in  (W_bus),
		.data_out (W_bus[3:0]),
		.instr_out(instruction_bus)
		);

endmodule