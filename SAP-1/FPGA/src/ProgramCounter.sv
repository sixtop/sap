module ProgramCounter(
        input logic Cp,
        input logic CLK_bar,
        input logic CLR_bar,
        input logic Ep,
        output reg [3:0] W_bus
    );

    reg [3:0] count;

    always_ff @ (posedge CLK_bar or negedge CLR_bar) begin
        if(~CLR_bar)
            count <= 0;
        else if(Cp)
            count <= count + 1'b1;
        else
            count <= count;
                
        if (Ep)
            W_bus <= count;            
        else
            W_bus <= 3'bzzz;
    end

endmodule
