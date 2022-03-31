//Adapted from https://www.instructables.com/PS2-Keyboard-for-FPGA/, and adapted by Jacob Wildes & Dyllon Dunton to suit the Pong Project's needs
//Last updated on 12/7/21
module Keyboard(
	input CLOCK_50,	//board clock
	input gameClk,
   input PS2_KBCLK,	//keyboard clock and data signals
   input PS2_KBDAT,
	output [6:0] inputBits
   );
	
	wire valid;
	wire makeBreak;
	wire [7:0] code;
	reg [6:0] controlBits = 0;
	
	keyboard_press_driver(.CLOCK_50(CLOCK_50), .PS2_DAT(PS2_KBDAT), .PS2_CLK(PS2_KBCLK), .reset(0), .valid(valid), .makeBreak(makeBreak), .outCode(code[7:0]));
	
	reg [7:0] w = 8'h1d;
	reg [7:0] s = 8'h1b;
	reg [7:0] up = 8'h75;
	reg [7:0] down = 8'h72;
	reg [7:0] shift = 8'h12;
	reg [7:0] control = 8'h14;
	reg [7:0] caps = 8'h58;
	reg [7:0] off = 8'hf0;
	
	
	reg leftPaddleUp = 0;
	reg leftPaddleDown = 0;
	reg rightPaddleUp = 0;
	reg rightPaddleDown = 0;
	reg speedUp = 0;
	reg speedMid = 0;
	reg speedDown = 0;

	always @(posedge valid)
	begin
		if (makeBreak)
		begin
			if (code == w)				//if the CODEWORD has the same code as the W code
			begin
				leftPaddleUp <= 1'b1;
				leftPaddleDown <= 1'b0;
				rightPaddleDown <= 1'b0;
				rightPaddleUp <= 1'b0;
				speedDown <= 1'b0;
				speedUp <= 1'b0;
				speedMid <= 1'b0;
			end
			else if (code == s)			//or if the S was pressed, then
			begin
				leftPaddleDown <= 1'b1;
				leftPaddleUp <= 1'b0;
				rightPaddleDown <= 1'b0;
				rightPaddleUp <= 1'b0;
				speedDown <= 1'b0;
				speedUp <= 1'b0;
				speedMid <= 1'b0;
			end
			if (code == up)				//if the CODEWORD has the same code as the ARROW_UP code
			begin
				rightPaddleUp <= 1'b1;
				leftPaddleDown <= 1'b0;
				leftPaddleUp <= 1'b0;
				rightPaddleDown <= 1'b0;
				speedDown <= 1'b0;
				speedUp <= 1'b0;
				speedMid <= 1'b0;
			end
			else if (code == down)			//or if the ARROW_DOWN was pressed, then
			begin
				rightPaddleDown <= 1'b1;
				leftPaddleDown <= 1'b0;
				leftPaddleUp <= 1'b0;
				rightPaddleUp <= 1'b0;
				speedDown <= 1'b0;
				speedUp <= 1'b0;
				speedMid <= 1'b0;
			end
			else if (code == shift)				//if the CODEWORD has the same code as the speedMid code
			begin
				speedMid <= 1'b1;
				leftPaddleDown <= 1'b0;
				leftPaddleUp <= 1'b0;
				rightPaddleDown <= 1'b0;
				rightPaddleUp <= 1'b0;
				speedDown <= 1'b0;
				speedUp <= 1'b0;
			end
			else if (code == control)			//or if the speedDown was pressed, then
			begin
				speedDown <= 1'b1;
				leftPaddleDown <= 1'b0;
				leftPaddleUp <= 1'b0;
				rightPaddleDown <= 1'b0;
				rightPaddleUp <= 1'b0;
				speedUp <= 1'b0;
			end
			else if (code == caps)			//or if the speedUp was pressed, then
			begin
				speedUp <= 1'b1;
				leftPaddleDown <= 1'b0;
				leftPaddleUp <= 1'b0;
				rightPaddleDown <= 1'b0;
				rightPaddleUp <= 1'b0;
				speedDown <= 1'b0;
			end
		end	
		else	//or key was released, then
		begin 
			leftPaddleUp <= 1'b0;
			leftPaddleDown <= 1'b0;
			rightPaddleDown <= 1'b0;
			rightPaddleUp <= 1'b0;
			speedDown <= 1'b0;
			speedUp <= 1'b0;
			speedMid <= 1'b0;
		end

		controlBits <= {leftPaddleUp, leftPaddleDown, rightPaddleUp, rightPaddleDown, speedUp, speedMid, speedDown};
	
	end
	
	assign inputBits[6:0] = controlBits[6:0];
	
