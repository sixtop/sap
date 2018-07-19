/*
* This module separates and stores data/instructions from W bus.
*/
module BRegister(
    //sync signals
    input logic CLK,
    input logic CLR_bar,

    //control signals
    input logic Lb_bar,

    //w bus input
    input wire [7:0] data_in,

    //data and instruction
    output reg [7:0] data_out
    );
    
    reg [7:0] B;
    
    always_ff @(posedge CLK or negedge CLR_bar) begin
        //TODO Check CLR signal
        if(~CLR_bar) begin
            B <= 8'b0;
        end
        else begin
            // Load active, store from W bus
            if (~Lb_bar) begin
                B <= data_in;
            end
        end
    end

    assign data_out  = B;
    
endmodule
