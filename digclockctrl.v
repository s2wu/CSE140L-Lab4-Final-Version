// --------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// --------------------------------------------------------------------
// Copyright (c) 2019 by UCSD CSE 140L
// --------------------------------------------------------------------
//
// Permission:
//
//   This code for use in UCSD CSE 140L.
//   It is synthesisable for Lattice iCEstick 40HX.  
//
// Disclaimer:
//
//   This Verilog source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  
//
// -------------------------------------------------------------------- //           
//                     Lih-Feng Tsaur
//                     Bryan Chin
//                     UCSD CSE Department
//                     9500 Gilman Dr, La Jolla, CA 92093
//                     U.S.A
//
// --------------------------------------------------------------------

module dictrl(
        output    dicSelectLEDdisp, //select LED
	output 	  dicRun,           // clock should run
	output 	  dicDspMtens,
	output 	  dicDspMones,
	output 	  dicDspStens,
	output 	  dicDspSones,
        output    dicLdMtens,
        output    dicLdMones,
        output    dicLdStens,
        output    dicLdSones,


       output 	  alarmDspMtens,
       output 	  alarmDspMones,
       output 	  alarmDspStens,
       output 	  alarmDspSones,


        output    alarmLdMtens,
        output    alarmLdMones,
        output    alarmLdStens,
        output    alarmLdSones,
        output    alarm_en,
		
        input 	    rx_data_rdy,// new data from uart rdy
        input [7:0] rx_data,    // new data from uart
        input 	  rst,
	input 	  clk
    );
//    assign dicLdMtens = 1'b0;
//    assign dicLdMones = 1'b0;
//    assign dicLdStens = 1'b0;
//    assign dicLdSones = 1'b0;
	
    wire   det_cr;
    wire   det_S;
    wire   det_A;
    wire   det_L;
    wire   det_num0to5;
    wire   det_num;
    wire   det_atSign;
   
    decodeKeys dek ( 
        .det_cr(det_cr),
	.det_S(det_S),
	.det_A(det_A),
	.det_L(det_L),
	.det_num0to5(det_num0to5),
	.det_num(det_num),
	.det_atSign(det_atSign),             
        .det_N(dicSelectLEDdisp),
	.charData(rx_data),      .charDataValid(rx_data_rdy)
    );

    
    dicClockFsm dicfsm (
            .dicRun(dicRun),
            .dicDspMtens(dicDspMtens), .dicDspMones(dicDspMones),
            .dicDspStens(dicDspStens), .dicDspSones(dicDspSones),
	    .dicLdMtens(dicLdMtens), .dicLdMones(dicLdMones),
            .dicLdStens(dicLdStens), .dicLdSones(dicLdSones),
	    .alarmDspMtens(alarmDspMtens), .alarmDspMones(alarmDspMones),
            .alarmDspStens(alarmDspStens), .alarmDspSones(alarmDspSones),
	    .alarmLdMtens(alarmLdMtens), .alarmLdMones(alarmLdMones),
            .alarmLdStens(alarmLdStens), .alarmLdSones(alarmLdSones),

	    .det_A(det_A),
	    .det_L(det_L),
	    .det_num0to5(det_num0to5),
	    .det_num(det_num),
	    .det_atSign(det_atSign),
            .det_cr(det_cr),
            .det_S(det_S), 
            .rst(rst),
            .clk(clk)
    );
   
endmodule


