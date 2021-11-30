`timescale 1ns / 1ps
module SlotMachineMaster(
    input data_in,
    input clk,
    input reset,
    output [3:0] Anode_Activate, // anode signals of the 7-segment LED display
    output [6:0] LED_out
);

    wire [2:0] tmp;
    wire [2:0] tmp1;
    wire [2:0] tmp2;
    wire [2:0] tmp3;
    
    wire sclk;
    
    ClockDivider CD1(clk, reset, sclk  );
    SubSlotMachine SSM1(data_in, sclk, reset, tmp, tmp1, tmp2, tmp3);
    Seven_segment_LED_Display_Controller LCD1 (clk, reset, tmp, tmp1,tmp2, tmp3, Anode_Activate, LED_out);


endmodule

