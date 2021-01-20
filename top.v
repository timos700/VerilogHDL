module top (clk, reset, ps2clk, ps2data, hsync, vsync, red, green, blue);
input reset, clk, ps2clk, ps2data;
output hsync, vsync;
output [2:0] red, green, blue;

wire clk25, flagkey;
wire [2:0] rr, gg, bb;
wire [7:0] scancode;
wire [9:0] hpos;
wire [8:0] vpos;

clk25MHz newclk (clk,reset,clk25);
keyboard kbd (reset, clk25, ps2clk, ps2data, scancode, flagkey);
vgasync vga (clk25, reset, scancode, flagkey, hsync, vsync, rr, gg, bb, hpos, vpos);
extra xtra (clk25, reset, rr, gg, bb, hpos, vpos, scancode, flagkey, red, green, blue);

endmodule


module clk25MHz(clk, reset, clk25);
	input clk, reset;
	output clk25;
	reg[1:0] cnt;
	assign clk25 = (cnt == 2'd3);
	always @(posedge reset or posedge clk)
	begin
		if (reset) cnt <= 0;
		else
		begin
			if (clk25) cnt <= 0;
			else cnt <= cnt + 1;
		end
	end
	
endmodule
	