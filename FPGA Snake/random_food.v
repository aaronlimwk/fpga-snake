`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:04:46 03/09/2020 
// Design Name: 
// Module Name:    random_food 
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
module random_food(
	input wire clk,
	input wire rst,
	output wire [9:0] rand_x,
	output wire [8:0] rand_y
   );

	reg [6:0] step_x;
	reg [6:0] step_y;
	reg [9:0] temp_x;
	reg [8:0] temp_y;

	assign rand_x = (temp_x < 20) ? 20 : temp_x;
	assign rand_y = (temp_y < 20) ? 20 : temp_y;

	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			temp_x <= 300;
			temp_y <= 200;
			step_x <= 30;
			step_y <= 70;
		end else begin
			step_x <= (step_x + 10) % 100;
			step_y <= (step_y + 10) % 100;
			temp_x <= (temp_x + step_x) % 620;
			temp_y <= (temp_y + step_y) % 460;
		end
	end
endmodule
