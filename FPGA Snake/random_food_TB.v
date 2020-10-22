`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:35:47 03/09/2020
// Design Name:   random_food
// Module Name:   /home/ise/CS_M152/Voldemort/random_food_TB.v
// Project Name:  FPGA_Snake
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: random_food
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module random_food_TB;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire [9:0] rand_x;
	wire [8:0] rand_y;

	// Instantiate the Unit Under Test (UUT)
	random_food uut (
		.clk(clk), 
		.rst(rst), 
		.rand_x(rand_x), 
		.rand_y(rand_y)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
      rst = 0;
		// Add stimulus here

	end
      
endmodule

