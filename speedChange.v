//CREATED BY DYLLON DUNTON AND JACOB WILDES
//LAST UPDATED 12/02/21


//THIS MODULE WILL SEND A COUNTER VAL TO THE CLOCKDIVIDERBALL.V MODULE IN ORDER TO DETERMINE THE GAME SPEED 

module speedChange(
	input [2:0] button, //INPUTS FOR THE BUTTONS THAT CHANGE THE SPEED
	output [31:0] counterVal //OUTPUT VALUE THAT IS SENT TO CLOCKDIVIDERBALL.V, IT IS THE VALUE THAT THE COUNTER WILL HAVE TO REACH BEFORE EACH CLOCK TOGGLE 
);
	
	reg [31:0] count = 32'd156250; //NORMAL SPEED VALUE
	
	always @(*) // POSITIVE EDGES FOR WHEN THE BUTTONS ARE PRESSED
	begin
		if(!button[2]) //IF BUTTON 2 THEN SET TO THE FAST PRESET
		begin
			count <= 32'd156250 - 32'd100000;
		end
		else if(!button[1]) //IF BUTTON 1 THEN SET TO THE NORMAL PRESET
		begin
			count <= 32'd156250;
		end
		else if(!button[0]) //IF BUTTON 0 THEN SET TO THE SLOW PRESET
	   begin
			count <= 32'd156250 + 32'd100000;
		end
		//else 
		//begin
		//	count <= 32'd156250;
		//end	
	end
	
	// LINK THE OUTPUT FOR THE COUNTER VALUE TO THE REGISTER
	assign counterVal[31:0] = count[31:0];
	
endmodule