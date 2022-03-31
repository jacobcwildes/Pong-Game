//Purpose of this module is to divide the 50MHz clock into 25MHz clock
//Created by Dyllon Dunton & Jacob Wildes. Last modified on 12/2/21
module clockDivider(
	input inClk,
	input reset,
	output outClk
);
	reg out = 0;
	
	always @(posedge inClk) begin
		//If the reset switch is in the 1 position, out becomes binary 0
		if (reset) begin
			out <= 1'b0;
		end
		else begin //Out flips from either 1 to 0, or 0 to 1 depending on state when else was run
			out <= ~out;
		end	
	end
	
	assign outClk = out;
endmodule