`define T1MS 16'd49_999    		
`define FLASH_FREQUENCY 14'd500

module Led_Top
(
	input clk,rst_n,
	output[3:0] ledOut
);
	
	wire[3:0] isStart;
	wire[55:0] SetMSTimes;
	wire[3:0] isDone;
  
	Led_Control Led_Control 
	(
		.clk(clk),
		.rst_n(rst_n),
		.isDone(isDone),
		.isStart(isStart),
		.SetMSTimes(SetMSTimes)
	);
	Led_Driver Led_Driver[3:0]
	(
		.clk(clk),
		.rst_n(rst_n),
		.StartSig(isStart),
		.setMSTimes(SetMSTimes),
		.DoneSig(isDone),
		.ledOut(ledOut)
	);
endmodule

module Led_Control
(
	input clk,rst_n,
	input[3:0] isDone,
	output[3:0] isStart,
	output[55:0] SetMSTimes
);

	reg[3:0] i,j,k;
	reg[3:0] regStart;
	reg[13:0] regSetMSTimes[3:0];

	always@(posedge clk,negedge rst_n)
		if(!rst_n)   //3oE??��
			begin 
				i<=4'd0;
				j<=4'd0;
				k<=4'd0;
				regStart<=4'b0000;
				regSetMSTimes[0]<=14'd0;
				regSetMSTimes[1]<=14'd0;
				regSetMSTimes[2]<=14'd0;
				regSetMSTimes[3]<=14'd0;
			end
		else
			case(i)
				0:SerialLight(`FLASH_FREQUENCY,`FLASH_FREQUENCY,`FLASH_FREQUENCY,`FLASH_FREQUENCY);
				1:PipeLineLight(`FLASH_FREQUENCY,`FLASH_FREQUENCY,`FLASH_FREQUENCY,`FLASH_FREQUENCY);
				2:ParallelPipeLineLight(`FLASH_FREQUENCY,`FLASH_FREQUENCY,`FLASH_FREQUENCY,`FLASH_FREQUENCY);
				3:i<=4'd0;    //?OOAN-?�P
			endcase
	assign isStart=regStart;
	assign SetMSTimes={regSetMSTimes[3],regSetMSTimes[2],regSetMSTimes[1],regSetMSTimes[0]};
	task SerialLight
	(
		input[13:0] serialSetMSTimes0,serialSetMSTimes1,
						serialSetMSTimes2,serialSetMSTimes3
	);
		case(j)
				0:
					begin
						regSetMSTimes[0]<=serialSetMSTimes0;
						regSetMSTimes[1]<=serialSetMSTimes1;
						regSetMSTimes[2]<=serialSetMSTimes2;
						regSetMSTimes[3]<=serialSetMSTimes3;
						regStart[0]<=1'b1;
						j<=j+1'b1;
					end
				1:
					if(isDone[0])
						begin
							regStart[0]<=1'b0;
							regStart[1]<=regStart[0];
							j<=j+1'b1;
						end
				2:
					if(isDone[1])
						begin
							regStart[1]<=1'b0;
							regStart[2]<=regStart[1];
							j<=j+1'b1;
						end
				3:
					if(isDone[2])
						begin
							regStart[2]<=1'b0;
							regStart[3]<=regStart[2];
							j<=j+1'b1;
						end
				4:
					if(isDone[3])
						begin
							regStart[3]<=1'b0;
							k<=k+1'b1;
							if(k==4'd3)
								begin
									k<=4'd0;
									j<=j+1'b1;
								end
							else
								begin
									regStart[0]<=regStart[3];
									j<=4'd1;   
								end				
						end
				5:
					begin
						j<=4'd0;
						i<=i+1'b1;
					end
			endcase
	endtask
	task PipeLineLight
	(
		input[13:0] PipeLineSetMSTimes0,PipeLineSetMSTimes1,
						PipeLineSetMSTimes2,PipeLineSetMSTimes3
	);
		case(j)
				0:
					begin
						regSetMSTimes[0]<=PipeLineSetMSTimes0;
						regSetMSTimes[1]<=PipeLineSetMSTimes1;
						regSetMSTimes[2]<=PipeLineSetMSTimes2;
						regSetMSTimes[3]<=PipeLineSetMSTimes3;
						regStart[0]<=1'b1;
						j<=j+1'b1;
					end
				1:
					if(isDone[0])
						begin
							regStart[0]<=1'b1;
							regStart[1]<=regStart[0];
							regStart[2]<=regStart[1];
							regStart[3]<=regStart[2];
							
							k<=k+1'b1;
							if(k==4'd2)
								begin
									k<=4'd0;
									j<=j+1'b1;
								end
							else
								j<=j;
						end
				2:
					if(isDone[3])
						begin
							regStart[0]<=1'b0;
							regStart[1]<=regStart[0];
							regStart[2]<=regStart[1];
							regStart[3]<=regStart[2];
							k<=k+1'b1;
							if(k==4'd3)
								begin
									k<=4'd0;
									j<=j+1'b1;
								end
							else
								j<=j;
						end
				3:
					begin
						j<=4'd0;
						i<=i+1'b1;
					end
			endcase
	endtask
	task ParallelPipeLineLight
	(
		input[13:0] PipeLineSetMSTimes0,PipeLineSetMSTimes1,
						PipeLineSetMSTimes2,PipeLineSetMSTimes3
	);
		case(j)
				0:
					begin
						regSetMSTimes[0]<=PipeLineSetMSTimes0;
						regSetMSTimes[1]<=PipeLineSetMSTimes1;
						regSetMSTimes[2]<=PipeLineSetMSTimes2;
						regSetMSTimes[3]<=PipeLineSetMSTimes3;
						regStart[0]<=1'b1;
						regStart[2]<=1'b1;
						j<=j+1'b1;
					end
				1:
					if(isDone[0])
						begin
							regStart[0]<=1'b1;
							regStart[1]<=regStart[0];
							regStart[2]<=1'b1;
							regStart[3]<=regStart[2];
							k<=k+1'b1;
							if(k==4'd0)
								begin
									k<=4'd0;
									j<=j+1'b1;
								end
							else
								j<=j;
						end
				2:
					if(isDone[1])
						begin
							regStart[0]<=1'b0;
							regStart[1]<=regStart[0];
							regStart[2]<=1'b0;
							regStart[3]<=regStart[2];
							k<=k+1'b1;
							if(k==4'd1)
								begin
									k<=4'd0;
									j<=j+1'b1;
								end
							else
								j<=j;
						end
				3:
					begin
						j<=4'd0;
						i<=i+1'b1;
					end
			endcase
	endtask
endmodule

module Led_Driver
(
	input clk,rst_n,
	input StartSig,
	input[55:0] setMSTimes,
	output DoneSig,
	output ledOut
);

	wire[13:0] halrSetMSTimes;
	wire timerOut;
	Led_Driver_Control Led_Driver_Control
	(
		.clk(clk),
		.rst_n(rst_n),
		.StartSig(StartSig),
		.setMSTimes(setMSTimes),
		.timerOut(timerOut),
		.DoneSig(DoneSig),
		.halrSetMSTimes(halrSetMSTimes)
	);

											  //IECo3oOO�M��E�gAy�gA��UI?Ey�G?E?oo�X��A?�MoE�gAy?OO|I?��O�gI�g?�Ms?O?I�G?A?OD�MsI?�gA?IECOO�M��
	Timer Timer							  //A?�MosetMSTimesOD14I?�G?4�MoTimerOD14*4=56I?setMSTimes�G?
	(										  //Oo�MosetMSTimes�M3O�gIa56I?�G?setMSTimes?a�X��?OO|I??O?I�G?
		.clk(clk),						  //setMSTimes[0]?OO|[13:0]I?�G?setMSTimes[1]?OO|[27:14]I?
		.rst_n(rst_n),					  //setMSTimes[2]?OO|[41:28]I?�G?setMSTimes[3]?OO|[55:42]I?
		.StartSig(StartSig),
		.setMSTimes(halrSetMSTimes),  
		.timerOut(timerOut)
	);

	Led_Interface Led_Interface
	(
		.clk(clk),
		.rst_n(rst_n),
		.StartSig(StartSig),
		.timerIn(timerOut),
		.ledOut(ledOut)
	);
	
endmodule


module Led_Driver_Control
(
	input clk,rst_n,
	input StartSig,
	input[13:0] setMSTimes,
	input timerOut,
	output DoneSig,
	output[13:0] halrSetMSTimes
);
	
	
	reg countTimerOut;
	
	always@(posedge clk,negedge rst_n)  //?OE��OO?AEy�G?AD?IC�XO?�Mo�gA�gAAAAe
		if(!rst_n)
			countTimerOut<=1'b0;
		else if(StartSig)
			begin
				if(timerOut && (countTimerOut==1'b1) )
					countTimerOut<=1'b0;
				else if(timerOut)
					countTimerOut<=countTimerOut+1'b1;
			end
		else
			countTimerOut<=1'b0;
	
	assign DoneSig=(StartSig && timerOut && (countTimerOut==1'b1) )?1'b1:1'b0;	
	assign halrSetMSTimes=setMSTimes>>1;

endmodule


module Timer
(
	input clk,rst_n,
	input[13:0] setMSTimes,
	input StartSig,
	output timerOut
);

	wire MSOut;

	MSTimer MSTimer
	(
		.clk(clk),
		.rst_n(rst_n),
		.StartSig(StartSig),
		.MSOut(MSOut)
	);

	NMSTimer NMSTimer
	(
		.clk(clk),
		.rst_n(rst_n),
		.setMSTimes(setMSTimes),
		.StartSig(StartSig),
		.MSIn(MSOut),
		.NMSOut(timerOut)
	);
		
endmodule

module MSTimer
(
	input clk,rst_n,
	input StartSig,
	output MSOut
);
	reg[15:0] countMS;
	always@(posedge clk,negedge rst_n)
		if(!rst_n)
			countMS<=16'd0;
		else if(StartSig)
			begin
				if(countMS == `T1MS)
					countMS<=16'd0;
				else
					countMS<=countMS+1'b1;
			end
		else
			countMS<=16'd0;
			
	assign MSOut=(StartSig && (countMS == `T1MS) )?1'b1:1'b0;

endmodule

module NMSTimer
(
	input clk,rst_n,
	input MSIn,
	input StartSig,
	input[13:0] setMSTimes,
	output NMSOut
);

	reg[13:0] countNMS;   	
	always@(posedge clk,negedge rst_n) 
		if(!rst_n)
			countNMS<=14'd0;
		else if(StartSig)
			begin
				if(MSIn && (countNMS==(setMSTimes-1'd1) ) )   
					countNMS<=14'd0;								 	 
				else if(MSIn)
					countNMS<=countNMS+1'b1;
			end
		else
			countNMS<=14'd0;
			
	assign NMSOut=(StartSig && MSIn && (countNMS==(setMSTimes-1'd1) ) )?1'b1:1'b0;

endmodule

module Led_Interface
(
	input clk,rst_n,
	input StartSig,
	input timerIn,
	output ledOut
);

	reg regLedOut;
	
	always@(posedge clk,negedge rst_n)
		if(!rst_n)
			regLedOut<=1'b0;
		else if(StartSig)
			begin
				if(timerIn)
					regLedOut<=~regLedOut;
			end
		else
			regLedOut<=1'b0;
	
	assign ledOut=regLedOut;

endmodule 