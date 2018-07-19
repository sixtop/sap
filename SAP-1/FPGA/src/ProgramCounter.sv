module ProgramCounter(
        //sync signals
        input logic CLK_bar,
        input logic CLR_bar,

        //control signals
        input logic Cp,        
        input logic Ep,

        //W bus output
        output reg [3:0] W_bus
    );

    reg [3:0] count;

    always_ff @ (posedge CLK_bar or negedge CLR_bar) begin

        //clear condition
        if(~CLR_bar)
            count <= 0;

        //increment program counter
        else if(Cp)
            count <= count + 1'b1;

        //stays the same
        else
            count <= count;
    end

    always @(*) begin
    	//Enable output
        if (Ep)
            W_bus <= count; 

        //high impedance to the W bus           
        else
            W_bus <= 4'bzzzz;
    end

endmodule
