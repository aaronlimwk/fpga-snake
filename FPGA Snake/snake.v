`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:49:24 03/03/2020 
// Design Name: 
// Module Name:    snake 
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
module snake(
	input wire clk,             // board clock: 100 MHz
	input wire rst,             // reset button
	input wire up,	   			 // up button
	input wire down,				 // bottom button
	input wire left,				 // left button
	input wire right,				 // right button
	output wire Hsync,          // horizontal sync output
	output wire Vsync,          // vertical sync output
	output wire [2:0] vgaRed,   // 4-bit VGA red output
	output wire [2:0] vgaGreen, // 4-bit VGA green output
	output wire [1:0] vgaBlue,  // 4-bit VGA blue output
	output reg  [3:0] an,
	output reg  [6:0] seg
	);
	
	///////////////////
	// Clock Divider //
	///////////////////
	
	wire fast_clk, blink_clk;
	
	clk_div clock_div(
		.clk(clk),
		.rst(rst),
		.fast_clk(fast_clk),
		.blink_clk(blink_clk)
	);
	
	////////////////
	// Directions //
	////////////////
	
	localparam STAY  = 3'b000;
	localparam UP    = 3'b001;
	localparam DOWN  = 3'b010;
	localparam RIGHT = 3'b011;
	localparam LEFT  = 3'b100;
	
	/////////////////////////
	// Designate direction //
	/////////////////////////
	
	reg [2:0] dir;
	
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			dir <= STAY;
		end else begin
			if (up)
				dir <= (dir != DOWN) ? UP : dir;
			else if (down)
				dir <= (dir != UP) ? DOWN : dir;
			else if (right)
				dir <= (dir != LEFT) ? RIGHT : dir;
			else if (left)
				dir <= (dir != RIGHT) ? LEFT : dir;
			else
				dir <= dir;
		end
	end
	
	////////////////////////////////////
    // Generate a 25 MHz pixel strobe //
	////////////////////////////////////
	
	reg [15:0] cnt;
	reg pix_stb;
	always @(posedge clk)
	  {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000
	
	///////////////////
	// Animate Clock //
	///////////////////
	
	wire update;
	
	update_clk update_clk(
		.clk(clk),
		.rst(rst),
		.update(update)
	);
	
	wire [9:0] x;  	 // current pixel x position: 10-bit value: 0-1023
	wire [8:0] y;  	 // current pixel y position: 10-bit value: 0-1023
	wire display_area; // high when coordinates are within active pixels

	/////////////////
	// VGA Display //
	/////////////////

	vga640x480 display (
		.i_clk(clk),
		.i_pix_stb(pix_stb),
		.i_rst(rst),
		.o_hs(Hsync), 
		.o_vs(Vsync),
		.o_x(x), 
		.o_y(y)
	);

	////////////////////////////////////
	// PSEUDO RANDOM NUMBER GENERATOR //
	////////////////////////////////////
	
	wire [9:0] rand_x;
	wire [8:0] rand_y;
	
	random_food random_apple (
		.clk(clk),
		.rst(rst),
		.rand_x(rand_x),
		.rand_y(rand_y)
	);
	
	/////////////////////
	// SNAKE ANIMATION //
	/////////////////////

	reg lose, win;
	reg [6:0] size;
	reg [9:0] apple_x;
	reg [8:0] apple_y;
	reg [9:0] snake_x[0:99];
	reg [8:0] snake_y[0:99];
	reg [99:0] snake_hit;

	integer i;
	integer j;

	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			snake_x[0] <= 40;
			snake_y[0] <= 40;
			apple_x <= 320;
			apple_y <= 240;
			size <= 1;
			lose <= 0;
			win <= 0;
			for (i = 1; i < 100; i = i + 1)
			begin
				snake_x[i] <= 1000;
				snake_y[i] <= 500;
			end
		end else if ((~lose) && (~win)) begin
			if (update) begin
				for (i = 1; i < 100; i = i + 1)
				begin
					if (size > i) begin
						snake_x[i] <= snake_x[i - 1];
						snake_y[i] <= snake_y[i - 1];
					end
				end
				case (dir)
					UP:	 snake_y[0] <= snake_y[0] - 10;
					DOWN:  snake_y[0] <= snake_y[0] + 10;
					RIGHT: snake_x[0] <= snake_x[0] + 10;
					LEFT:  snake_x[0] <= snake_x[0] - 10;
				endcase
			end else begin
				if ((snake_x[0] == apple_x) && (snake_y[0] == apple_y)) begin
					apple_x <= rand_x;
					apple_y <= rand_y;
					size <= size + 1;
				end else if ((snake_x[0] == 10) || (snake_x[0] == 620) || (snake_y[0] == 10) || (snake_y[0] == 460)) begin
					lose <= 1'b1;
				end else if ((|snake_hit[99:1]) && (snake_hit[0])) begin
					lose <= 1'b1;
				end else if (size == 100) begin
					win <= 1'b1;
				end
			end
		end
	end

	wire apple, border, border_left, border_right, border_top, border_bottom;
	
	assign border_left   = ((x > 0) && (x < 20) && (y > 0) && (y < 480)) ? 1 : 0;
	assign border_right  = ((x > 620) && (x < 640) && (y > 0) && (y < 480)) ? 1 : 0;
	assign border_top    = ((y > 0) && (y < 20) && (x > 0) && (x < 640)) ? 1 : 0;
	assign border_bottom = ((y > 460) && (y < 480) && (x > 0) && (x < 640)) ? 1 : 0;
	
	assign border = border_left | border_right | border_top | border_bottom;
	assign apple = (x > apple_x) && (x < (apple_x + 10)) && (y > apple_y) && (y < (apple_y + 10));
	
	always @ (*) begin
		for (j = 0; j < 100; j = j + 1)
		begin
			snake_hit[j] = (x > snake_x[j]) && (x < (snake_x[j] + 10)) && (y > snake_y[j]) && (y < (snake_y[j] + 10));
		end
	end

	reg R, G, B;
	
	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			R <= 1'b0;
			G <= 1'b0;
			B <= 1'b0;
		end else if (lose) begin
			R <= ((x > 0) && (x < 640) && (y > 0) && (y < 480)) ? 1 : 0;
			G <= 1'b0;
			B <= 1'b0;
		end else if (win) begin
			R <= 1'b0;
			G <= ((x > 0) && (x < 640) && (y > 0) && (y < 480)) ? 1 : 0;
			B <= 1'b0;
		end else begin
			R <= apple;
			G <= |snake_hit;
			B <= border;
		end
	end
	
	assign vgaRed   = {3{R}};
	assign vgaGreen = {3{G}};
	assign vgaBlue  = {2{B}};
	
	//////////////////////
	// SCORE CONVERSION //
	//////////////////////
	
	reg [3:0] thousands = 4'b0000;
	wire [3:0] hundreds;
	wire [3:0] tens;
	wire [3:0] ones;
	
	score_display score_display(
		.score(size),
		.hundreds(hundreds),
		.tens(tens),
		.ones(ones)
	);
	
	////////////////////////
	// SEGMENT CONVERSION //
	////////////////////////
	
	wire [6:0] seg_dig_1;
	wire [6:0] seg_dig_2;
	wire [6:0] seg_dig_3;
	wire [6:0] seg_dig_4;

	seg_display seg_display_dig_1(
		.digit(thousands),
		.seg(seg_dig_1)
	);

	seg_display seg_display_dig_2(
		.digit(hundreds),
		.seg(seg_dig_2)
	);

	seg_display seg_display_dig_3(
		.digit(tens),
		.seg(seg_dig_3)
	);

	seg_display seg_display_dig_4(
		.digit(ones),
		.seg(seg_dig_4)
	);
	
	/////////////////////
	// SEGMENT DISPLAY //
	/////////////////////
	
	reg [1:0] state;
	
	always @ (posedge fast_clk or posedge rst) begin
		if (rst) begin
			state <= 2'b00;
			an 	<= 4'b0000;
			seg 	<= 7'b1000000;
		end else if (lose) begin
			case (state)
				2'b00:begin
							an  <= 4'b0111;
							if (blink_clk) begin
								seg <= 7'b0001110; // F
							end else begin
								seg <= seg_dig_1;
							end
						 end
				2'b01: begin
							an  <= 4'b1011;
							if (blink_clk) begin
								seg <= 7'b0001000; // A
							end else begin
								seg <= seg_dig_2;
							end
						 end
				2'b10: begin
							an  <= 4'b1101;
							if (blink_clk) begin
								seg <= 7'b1111001; // I
							end else begin
								seg <= seg_dig_3;
							end
						 end
				2'b11: begin
							an  <= 4'b1110;
							if (blink_clk) begin
								seg <= 7'b1000111; // L
							end else begin
								seg <= seg_dig_4;
							end
						 end
			endcase
			state <= state + 1'b1;
		end else if (win) begin
			case (state)
				2'b00: begin
							an  <= 4'b0111;
							if (blink_clk) begin
								seg <= 7'b1000000; // D
							end else begin
								seg <= seg_dig_1;
							end
						 end
				2'b01: begin
							an  <= 4'b1011;
							if (blink_clk) begin
								seg <= 7'b1000001; // U
							end else begin
								seg <= seg_dig_2;
							end
						 end
				2'b10: begin
							an  <= 4'b1101;
							if (blink_clk) begin
								seg <= 7'b0000000; // B
							end else begin
								seg <= seg_dig_3;
							end
						 end
				2'b11: begin
							an  <= 4'b1110;
							if (blink_clk) begin
								seg <= 7'b0010010; // S
							end else begin
								seg <= seg_dig_4;
							end
						 end
			endcase
			state <= state + 1'b1;
		end else begin
			case (state)
				2'b00: begin
							an  <= 4'b0111;
							seg <= seg_dig_1;
						 end
				2'b01: begin
							an  <= 4'b1011;
							seg <= seg_dig_2;
						 end
				2'b10: begin
							an  <= 4'b1101;
							seg <= seg_dig_3;
						 end
				2'b11: begin
							an  <= 4'b1110;
							seg <= seg_dig_4;
						 end
			endcase
			state <= state + 1;
		end
	end
	
endmodule
