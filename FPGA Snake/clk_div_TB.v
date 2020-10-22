`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   02:46:39 03/19/2020
// Design Name:   clk_div
// Module Name:   /home/ise/CS_M152/Voldemort/clk_div_TB.v
// Project Name:  FPGA_Snake
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clk_div
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module clk_div_TB;

	// Inputs
	reg clk;
	reg rst;

	// Outputs
	wire fast_clk;
	wire blink_clk;

	// Instantiate the Unit Under Test (UUT)
	clk_div uut (
		.clk(clk), 
		.rst(rst), 
		.fast_clk(fast_clk), 
		.blink_clk(blink_clk)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		rst = 0;
	end
      
endmodule

