`timescale 1ns/1ns
module testbenchVGA ( );
	reg CLOCK = 0;
	wire [3:0] VGAr;
	wire [3:0] VGAg;
	wire [3:0] VGAb;
	wire HS;
	wire VS;
	
	vgaDriver UUT (.clk(CLOCK), .rst(1'b0), .vsync(VS), .hsync(HS), .o_r(VGAr[3:0]), .o_g(VGAg[3:0]), .o_b(VGAb[3:0]));
	
		
	always 
	begin 
		CLOCK = ~CLOCK;
		#1;
		CLOCK = ~CLOCK;
		#1;
	end
	
endmodule

//-------------------------------------------------------
`timescale 1ns/1ns
module testbenchSpeedChange ( );
	reg [1:0] button;
	wire [31:0] counter;

	
	speedChange UUT (button[2:0], counter[31:0]);
	
		initial
		begin
			button[2:0] = 3'b000;
			#20 button[2:0] = 3'b001;
			#20 button[2:0] = 3'b100;
			#20 button[2:0] = 3'b010;
			#20 button[2:0] = 3'b100;
			#20 button[2:0] = 3'b010;
			#20 button[2:0] = 3'b000;
			#20 button[2:0] = 3'b001;
			#20 button[2:0] = 3'b100;
		end
	
endmodule

//-------------------------------------------------------



