module MAR (
	input logic CLK,
        input logic load,
        input logic [3:0] D,
        output logic [3:0] Q
    );

    always_ff @ (posedge CLK) begin
        if(load)
            Q <= D;
    end
    
endmodule
