/*
    Copyright (C) 2013-2021, Stephen J. Leary
    All rights reserved.
    
    This file is part of  TF330/TF120 (Terrible Fire 030 Accelerator).
 
	Attribution-NoDerivs 3.0 Unported

		CREATIVE COMMONS CORPORATION IS NOT A LAW FIRM AND DOES NOT PROVIDE
		LEGAL SERVICES. DISTRIBUTION OF THIS LICENSE DOES NOT CREATE AN
		ATTORNEY-CLIENT RELATIONSHIP. CREATIVE COMMONS PROVIDES THIS
		INFORMATION ON AN "AS-IS" BASIS. CREATIVE COMMONS MAKES NO WARRANTIES
		REGARDING THE INFORMATION PROVIDED, AND DISCLAIMS LIABILITY FOR
		DAMAGES RESULTING FROM ITS USE.

*/



module sdram_init(
	
	input				CLK,
	output  reg 		CLKE,
	input				RESET,
	output	reg [3:0] 	CMD,
	output 	reg [12:0]	ARAM,    // 13 bit multiplexed address bus
	output 	reg			READY,
	output  reg [13:0]	COUNTER, // single counter used to save space
	output  reg			REFRESH

);

`include "sdram_defines.v"

initial begin 
	COUNTER = 'd0;
end

parameter MODE = 0;

// startup timing
wire LOAD_MODE = 		{COUNTER[13:9]} == 5'b11000; // x2 load mode commands 
wire AUTO_REFRESH = 	{COUNTER[13:9]} == 5'b10110; // x2 auto refresh cmds
wire PRECHARGE = 		{COUNTER[13:8]}  == 6'b101000; // x1 precharge command

always @(posedge CLK or negedge RESET)  begin

	if (RESET == 1'b0) begin 
		COUNTER 	<= 'd0;
	end else begin 
		COUNTER <= COUNTER + 'd1;
	end

end

always @(posedge CLK or negedge RESET)  begin

	if (RESET == 1'b0) begin 
	
		READY		<= 'b1;
		REFRESH		<= 'b1;
		CLKE        <= 'b0;
		
		ARAM		<= 'd0;
		CMD 		<= CMD_INHIBIT; 
	
	end else begin 
	
		REFRESH <= ~COUNTER[7] | READY;
		CMD 	<= CMD_NOP; 
	
		if (READY == 1'b1) begin
			
			if (COUNTER[7:0] == 8'h00) begin 
			
				if(PRECHARGE == 1'b1) begin
					$display("precharging all banks");
					CMD			<= CMD_PRECHARGE;
					ARAM[10] 	<= 1'b1;      // precharge all banks
				end

				if(AUTO_REFRESH == 1'b1) begin
					$display("issuing auto refresh command");
					CMD			<= CMD_AUTO_REFRESH;
				end

				// last two cycles are mode loads
				if(LOAD_MODE == 1'b1) begin
					$display("loading mode register: %b", MODE);
					CMD 		<= CMD_LOAD_MODE;
					ARAM 		<= MODE;
				end

				// latch when the refresh period is complete
				READY <= ~(&COUNTER[13:11]);
				
				// Starting at some point during this 100μs period, bring CKE HIGH. Continuing at
				// least through the end of this period, 1 or more COMMAND INHIBIT or NOP commands
				// must be applied.
				if (COUNTER[13] == 1'b1) begin 

					CLKE <= 1'b1;

				end

			end

		end 
		
	end
	
end

endmodule
