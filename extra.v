module extra(clk, reset, r1, g1, b1, hpos, vpos, scancode, flagkey, rout, gout, bout);
input [2:0] r1, g1, b1;
input [7:0] scancode;
input clk, reset, flagkey;
input [9:0] hpos;
input [8:0] vpos;
output [2:0] rout, gout, bout;

reg [2:0] rout, gout, bout, mask;
reg [25:0] counter;
reg fon, flash;

always @(posedge clk or posedge reset) 
begin
	if (reset)
	begin
		mask <= 0;
		rout <= r1;
		gout <= g1;
		bout <= b1;
		counter <= 0;
		fon <= 0;
		flash <= 0;
	end
	else
	begin
		if (counter == 0)//0.5Hz
		begin
			counter <= 49999999;
			fon <= ~fon;
		end
		else
		begin
			counter <= counter - 1;
		end
		if (flagkey == 1)
		begin
			case (scancode)
			8'h2b: //press F
			begin
				flash <= ~flash;
			end
			8'h2d: //press R
			begin
				mask <= ~mask;
			end
			endcase
		end
		if ((hpos > 48) && (hpos < 689) && (vpos > 35) && (vpos < 436)) //only in visible area
		begin
			if (flash == 1)
			begin
				if (fon == 1)
				begin
					if (mask == 0)
					begin
						rout <= 0;
						gout <= 0;
						bout <= 0;
					end
					else
					begin
						rout <= 7;
						gout <= 7;
						bout <= 7;
					end
				end
				else
				begin
					rout <= mask^r1;
					gout <= mask^g1;
					bout <= mask^b1;
				end
			end
			else
			begin
				rout <= mask^r1;
				gout <= mask^g1;
				bout <= mask^b1;
			end
		end
		else
		begin
			rout <= r1;
			gout <= g1;
			bout <= b1;
		end
	end
end

endmodule
