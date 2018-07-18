module Debouncer #(parameter WIDTH=15)(
	input logic clk,
        input logic clr,
        input logic PushButton,
        output reg PB_state,
        output logic PB_down,
        output logic PB_up
    );

    reg PB_sync_0;
    reg PB_sync_1;
    always @(posedge clk) PB_sync_0 <= ~PushButton;  // invert PB to make PB_sync_0 active high
    always @(posedge clk) PB_sync_1 <= PB_sync_0;

    reg [WIDTH-1:0] PB_cnt;

    always @(posedge clk or negedge clr) begin

    	//reset signals
        if(~clr)begin
            PB_sync_0 = 1'b1;
            PB_sync_1 = 1'b1;            
            PB_state = 1'b0;
            PB_cnt = {WIDTH{1'b0}};
        end

        else begin            
            if(PB_sync_1) begin //PB is depressed
                PB_cnt <= 1'b0;
                PB_state <= 1'b0;
            end
            else begin //PB is pressed
                if(PB_cnt == {WIDTH{1'b1}}) PB_state <= 1'b1;
                else PB_cnt <= PB_cnt + 1'b1;
            end
        end
    end

    assign PB_down = PB_cnt == {WIDTH{1'b1}} & ~PB_state & ~PB_sync_1;
    assign PB_up =   PB_cnt == {WIDTH{1'b1}} &  PB_state &  PB_sync_1;

endmodule