`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:18 03/08/2020 
// Design Name: 
// Module Name:    top_snake 
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
module top_snake(
	input wire clk,
	input wire btnRst,
	input wire btnU,
	input wire btnD,
	input wire btnL,
	input wire btnR,
	output wire Hsync,
	output wire Vsync,
	output wire [2:0] vgaRed,
	output wire [2:0] vgaGreen,
	output wire [1:0] vgaBlue,
	output wire [3:0] an,
	output wire [6:0] seg
   );
	
	wire rst;
	
	wire [17:0] clk_dv_inc;
	reg  [16:0] clk_dv;
	
	wire arst_i;
	reg [1:0] arst_ff;
	
	reg clk_en;
	reg clk_en_d;
	
	reg [2:0] step_u;
	reg [2:0] step_d;
	reg [2:0] step_l;
	reg [2:0] step_r;
	
	////////////////////////
	// Asynchronous Reset //
	////////////////////////
	
	assign arst_i = btnRst;
	assign rst = arst_ff[0];
		
	always @ (posedge (clk) or posedge (arst_i)) begin
		if(arst_i) begin 
			arst_ff <= 2'b11;
		end else begin
			arst_ff <= {1'b0, arst_ff[1]};
		end
	end
	
	///////////////////////////////////
	// Timing signal of clock enable //
	///////////////////////////////////
	
	assign clk_dv_inc = clk_dv + 1;
	
	always @ (posedge (clk)) begin
		if(rst) begin
			clk_dv	 <= 0;
			clk_en	 <= 1'b0;
			clk_en_d  <= 1'b0;
		end else begin
			clk_dv 	 <= clk_dv_inc[16:0];
			clk_en 	 <= clk_dv_inc[17];
			clk_en_d  <= clk_en;
		end
	end
	
	///////////////////////////////////////////////
	// Instruction Stepping Control / Debouncing //
	///////////////////////////////////////////////
	
	always @ (posedge (clk)) begin
		if(rst) begin
			step_u[2:0] <= 0;
			step_d[2:0] <= 0;
			step_l[2:0] <= 0;
			step_r[2:0] <= 0;
		end else if(clk_en) begin
			step_u[2:0] <= {btnU, step_u[2:1]};
			step_d[2:0] <= {btnD, step_d[2:1]};
			step_l[2:0] <= {btnL, step_l[2:1]};
			step_r[2:0] <= {btnR, step_r[2:1]};
		end
	end
	
	wire up, down, left, right;
	
	debouncer up_button (
		.clk(clk),
		.clk_en_d(clk_en_d),
		.rst(rst),
		.step(step_u),
		.inst_vld(up)
	);
	
	debouncer down_button (
		.clk(clk),
		.clk_en_d(clk_en_d),
		.rst(rst),
		.step(step_d),
		.inst_vld(down)
	);
	
	debouncer left_button (
		.clk(clk),
		.clk_en_d(clk_en_d),
		.rst(rst),
		.step(step_l),
		.inst_vld(left)
	);
	
	debouncer right_button (
		.clk(clk),
		.clk_en_d(clk_en_d),
		.rst(rst),
		.step(step_r),
		.inst_vld(right)
	);
	
	//////////////////////
	// Snake Game Logic //
	//////////////////////
	
	snake voldemort(
		.clk(clk),
		.rst(rst),
		.up(up),
		.down(down),
		.left(left),
		.right(right),
		.Hsync(Hsync),
		.Vsync(Vsync),
		.vgaRed(vgaRed),
		.vgaGreen(vgaGreen),
		.vgaBlue(vgaBlue),
		.an(an),
		.seg(seg)
	);
endmodule
