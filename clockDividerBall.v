//Divides the clock down into a viewable speed for
//the ball to traverse the screen in 4 seconds
//Created by Jacob Wildes & Dyllon Dunton. Last modified on 12/2/21
module clockDividerBall (
	input inClk,
	input [31:0] speed,
	input motion,
	output outClk
);
	reg out = 1'b0; //Toggles the slower clock so that the ball is viewable
	reg [31:0] counter = 32'd0;

	always @(posedge inClk) 
	begin
		//If motion is 0 (off), values remain the same
		if (~motion)
		begin
			counter <= counter;
			out <= out;
		end
		//If the counter is less than the speed, then the counter is increased by decimal 1
		else if (counter < speed)
		begin
			counter <= counter + 32'd1;
			out <= out;
		end
		else
		begin
			counter <= 32'd0; //Counter goes right back to zero and output is switched from either 1 to 0, or 0 to 1
			out <= ~out;
		end	
	end
	
	assign outClk = out;
	
endmodule
