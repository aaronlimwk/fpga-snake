`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:37:19 03/10/2020 
// Design Name: 
// Module Name:    seg_display 
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
module seg_display(
	input wire [3:0] digit,
	output reg [6:0] seg
);
	always @ (*) begin
		case (digit)
			4'h0:	   seg <= 7'b1000000;
			4'h1:	   seg <= 7'b1111001;
			4'h2:	   seg <= 7'b0100100;		
			4'h3:	   seg <= 7'b0110000;
			4'h4:	   seg <= 7'b0011001;
			4'h5:	   seg <= 7'b0010010;
			4'h6:	   seg <= 7'b0000010;
			4'h7:	   seg <= 7'b1111000;
			4'h8:	   seg <= 7'b0000000;
			4'h9:	   seg <= 7'b0010000;
			default: seg <= 7'b1111111;
		endcase
	end
endmodule
