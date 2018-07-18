module RingCounter #(parameter STATES=6)(
        input logic CLK,
        input logic CLR_bar,
        output logic [STATES-1:0] state
    );

    always_ff @ (negedge CLK or negedge CLR_bar) begin
        if(~CLR_bar)
            state <= {STATES{1'b0}};
        else
            if(state == {STATES{1'b0}})
                state <= {{STATES-1{1'b0}}, 1'b1};
            else
                state <= {state[STATES-2:0], state[STATES-1]};
    end

endmodule