/*
* This module separates and stores data/instructions from W bus.
*/
module InstructionRegister(
    //sync signals
    input logic CLK,
    input logic CLR,

    //control signals
    input logic Li_bar,
    input logic Ei_bar,

    //w bus input
    input wire [7:0] data_in,

    //data and instruction
    output reg [3:0] data_out,
    output reg [3:0] instr_out
    );
    
    reg [3:0] d, i;
    
    always_ff @(posedge CLK or posedge CLR) begin
        //TODO Check CLR signal
        if(CLR) begin
            d <= 4'b0;
            i <= 4'b0;
        end
        else begin
            // Load active, store from W bus
            if (~Li_bar) begin
                d <= data_in[3:0];
                i <= data_in[7:4];
            end

            /*// Enable active, output stored data/instruction
            if (~Ei_bar) begin
                data_out <= d;
                instr_out <= i;
            end

            // Not enabled, ouput high impedance
            else begin
            	data_out <= 4'bz;
            	instr_out <= 4'bz;
            end*/
        end
    end

    assign data_out  = ~Ei_bar ? d : 4'bz;
    assign instr_out = i;
    
    
endmodule
