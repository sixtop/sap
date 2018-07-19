module MAR (
		//sync signals
		input logic CLK,
		input logic CLR_bar,

		//control signals
        input logic Lm_bar,

        //input from W bus
        input wire [3:0] mar_input,

        //output to RAM
        output logic [3:0] mar_output
    );

    always_ff @ (posedge CLK or negedge CLR_bar) begin
    	if(~CLR_bar) mar_output <= 4'bz;
    	else begin
	        if(~Lm_bar) mar_output <= mar_input;
	        else mar_output <= mar_output;
	end
    end
    
endmodule