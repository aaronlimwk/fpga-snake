`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:27:08 03/08/2020
// Design Name:   score_display
// Module Name:   /home/ise/CS_M152/Voldemort/score_display_TB.v
// Project Name:  FPGA_Snake
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: score_display
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module score_display_TB;

	// Inputs
	reg [7:0] score;

	// Outputs
	wire [3:0] hundreds;
	wire [3:0] tens;
	wire [3:0] ones;

	// Instantiate the Unit Under Test (UUT)
	score_display uut (
		.score(score), 
		.hundreds(hundreds), 
		.tens(tens), 
		.ones(ones)
	);

	initial begin
		// Initialize Inputs
		score = 0;

		// Wait 100 ns for global reset to finish
		#10
		
		// Add stimulus here
		score = 5;
		#10;
		score = 28;
		#10
		score = 36;
		#10;
		score = 107;
		#10;
	end
endmodule

