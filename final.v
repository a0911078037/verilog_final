module final(
	input clk,
	input [7:0] datain,
	input random_btn,
	output big,
	output smal,
	output [7:0] seg,
	output [3:0] sel,
	output [3:0] led_out,
	output [7:0]key
);

wire rst_n;
wire [7:0]random_number;
wire [7:0] xx;

assign key=xx;
lfsr r(
	.R(random_number),
	.clk(clk),
	.seed(10110111)
);

cmp c(
	.datain(datain),
	.big(big),
	.smal(smal),
	.rst_n(rst_n),
	.random_number(random_number),
	.random_btn(random_btn),
	.clk(clk),
	.xx(xx)
);

timera t(
	.rst_n(rst_n),
	.clk(clk),
	.seg(seg),
	.sel(sel)
);

Led_Top l(clk,~rst_n,led_out);


endmodule 