`timescale 1ns/1ns
module testbenchKB( );
	reg CLOCK_50;	//board clock
	reg PS2_KBCLK;  //keyboard clock and data signals
	reg PS2_KBDAT = 0;
	wire [6:0] inputBits;
	
	reg [9:0] counter = 0;
	Keyboard UUT (CLOCK_50, PS2_KBCLK, PS2_KBDAT, inputBits[6:0]);

	initial
	begin
		CLOCK_50 = 0;
		forever
		begin
			CLOCK_50 = ~CLOCK_50;
			if (counter < 624)
			begin
				counter = counter + 1;
			end
			else
			begin
				counter = 0;
				PS2_KBCLK = ~PS2_KBCLK;
			end
		end
	end
	
	always @(posedge PS2_KBCLK)
	begin
		PS2_KBDAT = ~PS2_KBDAT;
	end
	
endmodule

//-------------------------------------------------------


module testbenchBallMove ( );
	reg clk;
	reg [9:0] yposLeft;
	reg [9:0] yposRight;
	wire [9:0] xpos;
	wire [9:0] ypos;
	wire [3:0] scoreLeft;
	wire [3:0] scoreRight;

	
	ballMove UUT (clk, yposLeft[9:0], yposRight[9:0], xpos[9:0], ypos[9:0], scoreLeft[3:0], scoreRight[3:0]);
	
		initial
		begin
			clk = 0;
			forever begin
				#1 clk = ~clk;
			end
		end
		
		initial begin
			yposLeft[9:0] = 10'd275; yposRight[9:0] = 10'd325;
			#20 yposLeft[9:0] = 10'd275; yposRight[9:0] = 10'd335;
			#20 yposLeft[9:0] = 10'd285; yposRight[9:0] = 10'd345;
			#20 yposLeft[9:0] = 10'd295; yposRight[9:0] = 10'd335;
			#20 yposLeft[9:0] = 10'd285; yposRight[9:0] = 10'd345;
			#20 yposLeft[9:0] = 10'd295; yposRight[9:0] = 10'd335;
			#20 yposLeft[9:0] = 10'd285; yposRight[9:0] = 10'd325;
			#20 yposLeft[9:0] = 10'd275; yposRight[9:0] = 10'd315;
			#20 yposLeft[9:0] = 10'd265; yposRight[9:0] = 10'd325;
			#20 yposLeft[9:0] = 10'd255; yposRight[9:0] = 10'd345;
		end	
		
	
endmodule

//-------------------------------------------------------

module testbenchPaddleMove ( );
	reg clk;
	reg [3:0] switches;
	wire [9:0] yposLeft;
	wire [9:0] yposRight;

	
	paddleMove UUT (clk, switches[3:0], yposLeft[9:0], yposRight[9:0]);
		initial
		begin
			clk = 0;
			forever begin
				#1 clk = ~clk;
			end
		end
		
		initial begin
			switches[3:0] = 4'b1010;
			#20 switches[3:0] = 4'b1010; 
			#20 switches[3:0] = 4'b1001;
			#20 switches[3:0] = 4'b0110; 
			#20 switches[3:0] = 4'b1000;
			#20 switches[3:0] = 4'b0010; 
			#20 switches[3:0] = 4'b0000; 
			#20 switches[3:0] = 4'b0110;
			#20 switches[3:0] = 4'b1000;
			#20 switches[3:0] = 4'b0010;
		end	
		
	
endmodule

//-------------------------------------------------------

`timescale 1ns/1ns
module testbenchClockDivider ( );
	reg clk;
	wire out;

	
	clockDivider UUT (clk, 1'b0, out);
		initial
		begin
			clk = 1;
			forever begin
				#1 clk = ~clk;
			end
		end
	
endmodule
//-------------------------------------------------------


`timescale 1ns/1ns
module testbenchClockDividerBal ( );
	reg inClk;
	wire outClk;

	
	clockDividerBall UUT (inClk, 32'd156250, 1'b1, outClk);
	
	
	initial begin
		inClk = 1;
		forever begin
		#1 inClk = ~inClk;
		end
	end
	
	
endmodule
//-------------------------------------------------------
`timescale 1ns/1ns
module colorZones_Testbench ();

	//Inputs
	reg clk;
	reg [9:0] xcenter;
	reg [9:0] ycenter;
	reg [9:0] counter_x;
	reg [9:0] counter_y;
	reg [9:0] yposLeft;
	reg [9:0] yposRight;
	reg [6:0] l_o;
	reg [6:0] l_t;
	reg [6:0] r_o;
	reg[6:0] r_t;
	
	//Outputs
	wire [3:0] o_r = 0;
	wire [3:0] o_g = 0;
	wire [3:0] o_b = 0;
	
	colorZones UUT(.clk(clk), .xcenter(xcenter), .ycenter(ycenter), .counter_x(counter_x), .counter_y(counter_y), .yposLeft(yposLeft), .yposRight(yposRight), .l_o(l_o), .l_t(l_t), .r_o(r_o), .r_t(r_t), .o_r(o_r), .o_g(o_g), .o_b(o_b));
	
	initial begin
		clk = 0;
		forever begin
			#1 clk = ~clk;
			
			if(counter_x < 799)
			begin
				counter_x = counter_x + 10'd1;
			end
			else
			begin
				counter_x = 10'd0;
			end
			if (counter_x == 799) begin 
				if(counter_y < 525) begin
					counter_y = counter_y + 10'd1;
				end
				else begin
					counter_y = 10'd0;
				end	
			end	
		end
	end
	initial begin
		xcenter[9:0] = 10'd464; ycenter[9:0] = 10'd275; yposLeft[9:0] = 10'd200; yposRight[9:0] = 10'd200; l_o[6:0] = 0; l_t[6:0] = 0; r_o[6:0] = 0; r_t[6:0] = 0;
		#420000 xcenter[9:0] = 10'd474; ycenter[9:0] = 10'd275; yposLeft[9:0] = 10'd200; yposRight[9:0] = 10'd200; l_o[6:0] = 0; l_t[6:0] = 0; r_o[6:0] = 0; r_t[6:0] = 0;
		#420000 xcenter[9:0] = 10'd484; ycenter[9:0] = 10'd285; yposLeft[9:0] = 10'd210; yposRight[9:0] = 10'd210; l_o[6:0] = 0; l_t[6:0] = 0; r_o[6:0] = 0; r_t[6:0] = 0;
		#420000 xcenter[9:0] = 10'd494; ycenter[9:0] = 10'd295; yposLeft[9:0] = 10'd220; yposRight[9:0] = 10'd220; l_o[6:0] = 0; l_t[6:0] = 0; r_o[6:0] = 0; r_t[6:0] = 0;
		#420000 xcenter[9:0] = 10'd504; ycenter[9:0] = 10'd305; yposLeft[9:0] = 10'd230; yposRight[9:0] = 10'd230; l_o[6:0] = 0; l_t[6:0] = 0; r_o[6:0] = 0; r_t[6:0] = 0;
		#420000 xcenter[9:0] = 10'd514; ycenter[9:0] = 10'd315; yposLeft[9:0] = 10'd240; yposRight[9:0] = 10'd240; l_o[6:0] = 0; l_t[6:0] = 0; r_o[6:0] = 0; r_t[6:0] = 0;
		#420000 xcenter[9:0] = 10'd524; ycenter[9:0] = 10'd325; yposLeft[9:0] = 10'd250; yposRight[9:0] = 10'd250; l_o[6:0] = 0; l_t[6:0] = 0; r_o[6:0] = 0; r_t[6:0] = 0;
		#420000 xcenter[9:0] = 10'd534; ycenter[9:0] = 10'd335; yposLeft[9:0] = 10'd260; yposRight[9:0] = 10'd260; l_o[6:0] = 0; l_t[6:0] = 0; r_o[6:0] = 0; r_t[6:0] = 0;
		#420000 xcenter[9:0] = 10'd544; ycenter[9:0] = 10'd345; yposLeft[9:0] = 10'd270; yposRight[9:0] = 10'd270; l_o[6:0] = 0; l_t[6:0] = 0; r_o[6:0] = 0; r_t[6:0] = 0;
	end

endmodule 



