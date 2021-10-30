`timescale 1ns / 1ps

/*
    Copyright (C) 2020-2021, Stephen J. Leary
    All rights reserved.
    
    This file is part of  TF330/TF120 (Terrible Fire 030 Accelerator).

    TF330/TF120 is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    TF330/TF120 is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty     You should have received a copy of the GNU General Public Licenseof
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.


    along with TF330/TF120. If not, see <http://www.gnu.org/licenses/>.
*/

module tf1230r1_main_top(

           inout 	 RESET,
           inout 	 HALT,

           // all clock lines.
           inout 	 CLK14M,
           inout 	 CLK100M,
           inout 	 CLKCPU,
           inout 	 CLKRAM,

           inout [31:0]  A,
           inout [31:24] D,

           //  SDRAM Control
           inout 	 CLKRAME,
           inout [12:0]  ARAM,
           inout [1:0] 	 BA,
           inout 	 CAS,
           inout [3:0] 	 DQM,
           inout 	 RAMWE,
           inout 	 RAS,
           inout 	 RAMCS,
           inout 	 RAMOE,

           // transfer control lines
           inout [1:0] 	 SIZ,
           input [2:0] 	 FC,
           inout [2:0] 	 IPL,

           // cache control lines.
           inout 	 CBREQ,
           inout 	 CBACK,
           inout 	 CIIN,

           // 68030 control lines
           inout 	 AS30,
           inout 	 DS30,
           inout 	 RW30,

           inout [1:0] 	 DS30ACK,
           inout 	 STERM,

           inout 	 BGACK30,
           inout 	 BR30,
           inout 	 BG30,

           // A1200 / 68020 control lines
           inout 	 AS20,
           inout 	 DS20,
           inout 	 RW20,

           input 	 BR20,
           input 	 BG20,

           inout [1:0] 	 DSACK,

            output [5:2]     AB,
           inout 	 IOW,
           inout 	 IOR,

           inout 	 IDEINT,
           inout 	 IDEWAIT,
	         inout [1:0] 	 IDECS,
           inout 	 PUNT,
           inout 	 BERR,

           output            CFGOUT,
           input            RSTO, 
           inout 	 INT2

       );

// Instantiate the module
main_top MAIN (
		.RESET   ( RESET  ), 
		.HALT    ( HALT   ), 
		.CLK14M  ( CLK14M ), 
		.CLK100M ( CLK100M), 
		.CLKCPU  ( CLKCPU ), 
		.CLKRAM  ( CLKRAM ), 
		.A       ( A      ), 
		.D       ( D      ), 
		.CLKRAME ( CLKRAME), 
		.ARAM    ( ARAM   ), 
		.BA      ( BA     ), 
		.CAS     ( CAS    ), 
		.DQM     ( DQM    ), 
		.RAMWE   ( RAMWE  ), 
		.RAS     ( RAS    ), 
		.RAMCS   ( RAMCS  ), 
		.RAMOE   ( RAMOE  ), 
		.SIZ     ( SIZ    ), 
		.FC      ( FC     ), 
		.IPL     ( IPL    ), 
		.CBREQ   ( CBREQ  ), 
		.CBACK   ( CBACK  ), 
		.CIIN    ( CIIN   ), 
		.AS30    ( AS30   ), 
		.DS30    ( DS30   ), 
		.RW30    ( RW30   ), 
		.DS30ACK ( DS30ACK), 
		.STERM   ( STERM  ), 
		.BGACK30 ( BGACK30), 
		.BR30    ( BR30   ), 
		.BG30    ( BG30   ), 
		.AS20    ( AS20   ), 
		.DS20    ( DS20   ), 
		.RW20    ( RW20   ), 
		.BG20    ( BG20   ),  
		.DSACK   ( DSACK  ), 
		.IOW     ( IOW    ), 
		.IOR     ( IOR    ), 
		.IDEINT  ( IDEINT ), 
		.IDEWAIT ( IDEWAIT), 
      
		.IDECS   ( IDECS  ), 
		.PUNT    ( PUNT   ), 
		.BERR    ( BERR   ), 
		.INT2    ( INT2   ),

      .EXP_BR  ( 1'b1   ),
      .EXP_BG  (        ),
      
      .IDELED  ( 1'b1   ),
      .ACTIVE  (        ),

      .DISABLE ( BR20   ),

      // Serial port not present. 
      .RXD_EXT (        ),
      .RXD     (        ),
      .TXD_EXT (        ),
      .TXD     (        )
	);

assign AB[5:2]  = {A[5:2]};
assign CFGOUT = 1'b1;

endmodule
