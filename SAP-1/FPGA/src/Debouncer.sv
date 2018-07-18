module debouncer(
        input logic clk,
        input logic PushButton,
        output reg PB_state
    );

    initial begin
        PB_state = 1'b0;
    end

    reg PB_sync_0 = 1'b1;
    reg PB_sync_1 = 1'b1;
    always @(posedge clk) PB_sync_0 <= ~PushButton;  // invert PB to make PB_sync_0 active high
    always @(posedge clk) PB_sync_1 <= PB_sync_0;

    reg [7:0] PB_cnt = 7'b0;

    always @(posedge clk) begin
        if(PB_sync_1) begin
            PB_cnt <= 0;
            PB_state <= 0;
        end
        else
        begin
            PB_cnt <= PB_cnt + 1'b1;
            if(PB_cnt == 8'hff) PB_state <= ~PB_state;
        end
    end

endmodule