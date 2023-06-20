module cmp(
	input [7:0]datain,
	input [7:0]random_number,
	input random_btn,
	input clk,
	output big,
	output smal,
	output rst_n,
	output [7:0]xx
);

integer key=8'b10101010;

always @ (posedge random_btn)
begin
	key<=random_number;
end
assign xx=key;


assign smal=(datain<key);

assign big=(datain>key);

assign rst_n=~(datain==key);

endmodule 

