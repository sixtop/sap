/*
* This module separates and stores data/instructions from W bus.
*/
module Accumulator(
    //sync signals
    input logic CLK,
    input logic CLR_bar,

    //control signals
    input logic La_bar,
    input logic Ea,

    //w bus input
    input wire [7:0] data_in,

    //accoumulator contents
    output reg [7:0] data_out,
    output reg [7:0] adder_sub_out
    );
    
    reg [7:0] acc;
    
    always_ff @(posedge CLK or negedge CLR_bar) begin
        //TODO Check CLR signal
        if(~CLR_bar) begin
            acc <= 8'b0;
        end
        else begin
            // Load active, store from W bus
            if (~La_bar) begin
                acc <= data_in;
            end
        end
    end

    assign data_out      = Ea ? acc : 8'hFF;
    assign adder_sub_out = acc;
    
endmodule
