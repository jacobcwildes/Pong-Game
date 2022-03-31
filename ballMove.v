//The idea for this module is to make it move back and forth, reacting with walls
//Created by Jacob Wildes & Dyllon Dunton. Last Modified on 12/2/21
module ballMove(
	input clk,
	input [9:0] yposLeft,
	input [9:0] yposRight,
	output [9:0] xpos,
	output [9:0] ypos,
	output [3:0] scoreLeft,
	output [3:0] scoreRight
);
	reg [9:0] x_count = 10'd464;
	reg [9:0] y_count = 10'd275;
	
	reg xdir = 0;
	reg ydir = 0;
	
	reg [3:0] left = 4'd0;
	reg [3:0] right = 4'd0;
	
	always @(posedge clk) begin
		if((y_count - 10'd8) >= 10'd39 && (y_count + 10'd9) <= 10'd511 && (x_count - 10'd8) > 10'd148 && (x_count + 10'd9) <= 10'd780) // on screen
			begin //make the ball move
				if (xdir == 0)
				begin
					if (ydir == 0) 
					begin // left up 
						x_count <= x_count - 10'd1;
						y_count <= y_count - 10'd1;
					end
					else // y == 1
					begin // left down 
						x_count <= x_count - 10'd1;
						y_count <= y_count + 10'd1;
					end
				end
				else // x == 1
				begin
					if (ydir == 0) 
					begin // right up 
						x_count <= x_count + 10'd1;
						y_count <= y_count - 10'd1;
					end
					else // y == 1
					begin // right down 
						x_count <= x_count + 10'd1;
						y_count <= y_count + 10'd1;
					end
				end
			end
			else begin 
				if((x_count - 10'd8) <= 10'd155) // left wall
				begin
					if ((y_count + 10'd8 >= yposLeft - 10'd50) && (y_count - 10'd7 <= yposLeft + 10'd50)) //runs if ball is within the left paddle
					begin
						xdir <= 1'b1;
						x_count <= x_count + 10'd1; //x_count increases by decimal 1, moving it to the right across the board
					end
					else 
					begin 
						right <= right + 4'd1; //increment right score
						x_count <= 10'd464; //sets ball back to middle
						y_count <= 10'd275; //sets ball back to middle
						
						
					end 
				end
				
				
				if((x_count + 10'd9) >= 10'd775) // right wall
				begin
					if (((y_count + 10'd8) >= (yposRight - 10'd50)) && ((y_count - 10'd7) <= (yposRight + 10'd50))) //runs if ball is within the right paddle
					begin
						xdir <= 1'b0;
						x_count <= x_count - 10'd1; //x_count decreases by 1, making it move left across the board
					end
					else 
					begin 
						left <= left + 4'd1; //increment left score
						x_count <= 10'd464; //sets ball back to middle
						y_count <= 10'd275; //sets ball back to middle
						
						
					end 
				end
				
				
				if((y_count-10'd8) <= 10'd45) // top wall
				begin
					ydir <= 1'b1;
					y_count <= y_count + 10'd1;
				end
				if((y_count + 10'd9) >= 10'd505) // bottom wall
				begin
					ydir <= 1'b0;
					y_count <= y_count - 10'd1;
				end
				
				
			end
	end
				
				assign xpos[9:0] = x_count[9:0];
				assign ypos[9:0] = y_count[9:0];
				
				assign scoreLeft[3:0] = left[3:0];
				assign scoreRight[3:0] = right[3:0];
				
endmodule
