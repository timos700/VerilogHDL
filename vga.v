module vgasync(clk, reset, scancode, flagkey, hsync, vsync, vr, vg, vb, hpos, vpos);
input clk, reset, flagkey;
input [7:0] scancode;
output hsync, vsync;
output [2:0] vr, vg, vb;
output [9:0] hpos;
output [8:0] vpos;

reg [2:0] vr, vg, vb;
reg hsync, vsync;
reg [9:0] hpos, leftl, rightl;
reg [8:0] vpos, topl, bottoml;

parameter HorizontalFrontPorch = 16;
parameter HSYNCPulse = 96;
parameter HorizontalBackPorch = 48;
parameter VisiblePixels = 640;
parameter TotalPixels = 800;

parameter VerticalFrontPorch = 12;
parameter VSYNCPulse = 2;
parameter VerticalBackPorch = 35;
parameter VisibleRows = 400;
parameter TotalRows = 449;

parameter TopLine = 223;
parameter BottomLine = 238;
parameter LeftLine = 352;
parameter RightLine = 377;


always @(posedge clk or posedge reset) 
begin
	if (reset)
	begin
		topl <= TopLine;
		bottoml <= BottomLine;
		leftl <= LeftLine;
		rightl <= RightLine;
		hsync <= 1;
		vsync <= 0;
		hpos<=0;
		vpos<=0;
	end
	else
	begin
		if (flagkey == 1)
		begin
			case (scancode)
			8'h75: //press up
			begin
				if ((topl - 5 > VerticalBackPorch) && (bottoml < VerticalBackPorch + VisibleRows)) //vertical porches restrictions
				begin
					topl <= topl - 5;
					bottoml <= bottoml + 5;
				end
			end
			8'h72: //press down
			begin
				if (topl + 5 < bottoml - 5) //minimum size restrictions
				begin
					topl <= topl + 5;
					bottoml <= bottoml - 5;
				end
			end
			8'h6b: //press left
			begin
				if ((leftl - 5 > HorizontalBackPorch) && (rightl < HorizontalBackPorch + VisiblePixels)) //horizontal porches restrictions
				begin
					leftl <= leftl - 5;
					rightl <= rightl + 5;
				end
			end
			8'h74: //press right
			begin
				if (leftl + 5 < rightl - 5) //minimum size restrictions
				begin
					leftl <= leftl + 5;
					rightl <= rightl - 5;
				end
			end
			endcase
		end
		if (hpos == TotalPixels)
		begin
			hpos<=0;
			if (vpos == TotalRows)
				vpos<=0;
			else
				vpos<=vpos + 1;
		end
		else
			hpos<=hpos + 1;
		if (((hpos > leftl - 1 && hpos < leftl + 5) || (hpos > rightl - 1 && hpos < rightl + 5)) && ((vpos > topl - 1) && (vpos < bottoml + 5)))
		begin
			vr<=7;
			vg<=7;
			vb<=7;
		end
		else if (((vpos > topl - 1 && vpos < topl + 5) || (vpos > bottoml - 1 && vpos < bottoml + 5)) && ((hpos > leftl - 1) && (hpos < rightl + 5)))
		begin
			vr<=7;
			vg<=7;
			vb<=7;
		end
		else
		begin
			vr<=0;
			vg<=0;
			vb<=0;
		end
		if ((hpos > HorizontalBackPorch + VisiblePixels + HorizontalFrontPorch - 1) && (hpos < TotalPixels))
		hsync <= 0;
		else if (hpos == TotalPixels)
		hsync <= 1;

		if ((vpos == VerticalBackPorch + VisibleRows + VerticalFrontPorch) && (hpos == TotalPixels))
		vsync <= 1;
		else if ((vpos == TotalRows) && (hpos == TotalPixels))
		vsync <= 0;
	end
end
endmodule
	