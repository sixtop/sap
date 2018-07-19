/*
* This module separates and stores data/instructions from W bus.
*/
module AdderSubtracter(
    //control signals
    input logic Su,
    input logic Eu,

    //accumulator and b register input
    input wire [7:0] a_data_in,
    input wire [7:0] b_data_in,

    //data and instruction
    output reg [7:0] data_out
    );

    assign data_out  = Eu ? (Su ? a_data_in - b_data_in : a_data_in + b_data_in) : 8'bz;
    
endmodule
