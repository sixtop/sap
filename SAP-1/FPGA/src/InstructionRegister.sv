module InstructionRegister(
    input logic CLK,
    input logic CLR,
    input logic Li_bar,
    input logic Ei_bar,
    input logic [7:0] data_in,
    output reg [3:0] data_out,
    output reg [3:0] instr_out
    );
    
    reg [3:0] d, i;
    
    always_ff @(posedge CLK or posedge CLR) begin
        if(CLR) begin
            d <= 4'b0;
            i <= 4'b0;
        end
        else begin
            if (~Li_bar) begin
                d <= data_in[3:0];
                i <= data_in[7:4];
            end
            if (~Ei_bar) begin
                data_out <= d;
                instr_out <= i;
            end
            else begin
            	data_out <= 4'bz;
            	instr_out <= 4'bz;
            end
        end
    end
    
    
endmodule
