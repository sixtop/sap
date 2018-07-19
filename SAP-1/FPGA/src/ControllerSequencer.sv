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

    //Control Matrix
    ControlMatrix cm(
        .T1(CurrentState[0]),
        .T2(CurrentState[1]),
        .T3(CurrentState[2]),
        .T4(CurrentState[3]),
        .T5(CurrentState[4]),
        .T6(CurrentState[5]),

        .LDA(LDA),
        .ADD(ADD),
        .SUB(SUB),
        .OUT(OUT),

        .Cp    (Cp),
        .Ep    (Ep),
        .Lm_bar(Lm_bar),
        .CE_bar(CE_bar),

        .Li_bar(Li_bar),
        .Ei_bar(Ei_bar),
        .La_bar(La_bar),
        .Ea    (Ea),

        .Su    (Su),
        .Eu    (Eu),
        .Lb_bar(Lb_bar),
        .Lo_bar(Lo_bar)
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

module ControlMatrix(
    input logic LDA,
    input logic ADD,
    input logic SUB,
    input logic OUT,

    input logic T1,
    input logic T2,
    input logic T3,
    input logic T4,
    input logic T5,
    input logic T6,

    output logic Cp,
    output logic Ep,
    output logic Lm_bar,
    output logic CE_bar,

    output logic Li_bar,
    output logic Ei_bar,
    output logic La_bar,
    output logic Ea,

    output logic Su,
    output logic Eu,
    output logic Lb_bar,
    output logic Lo_bar
    );

    assign Cp     = T2;
    assign Ep     = T1;
    assign Lm_bar = ~(T1 | (LDA&T4) | (ADD&T4) | (SUB&T4));
    assign CE_bar = ~(T3 | (LDA&T5) | (ADD&T5) | (SUB&T5));

    assign Li_bar = ~T3;
    assign Ei_bar = ~((LDA&T4) | (ADD&T4) | (SUB&T4));
    assign La_bar = ~((LDA&T5) | (ADD&T6) | (SUB&T6));
    assign Ea     = OUT&T4;

    assign Su     = SUB&T6;
    assign Eu     =  ((ADD&T6) | (SUB&T6));
    assign Lb_bar = ~((ADD&T5) | (SUB&T5));
    assign Lo_bar = ~(OUT&T4);

endmodule
