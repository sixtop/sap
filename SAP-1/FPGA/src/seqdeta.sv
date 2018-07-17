
//detect 1101 with a moore machine
module seqdeta (
        input wire clk,
        input wire clr,
        input wire din,
        output reg dout);

    //states
    reg[2:0] present_state, next_state;
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;

    always @ (posedge clk or negedge clr) begin
        if (clr == 0)
            present_state <= S0;
        else
            present_state <= next_state;
    end

    always @ (*) begin
        case(present_state)
            S0: if(din == 1)
                    next_state <= S1;
                else
                    next_state <= S0;

            S1: if(din == 1)
                    next_state <= S2;
                else
                    next_state <= S0;

            S2: if(din == 0)
                    next_state <= S3;
                else
                    next_state <= S2;

            S3: if(din == 1)
                    next_state <= S4;
                else
                    next_state <= S0;

            S4: if(din == 0)
                    next_state <= S0;
                else
                    next_state <= S2;

            default next_state <= S0;
        endcase
    end
    
    always @ (*) begin
        if(present_state == S4)
            dout = 1;
        else
            dout = 0;
    end        

endmodule