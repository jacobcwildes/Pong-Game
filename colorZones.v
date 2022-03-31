//This module controls the location of the walls, as well as the score,
//and the color shift as the ball moves across the screen
//Created by Dyllon Dunton & Jacob Wildes. Last modified on 12/2/21
module colorZones(
	input clk,
	input [9:0] xcenter,
	input [9:0] ycenter,
	input [9:0] counter_x,
	input [9:0] counter_y,
	input [9:0] yposLeft,
	input [9:0] yposRight,
	input [6:0] l_o,
	input [6:0] l_t,
	input [6:0] r_o,
	input [6:0] r_t,
	output reg [3:0] o_r = 0,
	output reg [3:0] o_g = 0,
	output reg [3:0] o_b = 0
);
	
	//reg [9:0] xcenter = 10'd464; //center for x
	//reg [9:0] ycenter = 10'd275; //center for y	
	
	//XLENGTH = 780-148 = 632
	//YLENGTH = 511-39 = 472
	
	//36 <= TOPWALL <=38
	//512 <= BOTTOMWALL <=514
	//145 <= LEFTWALL <=147
	//781 <= RIGHTWALL <= 783
	
	//BALL DIMENSIONS
	//8 LEFT
	//9 RIGHT
	//8 ABOVE
	//9 BELOW
	
	//MOSTRED  149, 238 
	//MORERED  239, 328
	//RED      329, 418
	//PURPLE   419, 509
	//BLUE     510, 599
	//MOREBlUE 600, 689
	//MOSTBlUE 690, 780
	
		always @(posedge	 clk)
		begin
			if ((counter_y > 35 && counter_y <=38) || (counter_y > 511 && counter_y <=514))																															
			begin //White (Walls)
				o_r[3:0] = 4'hf;
				o_g[3:0] = 4'hf;
				o_b[3:0] = 4'hf;
			end
			else if ((counter_x > 144 && counter_x <=148) && (counter_y >= yposLeft - 50 && counter_y <= yposLeft + 50)) //yposLeft
			begin	 //sets the left paddle color to blue
				o_r[3:0] = 4'h0;
				o_g[3:0] = 4'h0;
				o_b[3:0] = 4'hf;
			end
			else if ((counter_x > 779 && counter_x <=783) && (counter_y >= yposRight - 50 && counter_y <= yposRight + 50)) //yposRight
			begin //sets the right paddle color to red
				o_r[3:0] = 4'hf;
				o_g[3:0] = 4'h0;
				o_b[3:0] = 4'h0;
			end
			else if ((counter_x >= xcenter-8 && counter_x <= xcenter + 9 && counter_y >= ycenter - 4 && counter_y <= ycenter + 5) || (counter_x >= xcenter-4 && counter_x <= xcenter + 5 && counter_y >= ycenter - 8 && counter_y <= ycenter + 9))
			begin //BALL
				//MOSTRED
				if (counter_x <=238)    //Everything from position 238 and left is most red
				begin
					o_r[3:0] = 4'hf;
					o_g[3:0] = 4'h0;
					o_b[3:0] = 4'h0;
				end
				else //MORERED			//Everything between 239 and 328 is a brighter red
				if (counter_x <=328)
				begin
					o_r[3:0] = 4'hf;
					o_g[3:0] = 4'h0;
					o_b[3:0] = 4'h5;
				end
				else //RED				//Everything between 329 and 418 is a brighter red
				if (counter_x <=418)
				begin
					o_r[3:0] = 4'hf;
					o_g[3:0] = 4'h0;	
					o_b[3:0] = 4'h8;
				end
				else //PURPLE		//Everything between 419 and 509 is purple
				if (counter_x <=509)
				begin
					o_r[3:0] = 4'hf;
					o_g[3:0] = 4'h0;
					o_b[3:0] = 4'hf;
				end
				else //BLUE			//Everything between 510 and 599 is blue
				if (counter_x <=599)
				begin
					o_r[3:0] = 4'h8;
					o_g[3:0] = 4'h0;
					o_b[3:0] = 4'hf;
				end
				else //MOREBLUE	//Everything between 600 and 689 is a deeper blue
				if (counter_x <=689)
				begin
					o_r[3:0] = 4'h5;
					o_g[3:0] = 4'h0;
					o_b[3:0] = 4'hf;
				end
				else //MOSTBLUE	//Everything between 690 and 780 is the deepest blue
				if (counter_x <=780)
				begin
					o_r[3:0] = 4'h0;
					o_g[3:0] = 4'h0;
					o_b[3:0] = 4'hf;	
				end
			end
			//-------------------------------------------------------------------------------------------
			//SCORE DISPLAY
			
			//If the digit is a 1, then the segment is displayed, similar to the physical BCD display on the FPGA board
			//This applies to each if statement to the end of this SCORE DISPLAY section
			else if (l_o[0] & (counter_x <= 452 && counter_x > 372 && counter_y > 48 && counter_y <= 68))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (l_o[5] & (counter_x <= 392 && counter_x > 372 && counter_y > 48 && counter_y <= 128))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (l_o[4] & (counter_x <= 392 && counter_x > 372 && counter_y > 108 && counter_y <= 188))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (l_o[3] & (counter_x <= 452 && counter_x > 372 && counter_y > 168 && counter_y <= 188))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (l_o[2] & (counter_x <= 452 && counter_x > 432 && counter_y > 108 && counter_y <= 188))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (l_o[1] & (counter_x <= 452 && counter_x > 432 && counter_y > 48 && counter_y <= 128))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (l_o[6] & (counter_x <= 452 && counter_x > 372 && counter_y > 108 && counter_y <= 128))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			
			else if (l_t[0] & (counter_x <= 452-100 && counter_x > 372-100 && counter_y > 48 && counter_y <= 68))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (l_t[5] & (counter_x <= 392-100 && counter_x > 372-100 && counter_y > 48 && counter_y <= 128))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (l_t[4] & (counter_x <= 392-100 && counter_x > 372-100 && counter_y > 108 && counter_y <= 188))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (l_t[3] & (counter_x <= 452-100 && counter_x > 372-100 && counter_y > 168 && counter_y <= 188))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (l_t[2] & (counter_x <= 452-100 && counter_x > 432-100 && counter_y > 108 && counter_y <= 188))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (l_t[1] & (counter_x <= 452-100 && counter_x > 432-100 && counter_y > 48 && counter_y <= 128))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (l_t[6] & (counter_x <= 452-100 && counter_x > 372-100 && counter_y > 108 && counter_y <= 128))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end

			
			
			else if (r_o[0] & (counter_x <= 144 + 452 + 60 && counter_x > 144 + 372 + 60 && counter_y > 48 && counter_y <= 68))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (r_o[5] & (counter_x <= 144 + 392 + 60 && counter_x > 144 + 372 + 60 && counter_y > 48 && counter_y <= 128))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (r_o[4] & (counter_x <= 144 + 392 + 60 && counter_x > 144 + 372 + 60 && counter_y > 108 && counter_y <= 188))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (r_o[3] & (counter_x <= 144 + 452 + 60 && counter_x > 144 + 372 + 60 && counter_y > 168 && counter_y <= 188))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (r_o[2] & (counter_x <= 144 + 452 + 60 && counter_x > 144 + 432 + 60 && counter_y > 108 && counter_y <= 188))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (r_o[1] & (counter_x <= 144 + 452 + 60 && counter_x > 144 + 432 + 60 && counter_y > 48 && counter_y <= 128))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (r_o[6] & (counter_x <= 144 + 452 + 60 && counter_x > 144 + 372 + 60 && counter_y > 108 && counter_y <= 128))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			
			
			else if (r_t[0] & (counter_x <= 144 + 452 + 60 - 100 && counter_x > 144 + 372 + 60 - 100 && counter_y > 48 && counter_y <= 68))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (r_t[5] & (counter_x <= 144 + 392 + 60 - 100 && counter_x > 144 + 372 + 60 - 100 && counter_y > 48 && counter_y <= 128))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (r_t[4] & (counter_x <= 144 + 392 + 60 - 100 && counter_x > 144 + 372 + 60 - 100 && counter_y > 108 && counter_y <= 188))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (r_t[3] & (counter_x <= 144 + 452 + 60 - 100 && counter_x > 144 + 372 + 60 - 100 && counter_y > 168 && counter_y <= 188))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (r_t[2] & (counter_x <= 144 + 452 + 60 - 100 && counter_x > 144 + 432 + 60 - 100 && counter_y > 108 && counter_y <= 188))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (r_t[1] & (counter_x <= 144 + 452 + 60 - 100 && counter_x > 144 + 432 + 60 - 100 && counter_y > 48 && counter_y <= 128))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
			else if (r_t[6] & (counter_x <= 144 + 452 + 60 - 100 && counter_x > 144 + 372 + 60 - 100 && counter_y > 108 && counter_y <= 128))
			begin
				o_r[3:0] = 4'h3;
				o_g[3:0] = 4'h3;
				o_b[3:0] = 4'h3;
			end
//-------------------------------------------------------------------------------------
			else if (counter_x >=462 && counter_x <= 465)
			begin //MIDDLE LINE
				o_r[3:0] = 4'hf;
				o_g[3:0] = 4'hf;
				o_b[3:0] = 4'hf;
			end
			else begin //all unaccounted for coordinates are black space
				o_r[3:0] = 4'h0;
				o_g[3:0] = 4'h0;
				o_b[3:0] = 4'h0;
			end		
		end
endmodule	
