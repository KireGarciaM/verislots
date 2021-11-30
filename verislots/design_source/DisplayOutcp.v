module Seven_segment_LED_Display_Controller(
    input clock, // 100 Mhz clock source on Basys 3 FPGA
    input reset, // reset
    input [2:0] num_in,
    input [2:0] num_in1,
    input [2:0] num_in2,
    input [2:0] num_in3,
    output reg [3:0] Anode_Activate, // anode signals of the 7-segment LED display
    output reg [6:0] LED_out// cathode patterns of the 7-segment LED display
    );
    reg [2:0] tmp;
    reg [2:0] tmp1;
    reg [2:0] tmp2;
    reg [2:0] tmp3;
    reg [26:0] one_second_counter; // counter for generating 1 second clock enable
    wire one_second_enable;// one second enable for counting numbers
    reg [15:0] displayed_number; // counting number to be displayed
    reg [3:0] LED_BCD;
    reg [19:0] refresh_counter; // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
             // the first 2 MSB bits for creating 4 LED-activating signals with 2.6ms digit period
    wire [1:0] LED_activating_counter; 
                 // count     0    ->  1  ->  2  ->  3
              // activates    LED1    LED2   LED3   LED4
             // and repeat
    always @(*)
    begin
        tmp <= num_in;
        tmp1 <= num_in1;
        tmp2 <= num_in2;
        tmp3 <= num_in3;
    end         
    
    always @(posedge clock or posedge reset)
    begin
        if(reset==1)
           one_second_counter <= 0;
        else begin
            if(one_second_counter>=99999999) 
                 one_second_counter <= 0;
            else
                one_second_counter <= one_second_counter + 1;
        end
    end 
    assign one_second_enable = (one_second_counter==99999999)?1:0;
    always @(posedge clock or posedge reset)
    begin 
        if(reset==1)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end 
    assign LED_activating_counter = refresh_counter[19:18];
    // anode activating signals for 4 LEDs, digit period of 2.6ms
    // decoder to generate anode signals 
    always @(*)
    begin
        case(LED_activating_counter)
        2'b00: begin
            Anode_Activate = 4'b0111; 
            // activate LED1 and Deactivate LED2, LED3, LED4
            LED_BCD = tmp2;
            // the first digit of the 16-bit number
              end
        2'b01: begin
            Anode_Activate = 4'b1011; 
            // activate LED2 and Deactivate LED1, LED3, LED4
            LED_BCD = tmp1;
            // the second digit of the 16-bit number
              end
        2'b10: begin
            Anode_Activate = 4'b1101; 
            // activate LED3 and Deactivate LED2, LED1, LED4
            LED_BCD = tmp;
            // the third digit of the 16-bit number
                end
        2'b11: begin
            Anode_Activate = 4'b1110; 
            // activate LED4 and Deactivate LED2, LED3, LED1
            LED_BCD = tmp3;
            // the fourth digit of the 16-bit number    
               end
        endcase
    end
    // Cathode patterns of the 7-segment LED display 
    always @(*)
    begin
        case(LED_BCD)
       0: LED_out = 7'b0000001; // "0"     
       1: LED_out = 7'b1001111; // "1" 
       2: LED_out = 7'b0010010; // "2" 
       3: LED_out = 7'b0000110; // "3" 
       4: LED_out = 7'b1001100; // "4" 
       5: LED_out = 7'b0100100; // "5" 
       6: LED_out = 7'b0100000; // "6" 
       7: LED_out = 7'b0001111; // "7" 
       8: LED_out = 7'b0000000; // "8"     
       9: LED_out = 7'b0000100; // "9" 
       default: LED_out = 7'b1010001; // "0"
        endcase
    end
 endmodule
 
 