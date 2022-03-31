//The core for the game of pong.
//Created by Dyllon Dunton & Jacob Wildes
//Last modified on 12/2/21
//Some includes are commented out because the file was made in Quartus, so 
//it automatically paths to the module. 

/*********************************************************/
//MAKE SURE THESE INCLUDES ARE UNCOMMENTED IF BEING RECOMPILED//
/*********************************************************/
`include "../Modules/vga_driver.v"
`include "../Modules/clockDivider.v"
`include "../Modules/colorZones.v"
`include "../Modules/ballMove.v"
//`include "../Modules/clockDividerBall.v"
`include "../Modules/binToBCD.v"
`include "../Modules/BCD_Display.v"
`include "../Modules/paddleMove.v"
`include "../Modules/SpeedChange.v"
`include "../Modules/keyboard.v"
`include "../Modules/pongTestBenches.v"

`timescale 1ns/1ps
module pong(
	input CLOCK_50,
	input [4:0] SW, // Testing
	input [2:0] ORG_BUTTON,
	input PS2_KBCLK,
	input PS2_KBDAT,
	output [3:0]VGA_R,
	output [3:0]VGA_G,
	output [3:0]VGA_B,
	output VGA_HS,
	output VGA_VS
);

wire vsync;
wire hsync;
wire [3:0] vgar;
wire [3:0] vgag;
wire [3:0] vgab;

wire [9:0] xposition;//10'd600;
wire [9:0] yposition;//10'd275;

wire [9:0] outPaddleLeft; //= 10'd100;
wire [9:0] outPaddleRight; //= 10'd450;

wire [9:0] xcount;
wire [9:0] ycount;

wire clk25MHz;
wire gameClk;

wire [6:0] keys;

wire [3:0] r;
wire [3:0] g;
wire [3:0] b;

wire [3:0] leftScore;
wire [3:0] rightScore;

wire [11:0] leftBCD;
wire [11:0] rightBCD;

wire [6:0] tensLeft;
wire [6:0] onesLeft;
wire [6:0] tensRight;
wire [6:0] onesRight;

reg gameMotion = 1'b1;

wire [31:0] gameSpeed;


//Divides clock into 25MHz
clockDivider clkdiv (.inClk(CLOCK_50), .reset(SW[0]), .outClk(clk25MHz));

//Cuts the clock down into a viewable speed, so that the ball moves across the screen in 4 seconds
clockDividerBall ballClk (.inClk(CLOCK_50), .motion(gameMotion), .speed(gameSpeed[31:0]), .outClk(gameClk));

//Increases or decreases speed depending on which button is pressed
speedChange speedVal (.button(ORG_BUTTON[2:0]), .counterVal(gameSpeed[31:0]));

//Calls the VGA monitor and displays
vgaDriver video (.clk(clk25MHz), .rst(SW[0]), .i_r(r[3:0]), .i_g(g[3:0]), .i_b(b[3:0]), .vsync(vsync), .hsync(hsync), .o_r(vgar[3:0]), .o_g(vgag[3:0]), .o_b(vgab[3:0]), .xcount(xcount), .ycount(ycount));

//keyboard ps2 driver
Keyboard interaction (.CLOCK_50(CLOCK_50), .gameClk(gameClk), .PS2_KBCLK(PS2_KBCLK), .PS2_KBDAT(PS2_KBDAT), .inputBits(keys[6:0]));

//Sets colors for the ball to cycle through as it traverses across the screen
colorZones color (.clk(clk25MHz), .xcenter(xposition[9:0]), .ycenter(yposition[9:0]), .counter_x(xcount), .counter_y(ycount), .yposLeft(outPaddleLeft[9:0]), .yposRight(outPaddleRight[9:0]), .l_o(onesLeft[6:0]), .l_t(tensLeft[6:0]), .r_o(onesRight[6:0]), .r_t(tensRight[6:0]), .o_r(r[3:0]), .o_g(g[3:0]), .o_b(b[3:0]));

//Contains all of the functions that pertain to making the ball move and react with 
//walls and paddles
ballMove moveBall (.clk(gameClk), .yposLeft(outPaddleLeft[9:0]), .yposRight(outPaddleRight[9:0]), .xpos(xposition[9:0]), .ypos(yposition[9:0]), .scoreLeft(leftScore[3:0]), .scoreRight(rightScore[3:0]));

//Contains all functions needed to make the paddles go up and down, as well
//as remain in bounds
paddleMove movePaddle (.clk(gameClk), .switches(keys[6:3]), .yposLeft(outPaddleLeft[9:0]), .yposRight(outPaddleRight[9:0]));

//Calls necessary functions to calculate score on the left
binToBCD lScore (.bin({4'b0000, leftScore[3:0]}), .BCD(leftBCD[11:0]));

//Calls necessary functions to calculate score on the right
binToBCD rScore (.bin({4'b0000, rightScore[3:0]}), .BCD(rightBCD[11:0])); 

//Displays both ones and tens place score as calculated in binToBCD for the left
BCD_Display lTen (.inputBCD(leftBCD[7:4]), .LED_Segment(tensLeft[6:0]));
BCD_Display lOne (.inputBCD(leftBCD[3:0]), .LED_Segment(onesLeft[6:0]));
/**********/
//Displays both ones and tens place score as calculated in binToBCD for the right
BCD_Display rTen (.inputBCD(rightBCD[7:4]), .LED_Segment(tensRight[6:0]));
BCD_Display rOne (.inputBCD(rightBCD[3:0]), .LED_Segment(onesRight[6:0]));
/**********/

//If the score reaches 10, the game ends
always @(posedge clk25MHz)
begin
	if (leftScore >= 4'd10)
	begin
		gameMotion <= 1'b0;
		//message
	end
	if (rightScore >= 4'd10)
	begin
		gameMotion <= 1'b0;
		//message
	end
end





assign VGA_HS = hsync;
assign VGA_VS = vsync;
assign VGA_R[3:0] = vgar[3:0];
assign VGA_G[3:0] = vgag[3:0];
assign VGA_B[3:0] = vgab[3:0];

endmodule