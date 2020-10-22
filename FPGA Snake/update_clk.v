`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:06:12 03/03/2020 
// Design Name: 
// Module Name:    update_clk 
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
module update_clk(
	input wire clk,
	input wire rst,
	output reg update
	);
	
	reg [23:0] cnt;
	localparam UPDATE_COUNT = 12500000;

	always @ (posedge(clk) or posedge(rst)) begin
		if (rst) begin
			update <= 1'b0;
			cnt <= 24'b0;
		end else if (cnt == UPDATE_COUNT) begin
			update <= 1'b1;
			cnt <= 24'b0;
		end else begin
			update <= 1'b0;
			cnt <= cnt + 24'b1;
		end
	end
endmodule