endmodule


//------------------------------------------------------------------------------------------
module keyboard_press_driver(
  input  CLOCK_50, 
  output reg valid, makeBreak,
  output reg [7:0] outCode,
  input    PS2_DAT, // PS2 data line
  input    PS2_CLK, // PS2 clock line
  input reset
);

parameter FIRST = 1'b0, SEENF0 = 1'b1;
reg state;
reg [1:0] count;
wire [7:0] scan_code;
reg [7:0] filter_scan;
wire scan_ready;
reg read;
parameter NULL = 8'h00;

initial 
begin
	state = FIRST;
	filter_scan = NULL;
	read = 1'b0;
	count = 2'b00;
end
	

// inner driver that handles the PS2 keyboard protocol
// outputs a scan_ready signal accompanied with a new scan_code
keyboard_inner_driver kbd(
  .keyboard_clk(PS2_CLK),
  .keyboard_data(PS2_DAT),
  .clock50(CLOCK_50),
  .reset(reset),
  .read(read),
  .scan_ready(scan_ready),
  .scan_code(scan_code)
);

always @(posedge CLOCK_50)
	case(count)
		2'b00:
			if(scan_ready)
				count <= 2'b01;
		2'b01:
			if(scan_ready)
				count <= 2'b10;
		2'b10:
			begin
				read <= 1'b1;
				count <= 2'b11;
				valid <= 0;
				outCode <= scan_code;
				case(state)
					FIRST:
						case(scan_code)
							8'hF0:
								begin
									state <= SEENF0;
								end
							8'hE0:
								begin
									state <= FIRST;
								end
							default:
								begin
									filter_scan <= scan_code;
									if(filter_scan != scan_code)
										begin
											valid <= 1'b1;
											makeBreak <= 1'b1;
										end
								end
						endcase
					SEENF0:
						begin
							state <= FIRST;
							if(filter_scan == scan_code)
								begin
									filter_scan <= NULL;
								end
							valid <= 1'b1;
							makeBreak <= 1'b0;
						end
				endcase
			end
		2'b11:
			begin
				read <= 1'b0;
				count <= 2'b00;
				valid <= 0;
			end
	endcase
endmodule 

//------------------------------------------------------------------------------------------------------
module keyboard_inner_driver(keyboard_clk, keyboard_data, clock50, reset, read, scan_ready, scan_code);
input keyboard_clk;
input keyboard_data;
input clock50; // 50 Mhz system clock
input reset;
input read;
output scan_ready;
output [7:0] scan_code;
reg ready_set;
reg [7:0] scan_code;
reg scan_ready;
reg read_char;
reg clock; // 25 Mhz internal clock

reg [3:0] incnt;
reg [8:0] shiftin;

reg [7:0] filter;
reg keyboard_clk_filtered;

// scan_ready is set to 1 when scan_code is available.
// user should set read to 1 and then to 0 to clear scan_ready

always @ (posedge ready_set or posedge read)
if (read == 1) scan_ready <= 0;
else scan_ready <= 1;

// divide-by-two 50MHz to 25MHz
always @(posedge clock50)
    clock <= ~clock;



// This process filters the raw clock signal coming from the keyboard 
// using an eight-bit shift register and two AND gates

always @(posedge clock)
begin
   filter <= {keyboard_clk, filter[7:1]};
   if (filter==8'b1111_1111) keyboard_clk_filtered <= 1;
   else if (filter==8'b0000_0000) keyboard_clk_filtered <= 0;
end


// This process reads in serial data coming from the terminal

always @(posedge keyboard_clk_filtered)
begin
   if (reset==1)
   begin
      incnt <= 4'b0000;
      read_char <= 0;
   end
   else if (keyboard_data==0 && read_char==0)
   begin
    read_char <= 1;
    ready_set <= 0;
   end
   else
   begin
       // shift in next 8 data bits to assemble a scan code    
       if (read_char == 1)
           begin
              if (incnt < 9) 
              begin
                incnt <= incnt + 1'b1;
                shiftin = { keyboard_data, shiftin[8:1]};
                ready_set <= 0;
            end
        else
            begin
                incnt <= 0;
                scan_code <= shiftin[7:0];
                read_char <= 0;
                ready_set <= 1;
            end
        end
    end
end

endmodule

