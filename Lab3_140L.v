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
//                     UCSD CSE Department
//                     9500 Gilman Dr, La Jolla, CA 92093
//                     U.S.A
//
// --------------------------------------------------------------------

module Lab3_140L (
		input wire       rst,             // reset signal (active high)
		input wire       clk,             // global clock
		input wire       bu_rx_data_rdy,  // data from the uart ready
		input wire [7:0] bu_rx_data,      // data from the uart
		output wire 	 L3_tx_data_rdy,  // data rdy to display
		output wire[7:0] L3_tx_data,      // data to display
		output wire[4:0] L3_led,          //5 LED control - 1: on, 0, off
		output wire      oneSecPluse,     //Generate 0.5 sec high and 0.5 sec low    	  
		output wire[6:0] L3_segment1,     //not used in Lab-2
		output wire[6:0] L3_segment2,     //not used in Lab-2
		output wire[6:0] L3_segment3,     //not used in Lab-2
		output wire[6:0] L3_segment4,     //not used in Lab-2

		output wire[3:0] di_Mtens,        //not used in Lab-2
		output wire[3:0] di_Mones,        //not used in Lab-2
		output wire[3:0] di_Stens,        //not used in Lab-2
		output wire[3:0] di_Sones,        //not used in Lab-2
		output wire[3:0] di_AMtens,       //not used in Lab-2
		output wire[3:0] di_AMones,       //not used in Lab-2
		output wire[3:0] di_AStens,       //not used in Lab-2
		output wire[3:0] di_ASones        //not used in Lab-2
    );
    wire[7:0] rx_data;
    wire rx_data_rdy;
    regrce #(8) Lab3U00 (
    .q(rx_data),
    .d(bu_rx_data),
    .ce(bu_rx_data_rdy),    //clock enable
    .rst(rst),              // synchronous reset
    .clk(clk)
    );
    regrce #(1) Lab3U01 (
    .q(rx_data_rdy),
    .d(bu_rx_data_rdy),
    .ce(1'b1),           //clock enable
    .rst(rst),           // synchronous reset
    .clk(clk)
    );
     
    // generate a sync signal
    //
    //                  | < ------- 1 sec -------|
    //
    //   oneSecStrb_____/----\_________......____/----\_______
    //
    //        clk  ___/--\__/--\__/--\.......__/--\__/--
    //
    wire l_oneSecPluse, l_oneSecStrb;
    Half_Sec_Pulse_Per_Sec secuu0 (
			.i_rst (rst),       //reset
			.i_clk (clk),       //system clk 12MHz 
            .o_sec_tick (l_oneSecPluse),
			.o_sec_enab (l_oneSecStrb)
        );

    wire dicSelectLEDdisp, dicRun;
    wire dicDspMtens, dicDspMones, dicDspStens, dicDspSones; //1:display, 0: don't display
    wire dicLdMtens, dicLdMones, dicLdStens, dicLdSones;     //1:load clk digit, 0: don't load
    wire alarmDspMtens, alarmDspMones, alarmDspStens, alarmDspSones;
    wire alarmLdMtens, alarmLdMones, alarmLdStens, alarmLdSones; 
    wire alarm_en;
    wire trig;

    dictrl dictrluu0(
        .dicSelectLEDdisp(dicSelectLEDdisp),
	    .dicRun(dicRun),             // clock should run
	    .dicDspMtens(dicDspMtens),   // 1: update 7 segment; 0: freeze 7 segment display
	    .dicDspMones(dicDspMones),   // 1: update 7 segment; 0: freeze 7 segment display
	    .dicDspStens(dicDspStens),   // 1: update 7 segment; 0: freeze 7 segment display
	    .dicDspSones(dicDspSones),   // 1: update 7 segment; 0: freeze 7 segment display
        .dicLdMtens(dicLdMtens),
        .dicLdMones(dicLdMones),
        .dicLdStens(dicLdStens),
        .dicLdSones(dicLdSones),

	.alarmDspMtens(alarmDspMtens),
	.alarmDspMones(alarmDspMones),
	.alarmDspStens(alarmDspStens),
	.alarmDspSones(alarmDspSones),

	.alarmLdMtens(alarmLdMtens),
	.alarmLdMones(alarmLdMones),
	.alarmLdStens(alarmLdStens),
	.alarmLdSones(alarmLdSones),

	.alarm_en(alarm_en),
		
        .rx_data_rdy(rx_data_rdy),// new data from uart rdy
        .rx_data(rx_data),        // new data from uart
        .rst(rst),
	    .clk(clk)
    );

   didp didpuu0(
        // output
	    .di_iMtens(di_Mtens), // current 10's minutes
	    .di_iMones(di_Mones), // current 1's minutes
	    .di_iStens(di_Stens), // current 10's second
	    .di_iSones(di_Sones), // current 1's second

	    .di_AMtens(di_AMtens), 
            .di_AMones(di_AMones),
            .di_AStens(di_AStens),
            .di_ASones(di_ASones),
        .o_oneSecPluse(oneSecPluse),
        .L3_led(L3_led),
		
		//loading clock
        .ldMtens(dicLdMtens), // set to 0 in lab3
        .ldMones(dicLdMones), // set to 0 in lab3
        .ldStens(dicLdStens), // set to 0 in lab3
        .ldSones(dicLdSones), // set to 0 in lab3

		//loading alarm
	.alarmLdMtens(alarmLdMtens), 
        .alarmLdMones(alarmLdMones), 
        .alarmLdStens(alarmLdStens), 
        .alarmLdSones(alarmLdSones),
            
	.trig(trig),
        .alarm_en(alarm_en), 


	
	    .ld_num(rx_data[3:0]), 
		
        .dicSelectLEDdisp(dicSelectLEDdisp),		
	    .dicRun(dicRun),                // 1: clock runs, 0: clock freeze 
        .i_oneSecPluse(l_oneSecPluse),	// 0.5 sec on, 0.5sec off
	    .i_oneSecStrb(l_oneSecStrb),    // one strobe per sec
	    .rst(rst),
	    .clk(clk) 	  
	);

    wire[6:0] test = 7'd0;
    wire[6:0] segment1Temp;
    wire[6:0] segment2Temp;
    wire[6:0] segment3Temp;
    wire[6:0] segment4Temp;

    // convert to the presentation of 7 segment display
    bcd2segment dec0 (.segment(segment1Temp), .num(di_Sones), .enable(dicDspSones));
    bcd2segment dec1 (.segment(segment2Temp), .num(di_Stens), .enable(dicDspStens));
    bcd2segment dec2 (.segment(segment3Temp), .num(di_Mones), .enable(dicDspMones));
    bcd2segment dec3 (.segment(segment4Temp), .num(di_Mtens), .enable(dicDspMtens));

    assign L3_segment1 = (trig)? ((~oneSecPluse)? test: segment1Temp): segment1Temp;
    assign L3_segment2 = (trig)? ((~oneSecPluse)? test: segment2Temp): segment2Temp;
    assign L3_segment3 = (trig)? ((~oneSecPluse)? test: segment3Temp): segment3Temp;
    assign L3_segment4 = (trig)? ((~oneSecPluse)? test: segment4Temp): segment4Temp;


    wire[7:0] b1 = (alarm_en)? {4'b0011,di_AMtens}:(alarmDspMtens)? {4'b0011,di_AMtens}: "-";
    wire[7:0] b2 = (alarm_en)? {4'b0011,di_AMones}:(alarmDspMones)? {4'b0011,di_AMones}: "-";
    wire[7:0] b3 = (alarm_en)? ":":(alarmDspMones)? ":" : "-";
    wire[7:0] b4 = (alarm_en)? {4'b0011,di_AStens}:(alarmDspStens)? {4'b0011,di_AStens}: "-";
    wire[7:0] b5 = (alarm_en)? {4'b0011,di_ASones}:(alarmDspSones)? {4'b0011,di_ASones}: "-";
    wire[7:0] b6 = (alarm_en)? (trig)? "T": "@": "-";


    dispString dspStr (
		  .rdy(L3_tx_data_rdy)
        , .dOut(L3_tx_data)
		, .b0("A") 
		, .b1(b1)
		, .b2(b2)
		, .b3(b3)
		, .b4(b4) 
		, .b5(b5)
		, .b6(b6)
		, .b7(8'h0d)
		, .go(l_oneSecStrb)	
		, .rst(rst)
		, .clk(clk)
    );
	
endmodule // Lab2_140L
