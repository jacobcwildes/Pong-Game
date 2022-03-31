//Move the right and left paddle
//Created by Jacob Wildes & Dyllon Dunton. Last modified on 12/2/21
module paddleMove(
	input clk,
	input [3:0] switches,
	output [9:0] yposLeft,
	output [9:0] yposRight
);
//start the paddles in a neutral position
	reg [9:0] paddleLeft = 200;
	reg [9:0] paddleRight = 200;
	always @(posedge clk)
	begin
	//if the switch is on, and the paddle is in bounds, execute
		if(switches[2] && paddleLeft - 10'd50 > 10'd38 && paddleLeft + 10'd50 < 10'd511)
		begin
			paddleLeft <= paddleLeft + 10'd1; 
		end
			
			if(paddleLeft - 10'd50 <= 10'd41)
			begin
			paddleLeft <= paddleLeft + 10'd1; //if the paddle reaches the end of the bound, stop
			end
			//if the switch is on, and the paddle is in bounds, execute
		if(switches[3] && paddleLeft - 10'd50 > 10'd38 && paddleLeft + 10'd50 < 10'd511)
		begin
			paddleLeft <= paddleLeft - 10'd1;
		end
			if(paddleLeft + 10'd50 >= 10'd508)
			begin
			paddleLeft <= paddleLeft - 10'd1; //if the paddle reaches the end of the bound, stop
			end
			//if the switch is on, and the paddle is in bounds, execute
		if(switches[0] && paddleRight - 10'd50 > 10'd38 && paddleRight + 10'd50 < 10'd511)
		begin
			paddleRight <= paddleRight + 10'd1;
		end
			if(paddleRight - 10'd50 <= 10'd41)
			begin
			paddleRight <= paddleRight + 10'd1; //if the paddle reaches the end of the bound, stop
			end
			//if the switch is on, and the paddle is in bounds, execute
		if(switches[1] && paddleRight - 10'd50 > 10'd38 && paddleRight + 10'd50 < 10'd511)
		begin	
			paddleRight <= paddleRight - 10'd1;
		end
			if(paddleRight + 10'd50 >= 10'd508)
			begin
			paddleRight <= paddleRight - 10'd1; //if the paddle reaches the end of the bound, stop
			end
end
		assign yposLeft[9:0] = paddleLeft[9:0];
		assign yposRight[9:0] = paddleRight[9:0];
endmodule
