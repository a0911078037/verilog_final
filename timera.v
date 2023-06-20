module timera(
	clk,
	rst_n,
	seg,
	sel
);
	input clk;
	input rst_n;
	output [7:0]seg;
	output [3:0]sel;

	wire  [2:0]       min_h;
	wire  [3:0]       min_l;
	wire  [2:0]       sec_h;
	wire  [3:0]       sec_l;
	wire              display_flag;

	time_counter t(
		.clk(clk),
		.rst_n(rst_n),
		.min_h(min_h),
		.min_l(min_l),
		.sec_h(sec_h),
		.sec_l(sec_l),
		.display_flag(display_flag)
	);
	
	display d(
		.rst_n(rst_n),
		.clk(clk),
		.min_h(min_h),      
		.min_l(min_l),
		.sec_h(sec_h),      
		.sec_l(sec_l),
		.display_flag(display_flag),
		.seg(seg),
		.sel(sel)
	);

endmodule 
