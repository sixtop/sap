module RingCounter #(parameter STATES=6)(
        //sync signals
        input logic CLK,
        input logic CLR_bar,

        //T-states
        output logic [STATES-1:0] state
    );

    always_ff @ (negedge CLK or negedge CLR_bar) begin
        //reset condition
        if(~CLR_bar)
            state <= {STATES{1'b0}};
        else
            //state is 0, initialize with 000001
            if(state == {STATES{1'b0}})
                state <= {{STATES-1{1'b0}}, 1'b1};

            //rotate left
            else
                state <= {state[STATES-2:0], state[STATES-1]};
    end

endmodule