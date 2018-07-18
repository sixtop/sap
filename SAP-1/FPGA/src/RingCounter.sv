module RingCounter(
    input logic CLK,
    input logic CLR_bar,
    output logic [5:0] state
    );
    
    always_ff @ (negedge CLK or negedge CLR_bar) begin
        if(~CLR_bar)
            state <= 6'b0;
        else
            if(state == 6'b0) 
            	state <= 6'b000001;
            else
            	state <= {state[4:0], state[5]};
    end
    
endmodule