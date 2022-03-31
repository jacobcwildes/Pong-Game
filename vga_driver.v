//CREATED BY DYLLON DUNTON AND JACOB WILDES
//ADAPTED FROM https://github.com/dominic-meads/Quartus-Projects
//LAST UPDATED 12/02/21


//THIS MODULE SYNCS TOGETHER THE FPGA BOARD AND THE EXTERNAL MONITOR AND ALLOWS US TO CHANGE PIXEL COLORS

module vgaDriver(
	input clk, // 25mHz clock is needed for the VGADRIVER
	input rst, // The reset will turn off the connection to the VGA DRIVER
	input [3:0] i_r, //red color channel coming from colorZones.v
	input [3:0] i_g, //green color channel coming from colorZones.v
	input [3:0] i_b, //blue color channel coming from colorZones.v
	output vsync, //Vertical Sync
	output hsync, //Horizontal Sync
	output [3:0] o_r, //red color channel output
	output [3:0] o_g, //green color channel output
	output [3:0] o_b, //blue color channel output
	output [9:0] xcount, //keeps track of where current positions is for horizontal
	output [9:0] ycount //keeps track of where current positions is for vertical
);

	//REGISTERS TO HOLD HORIZONTAL AND VERTICAL POSITION
	reg [9:0] counter_x = 0; 
	reg [9:0] counter_y = 0;	
	
	//DECLARE CONSTANTS (WILL BE INMPLEMENTED LATER RATHER THAN HARDCODED VALS BELOW)
	//Horizontal Timing
	parameter HFRONT = 16;
	parameter HSYNCEND = HFRONT + 96;
	parameter HBACKEND = HSYNCEND + 48;
	parameter HVSBLEND = HBACKEND + 640;
	//Vertical Timing
	parameter VFRONT = 10;
	parameter VSYNCEND = VFRONT + 2;
	parameter VBACKEND = VSYNCEND + 33;
	parameter VVSBLEND = VBACKEND + 480;
	

	//BEGIN COUNTER GENERATION
	always @(posedge clk) //horizontal counter
		begin //Constantly cycles counter_x from 0 to 799 then wraps back to 0
			if (counter_x < 799) begin //NOT AT THE END THEN CONTINUE
				counter_x <= counter_x + 10'd1;
			end
			else begin 
				counter_x <= 0;	//AT THEN END RESET BACK
			end	
		end
	always @(posedge clk) //vertical counter
		begin
			if (counter_x == 799) begin //Only counts up once for every cycle through horizontal
				if(counter_y < 525) begin //NOT AT THE END THEN CONTINUE
					counter_y <= counter_y + 10'd1;
				end
				else begin
					counter_y <= 0;	//AT THEN END RESET BACK
				end	
			end	
		end	

	//BEGIN SYNC GENERATION (hsync and vsync)
	assign hsync = (counter_x < 96) ? 1'b1 : 1'b0; //HIGH IF IN RANGE OF SYNC AND LOW IF NOT
	assign vsync = (counter_y < 2) ? 1'b1 : 1'b0;
	
	//ASSIGN COLOR CHANNELS IF ON THE SCREEN BASED OFF OF COLORS COMING FROM COLORZONES.V INPUTS
	assign o_r[3:0] = (counter_x > 144  && counter_x <= 783 && counter_y > 35  && counter_y <= 514) ? i_r[3:0] : 4'b0000 ; 
	assign o_g[3:0] = (counter_x > 144  && counter_x <= 783 && counter_y > 35  && counter_y <= 514) ? i_g[3:0] : 4'b0000 ; 
	assign o_b[3:0] = (counter_x > 144  && counter_x <= 783 && counter_y > 35  && counter_y <= 514) ? i_b[3:0] : 4'b0000 ; 

	//LINK COUNTER REGISTERS TO ACTUAL OUTPUTS
	assign xcount = counter_x;
	assign ycount = counter_y;

endmodule