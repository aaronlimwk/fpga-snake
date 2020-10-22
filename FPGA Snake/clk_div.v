`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:50:39 03/03/2020 
// Design Name: 
// Module Name:    clk_div 
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
module clk_div(
	input wire clk,
	input wire rst,
	output reg fast_clk,
	output reg blink_clk
	);
	
	reg [16:0] fast_counter;
	reg [26:0] blink_counter;
	
	localparam FAST_DIV_FACTOR = 100000;    // 500 Hz
	localparam BLINK_DIV_FACTOR = 100000000; // 2 Hz

	// Fast Clock Divider
	always @ (posedge(clk) or posedge(rst)) begin
		if (rst) begin
			fast_clk <= 1'b0;
			fast_counter <= 17'b0;
		end else if (fast_counter == FAST_DIV_FACTOR - 1) begin
			fast_clk <= ~fast_clk;
			fast_counter <= 17'b0;
		end else begin
			fast_clk <= fast_clk;
			fast_counter <= fast_counter + 17'b1;
		end
	end
	
	//Blink Clock Divider
	always @ (posedge(clk) or posedge(rst)) begin
		if (rst) begin
			blink_clk <= 1'b0;
			blink_counter <= 27'b0;
		end else if (blink_counter == BLINK_DIV_FACTOR - 1) begin
			blink_clk <= ~blink_clk;
			blink_counter <= 27'b0;
		end else begin
			blink_clk <= blink_clk;
			blink_counter <=  blink_counter + 27'b1;
		end
	end
endmodule
