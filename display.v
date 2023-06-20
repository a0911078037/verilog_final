// synopsys translate_off
`timescale 1 ns / 1 ps
// synopsys translate_on
module display(
    rst_n,
    clk,
    min_h,      
    min_l,
    sec_h,      
    sec_l,
    display_flag,
    seg,
    sel
    );
    input                   rst_n;                                     //   全局复位，低?平有效
    input                   clk;                                       //   全局??，50MHz
    input       [2:0]       min_h;                                     //   分的十位?
    input       [3:0]       min_l;                                     //   分的?位?
    input       [2:0]       sec_h;                                     //   秒的十位?
    input       [3:0]       sec_l;                                     //   秒的?位?
    input                   display_flag;                              //   ??管???示?志位
    output reg  [7:0]       seg;                                       //   ??后的??管?出
    output reg  [3:0]       sel;                                       //   ??管的位?
  
    function [7:0]  seg_data;
        input   [3:0]       din;                                       //   待???据
        input               dp;                                        //   ?定??管??是否?亮，1??亮
        
        begin
            case(din)
            4'd0 : seg_data = {dp,7'b0111111};
            4'd1 : seg_data = {dp,7'b0000110};
            4'd2 : seg_data = {dp,7'b1011011};
            4'd3 : seg_data = {dp,7'b1001111};
            4'd4 : seg_data = {dp,7'b1100110};
            4'd5 : seg_data = {dp,7'b1101101};
            4'd6 : seg_data = {dp,7'b1111101};
            4'd7 : seg_data = {dp,7'b0000111};
            4'd8 : seg_data = {dp,7'b1111111};
            4'd9 : seg_data = {dp,7'b1101111};
            default: seg_data = {dp,7'b0000000};
            endcase
        end
    endfunction
    
	wire flag;
	assign flag=(min_l>=3'b010);	// set bomb time (2min)
    reg         [1:0]       cnt;                                       //   由于只有四???管，故只需?位
    always @(posedge clk or negedge rst_n)
    begin
        if(rst_n == 1'b0)
            cnt <= (0);
        else if(display_flag == 1'b1)
            cnt <= cnt + 1'b1;
        else
            cnt <= cnt;
    end
    
  
    always @(posedge clk or negedge rst_n)
    begin
        if(rst_n == 1'b0)
        begin
            seg <= (0);
            sel <= (0);
        end
		else if(flag==1'b1) // bomb explode
			begin
				case(cnt)
					2'b00 :                                                    //   ?示秒?位?
					begin
						seg <= {1'b1,7'b0111001};
						sel <= 4'b0111;
					end
					
					2'b01 :                                                    //   ?示秒十位?
					begin
						seg <= {1'b1,7'b1011000};
						sel <= 4'b1011;
					end
					
					2'b10 :                                                    //   ?示分?位?
					begin
						seg <= {1'b1,7'b0111110};
						sel <= 4'b1101;
					end
					
					2'b11 :                                                    //   ?示分十位?
					begin
						seg <= {1'b1,7'b1110001};
						sel <= 4'b1110;
					end
				endcase
			end
        else
        begin
            case(cnt)
            2'b00 :                                                    //   ?示秒?位?
            begin
                seg <= seg_data(sec_l,1'b1);
                sel <= 4'b0111;
            end
            
            2'b01 :                                                    //   ?示秒十位?
            begin
                seg <= seg_data({1'b0,sec_h},1'b0);
                sel <= 4'b1011;
            end
            
            2'b10 :                                                    //   ?示分?位?
            begin
                seg <= seg_data(min_l,1'b1);
                sel <= 4'b1101;
            end
            
            2'b11 :                                                    //   ?示分十位?
            begin
                seg <= seg_data({1'b0,min_h},1'b0);
                sel <= 4'b1110;
            end
            endcase
        end
    end
  

endmodule

