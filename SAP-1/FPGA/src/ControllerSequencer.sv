module controller_sequencer(
        input logic S5_CleanStart_pb,         // Clean/Start switch
        input logic S6_SingleStep_pb,         // Single step switch
        input logic S7_ManualAuto_sw,         // Manual/Auto switch

        //Instruction bus
        input logic [3:0] inst,

        //System clear signal
        output logic CLR,
        output logic CLR_bar,

        //Base and system clock
        input logic base_clock,
        output logic CLK,
        output logic CLK_bar,

        /*
         * Control Word
         */
        output logic Cp,        // Increment PC
        output logic Ep,        // Enable PC output
        output logic Lm_bar,    // Latch lower W bus nibble on MAR
        output logic CE_bar,    // RAM chip enable

        output logic Li_bar,    // Latch W bus word on IR
        output logic Ei_bar,    // Enable IR output
        output logic La_bar,    // Latch W bus word on A
        output logic Ea,        // Enable A output

        output logic Su,        // Add or subtract flag
        output logic Eu,        // Enable Adder/subtracter output
        output logic Lb_bar,    // Latch W bus word on B
        output logic Lo_bar     // Latch W bus word on OUT
    );

    parameter NUM_STATES = 6;
    parameter DebounceDelay = 8;

    //Ring counter
    reg [NUM_STATES-1:0] CurrentState;
    RingCounter #(.STATES(NUM_STATES)) ring_counter(
        .CLK(CLK),
        .CLR_bar(CLR_bar),
        .state(CurrentState)
    );

    //Clear/Start
    logic S5_deb;
    Debouncer #(.WIDTH(DebounceDelay)) db1(
        .clk(base_clock),
        .clr(1'b1),
        .PushButton(~S5_CleanStart_pb),
        .PB_down(),
        .PB_state(S5_deb),
        .PB_up()
        );
    assign CLR = S5_deb;
    assign CLR_bar = ~CLR;
    
    //Single step debouncer
    logic S6_deb;
    Debouncer #(.WIDTH(DebounceDelay)) db2(
        .clk(base_clock),
        .clr(CLR_bar),
        .PushButton(S6_SingleStep_pb),
        .PB_down(),
        .PB_state(S6_deb),
        .PB_up()
        );
    
    //Manual/Auto debouncer
    logic S7_deb;
    Debouncer #(.WIDTH(DebounceDelay)) db3(
        .clk(base_clock),
        .clr(CLR_bar),
        .PushButton(S7_ManualAuto_sw),
        .PB_down(),
        .PB_state(S7_deb),
        .PB_up()
        );


    //Instruction Decoder
    logic LDA, ADD, SUB, OUT, HLT;
    InstructionDecoder id(
        .inst(inst),
        .ADD(ADD),
        .HLT(HLT),
        .LDA(LDA),
        .OUT(OUT),
        .SUB(SUB)        
        );
    
    //System clock
    assign CLK_manual = ~HLT & S6_deb     & ~S7_deb; // not halted & pulse on S6 & manual
    assign CLK_auto   = ~HLT & base_clock &  S7_deb; // not halted & clock & auto
    assign CLK = CLK_manual | CLK_auto;
    assign CLK_bar = ~CLK;
    
endmodule

module InstructionDecoder(
	input logic [3:0] inst,
	output logic LDA,
	output logic ADD,
	output logic SUB,
	output logic OUT,
	output logic HLT
    );
    
    assign LDA = inst == 4'b0000;
    assign ADD = inst == 4'b0001;
    assign SUB = inst == 4'b0010;
    assign OUT = inst == 4'b1110;
    assign HLT = inst == 4'b1111;

endmodule