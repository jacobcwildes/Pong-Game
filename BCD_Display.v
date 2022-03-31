//CREATED BY DYLLON DUNTON AND JACOB WILDES
//LAST UPDATED 12/02/21


//THIS MODULE TAKES IN 4BIT BCD VAL FROM BINTOBCD.V MODULE AND SENDS OUT A 7BIT REGISTER THAT MAPS WHICH BCD DISPLAY SEGMENTS SHOULD BE ON

module BCD_Display(
	input [3:0] inputBCD, //4 BIT BCD VALUE FROM THE BINTOBCD.V MODULE
	output [6:0] LED_Segment //7 BIT WIRE THAT WILL HOLD IN THE DATA FOR WHICH SEGMENTS ON THE DISPLAY SHOULD BE ON, 1 IF ON, 0 IF OFF
);
	
	//THIS TAKES IN THE INPUT 'inputBCD' AND REVERSES THE BIT ORDER
	wire [3:0] BCDValue;
	assign BCDValue = {inputBCD[0],inputBCD[1],inputBCD[2],inputBCD[3]};
	
	//COMBINATIONAL LOGIC DERIVED FROM TRUTH TABLE OF EACH LED
	assign LED_Segment[0] = !((BCDValue[3:0] == 4'b0000) ? 0 : (BCDValue[0] | !BCDValue[2])&(BCDValue[0] | !BCDValue[1]| !BCDValue[3])&(!BCDValue[0] | BCDValue[1]| BCDValue[2]));
	assign LED_Segment[1] = !((BCDValue[3:0] == 4'b0000) ? 0 : (BCDValue[0] & BCDValue[1])|(BCDValue[0] & BCDValue[2])|(BCDValue[1] & BCDValue[2]& !BCDValue[3])|(BCDValue[1] & !BCDValue[2]& BCDValue[3])|(!BCDValue[0] & !BCDValue[1]& !BCDValue[2]& !BCDValue[3]));
	assign LED_Segment[2] = !((BCDValue[3:0] == 4'b0000) ? 0 : (BCDValue[0] & BCDValue[2])|(BCDValue[0] & BCDValue[1])|(!BCDValue[0] & !BCDValue[1]& !BCDValue[3]));
	assign LED_Segment[3] = !((BCDValue[3:0] == 4'b0000) ? 0 : (BCDValue[0] & BCDValue[2])|(BCDValue[0] & BCDValue[3])|(BCDValue[0] & BCDValue[1])|(BCDValue[1] & BCDValue[2]& BCDValue[3])|(!BCDValue[0] & !BCDValue[2]& !BCDValue[3])|(!BCDValue[0] & !BCDValue[1]& !BCDValue[2]));
	assign LED_Segment[4] = !((BCDValue[3:0] == 4'b0000) ? 0 : (BCDValue[0] | !BCDValue[2]| BCDValue[3])&(!BCDValue[0] | BCDValue[1]| BCDValue[2]| BCDValue[3]));
	assign LED_Segment[5] = !((BCDValue[3:0] == 4'b0000) ? 0 : (!BCDValue[0] | BCDValue[1]| BCDValue[2])&(BCDValue[0] | !BCDValue[1]| BCDValue[2])&(BCDValue[0] | !BCDValue[1]| BCDValue[3]));
	assign LED_Segment[6] = !((BCDValue[0] & BCDValue[1])|(BCDValue[0] & BCDValue[2])|(BCDValue[1] & BCDValue[2]& BCDValue[3])|(!BCDValue[0] & !BCDValue[1]& !BCDValue[2]));


endmodule

	