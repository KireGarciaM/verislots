module ClockDivider( 
input clk, 
input reset, 
output reg sclk 
    ); 
    
reg [23:0] count;
    always@(posedge clk or posedge reset) 
        begin 
    if(reset == 1'b1) 
    begin 
    count <= 24'd0; 
    sclk <= 1'b0; 
    end 
    else 
        begin 
        if(count == 24'd10) 
        begin 
            count <= 24'd0; 
            sclk <= ~sclk; 
        end 
        begin 
        count <= count + 1; 
        end 
end 
end 
endmodule 