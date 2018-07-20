/*
 * This module separates and stores data/instructions from W bus.
 */
module OutputRegister(
        //control signals
        input logic Lo_bar,

        //in/out
        input wire [7:0] data_in,
        output reg [7:0] data_out
    );

    assign data_out = ~Lo_bar ? data_in : 8'hFF;

endmodule
