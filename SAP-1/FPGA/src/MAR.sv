module MAR (
		//sync signals
		input logic CLK,

		//control signals
        input logic Lm_bar,

        //input from W bus
        input wire [3:0] mar_input,

        //output to RAM
        output logic [3:0] mar_output
    );

    always_ff @ (posedge CLK) begin
        if(~Lm_bar) mar_output <= mar_input;
        else mar_output <= mar_output;
    end
    
endmodule
