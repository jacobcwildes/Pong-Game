//CREATED BY DYLLON DUNTON AND JACOB WILDES
//LAST UPDATED 12/02/21


//THIS MODULE TAKES IN AN 8 BIT BINARY VALUE AND OUTPUTS 4 BITS EACH FOR THE ONES, TENS, AND HUNDREDS PLACE ALL IN ONE 12 BIT REGISTER

module binToBCD(
	input [7:0] bin, // INPUT BINARY VAL
	output [11:0] BCD // OUTPUT BCD VALS
);
	// REGISTERS FOR BINARY VALUE, BCD VALUE, AND INDEX VAL FOR THE FOR LOOP
	reg [7:0] binary;
	reg [3:0] i;
	reg [11:0] bcd;
	
	always @(*) begin
		bcd[11:0] = 12'b000000000000; //INITIALIZE THE BCD VAL TO 0
		binary[7:0] = bin[7:0]; //SET THE REGISTER EQUAL TO THE INPUT
		for(i=0; i<8-1; i= i+1) begin //THIS FOR LOOP WILL 
			bcd[0] = binary[7]; //BIT SHIFT THE BINARY VALUE OVER 1, WITH THE MOST SIGNIFICANT BIT FLOWING INTO THE BCD VAL
			binary[7:0] = binary[7:0] << 1;
			if(bcd[3:0] > 4'b0100) begin //IF BCD VAL IS FOR ONES GREATER THAN 4, ADD 3 TO IT
				bcd[3:0] = bcd[3:0] + 4'b0011;
			end
			if(bcd[7:4] > 4'b0100) begin
				bcd[7:4] = bcd[7:4] + 4'b0011; //IF BCD VAL FOR TENS IS GREATER THAN 4, ADD 3 TO IT
			end
			if(bcd[11:8] > 4'b0100) begin
				bcd[11:8] = bcd[11:8] + 4'b0011; //IF BCD VAL FOR HUNS IS GREATER THAN 4, ADD 3 TO IT
			end
			bcd[11:0] = bcd[11:0] << 1; //BIT SHIFT THE BCD VAL
		end
		bcd[0] = binary[7];// MOVE OVER MOST SIG BIT OF BIN VAL INTO LEAST SIG BIT OF BCD VAL
		
		
	end
	
	// LINK OUTPUT TO REGISTER
	assign BCD[11:0] = bcd[11:0];
	
	

endmodule 