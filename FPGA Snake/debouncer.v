`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:54:50 03/03/2020 
// Design Name: 
// Module Name:    debouncer 
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
module debouncer(
	input wire       clk,
	input wire       clk_en_d,
	input wire       rst,
	input wire [2:0] step,
	output reg       inst_vld
   );

	wire is_btn_posedge;
	assign is_btn_posedge = ~ step[0] & step[1];
	always @ (posedge clk) begin
		if (rst)
			inst_vld <= 1'b0;
		else if  (clk_en_d)
			inst_vld <= is_btn_posedge;
	end
endmodule
