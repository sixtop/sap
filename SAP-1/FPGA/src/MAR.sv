module MAR (
		//sync signals
		input logic CLK,

		//control signals
        input logic Lm_bar,

        //input from W bus
        input wire [3:0] W_low_nibble,

        //output to RAM
        output logic [3:0] ROM_address
    );

    always_ff @ (posedge CLK) begin
        if(~Lm_bar) ROM_address <= W_low_nibble;
        else ROM_address <= ROM_address;
    end
    
endmodule
