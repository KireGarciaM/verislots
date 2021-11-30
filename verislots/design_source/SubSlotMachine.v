`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2021 01:36:20 AM
// Design Name: 
// Module Name: SubSlotMachine
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SubSlotMachine(
    input data_in,
    input clk,
    input reset,
    output reg[2:0] tmp,
    output reg[2:0] tmp1,
    output reg[2:0] tmp2,
    output reg[2:0] tmp3
    );

    reg [2:0] current_state;
    reg [2:0] next_state;
    reg [2:0] save_state;
    
    reg[2:0] num;
    reg[2:0] num1;
    reg[2:0] num2;
    
    integer n = 1;
    
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;
    parameter S5 = 3'b101;

always @ (posedge clk)
begin    
    num = $random(n);
    num1 = $random(n);
    num2 = $random(n);
end
    
always @ (posedge clk)
    begin
        if (reset == 1'b1) begin
            current_state <=S0;
            end
        else
            // ADD DELAY?
            current_state <= next_state;
end

always @ ( current_state or data_in or save_state or tmp or tmp1 or tmp2 or tmp3)
    begin
        case (current_state)
            S0: begin //State 0  //Random Numbers ALL
                    tmp2 <= num2;
                    tmp1 <= num1;
                    tmp <= num;
                if (data_in == 1'b0) begin
                    next_state = S0; // lever zero = loops in
                    end
                else
                    next_state = S1; // lever one = move to state 1
                end
            S1: begin // State 1 // choose static random 1XX -> move on regardless
                tmp1 <= num1;
                tmp <= num;
                
                if (data_in == 1'b0) begin
                    save_state = current_state;
                    next_state = S5; // zero = move to state 5
                    end          
                else
                    next_state = S2; // one = continue
                end

            S2: begin //State 2 // choose static random 11X -> move on regardless
                tmp <=num;
                if (data_in == 1'b0) begin
                    save_state = current_state;
                    next_state = S5; // zero = not valid sequence move to State 0
                    end
                else
                    next_state = S3; // one = move to State 3
                end
            S3: begin // State 3 // choose static random 111 -> move on regardless
                // Keep all digit static
                if (data_in == 1'b0) begin
                    save_state = current_state;
                    next_state = S5; // zero = move to State 5
                    end
                else
                    next_state = S4; // one = move to state 1, could be the start of a sequence
                end
            S4: begin //State 4 if here that means there is a jackpot?
                if(tmp == tmp2 && tmp2 == tmp1)
                        tmp3 = 5;               
                else
                    tmp3 = 0;
               if (data_in == 1'b1)
                    next_state = S4;
               else
                     next_state = S0; // Zero = move to state 0, start over
                end
            S5: begin // pause?
                if (data_in == 1'b0)
                    next_state = S5; // Zero = move to state 0, start over
                else
                    next_state = save_state ;// one = could be start of new sequence, move to State 1
                end
            endcase
end

endmodule
