`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:24:24 03/08/2020 
// Design Name: 
// Module Name:    score_display 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module score_display(score, hundreds, tens, ones);

input  wire [7:0] score;
output reg  [3:0] hundreds;
output reg  [3:0] tens;
output reg  [3:0] ones;

integer i;
always @ (score) begin
    hundreds = 4'd0;
    tens     = 4'd0;
    ones     = 4'd0;
    for(i = 7; i >= 0; i = i-1) begin
        if(hundreds >= 5) begin
            hundreds = hundreds + 3;
        end
        if(tens >= 5) begin
            tens = tens + 3;
        end
        if(ones >= 5) begin
            ones = ones + 3;
        end

        hundreds    = hundreds << 1;
        hundreds[0] = tens[3];
        tens        = tens << 1;
        tens[0]     = ones[3];
        ones        = ones << 1;
        ones[0]     = score[i];
    end
end
endmodule
