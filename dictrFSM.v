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
//
//Finite State Machine of Control Path
// using 3 always 
module dicClockFsm (
		output reg dicRun,     // clock is running
		output reg dicDspMtens,
		output reg dicDspMones,
		output reg dicDspStens,
		output reg dicDspSones,

		output reg dicLdMtens,
        	output reg dicLdMones,
        	output reg dicLdStens,
        	output reg dicLdSones,

        	output reg alarmDspMtens,
		output reg alarmDspMones,
		output reg alarmDspStens,
		output reg alarmDspSones,

       		output reg alarmLdMtens,
        	output reg alarmLdMones,
        	output reg alarmLdStens,
        	output reg alarmLdSones,
        	output reg alarm_en,
	
        input      det_cr,
        input      det_S,      // S/s detected
	input      det_L,
        input      det_A,
        input      det_num0to5,
        input      det_num,
        input      det_atSign,


		input      rst,
		input      clk
    );

    reg  [3:0]cState;
    reg  [3:0]nState;
    reg cAlarm;
    reg nAlarm;



    // only 2 states:
    //  RUN: dicRun = 1;  dicDspMtens = 1; dicDspMones = 1; dicDspStens = 1; dicDspSones= 1;
    //  STOP: dicRun = 0; dicDspMtens = 1; dicDspMones = 1; dicDspStens = 1; dicDspSones= 1;
    
    localparam
    STOP    =4'd0, 
    RUN     =4'd1,
    L1 = 4'd2,
    L2 = 4'd3,
    L3 = 4'd4,
    L4 = 4'd5,
    L5 = 4'd6,
    A1 = 4'd7,
    A2 = 4'd8,
    A3 = 4'd9,
    A4 = 4'd10,
    A5 = 4'd11,

    DeactivateAlarm = 1'd0,
    ActivateAlarm = 1'd1;
   
   
    always @(*) begin
        if (rst)
	        nState = STOP;
		nAlarm = DeactivateAlarm;
        else begin
        case (cState)
            RUN : 
	    begin
            	if(det_cr)
		    nState = STOP;
		else if (det_A)
		    nState = A1;
		else if (det_L)
		    nState = L1;
            	else 
		    nState = RUN; 
            end

            STOP: 
	    begin
            	if(det_S) 
		    nState = RUN;
		else if (det_A)
		    nState = A1;
		else if (det_L)
		    nState = L1;
            	else 
		    nState = STOP;
            end
	    L1: 
	    begin
            	if(det_num0to5)
            	    nState = L2;
            	else 
		    nState = L1;
            end

            L2: 
	    begin
            	if(det_num)
            	    nState = L3;
            	else 
		    nState = L2;
            end

            L3: 
	    begin
            	if(det_num0to5)
            	    nState = L4;
            	else 
		    nState = L3;
            end

            L4: 
	    begin
            	if(det_num)
            	    nState = L5;
            	else 
		    nState = L4;
            end

            L5:
	    begin
            	if(det_cr) 
		    nState = STOP;
            	else if(det_S) 
		    nState = RUN;
            	else 
		    nState = L5;
            end

            A1: 
	    begin
            	if(det_num0to5)
            	    nSate = A2;
            	else 
		    nState = A1;
            end

            A2: 
	    begin
            	if(det_num) 
		    nState = A3;
            	else 
		    nState = A2;
            end


            A3: 
	    begin
            	if(det_num0to5) 
		    nState = A4;
            	else 
		    nState = A3;
            end

            A4: 
	    begin
            	if(det_num) 
		    nState = A5;
            	else 
		    nState = A4;
            end

            A5:
	    begin
            	if(det_cr) 
		    nState = STOP;
		else if(det_S)
		    nLoad = RUN;

            	else 
		    nLoad = A5;
            end

            //default: 
	    //begin
            	//nState = RUN;
            //end
        endcase

        case(cAlarm)
            DeactivateAlarm: 
	    begin
            	if(det_atSign)
		    nAlarm = ActivateAlarm;
            	else 
		    nAlarm = DeactivateAlarm;
            end

            ActivateAlarm: 
	    begin
            	if(det_atSign)
		    nAlarm = DeactivateAlarm;
            	else 
		    nAlarm = ActivateAlarm;
            end

            //default:
            	//nAlarm = DeactivateAlarm;
        endcase

        end
    end

    //
    // state machine outputs
    //
    //FSM.2 add code to set the output signals of 
    //      STOP and RUN states
	//      5% of points assigned to Lab3

    //**TODO
    always @(*) begin
        dicDspMtens = 1;
        dicDspMones = 1;
        dicDspStens = 1;
        dicDspSones = 1;
        dicLdMtens = 0;
        dicLdMones = 0;
        dicLdStens = 0;
        dicLdSones = 0;
        alarmDspMtens = 0;
        alarmDspMones = 0;
        alarmDspStens = 0;
        alarmDspSones = 0;
        alarmLdMtens = 0;
        alarmLdMones = 0;
        alarmLdStens = 0;
        alarmLdSones = 0;
        alarm_en = 0;
        case(cState)
            L1: begin
            //dicDspMtens = 1;
            dicDspMones = 0;
            dicDspStens = 0;
            dicDspSones = 0;
            dicLdMtens = det_num0to5;
            end

            L2: begin
            //dicDspMtens = 1;
            //dicDspMones = 1;
            dicDspStens = 0;
            dicDspSones = 0;
            dicLdMones = det_num;
            end

            L3: begin
           //dicDspMtens = 1;
           //dicDspMones = 1;
           //dicDspStens = 1;
            dicDspSones = 0;
            dicLdStens = det_num0to5;
            end

            L4: begin
            //dicDspMtens = 1;
            //dicDspMones = 1;
            //dicDspStens = 1;
            //dicDspSones = 1;
            dicLdSones = det_num;
            end

            L5: begin
            //dicDspMtens = 1;
            //dicDspMones = 1;
            //dicDspStens = 1;
            //dicDspSones = 1;
            end

            A1: begin
            alarmDspMtens = 1;
            alarmLdMtens = det_num0to5;
            end

            A2: begin
            alarmDspMtens = 1;
            alarmDspMones = 1;
            alarmLdMones = det_num;
            end

            A3: begin
            alarmDspMtens = 1;
            alarmDspMones = 1;
            alarmDspStens = 1;
            alarmLdStens = det_num0to5;
            end

            A4: begin
            alarmDspMtens = 1;
            alarmDspMones = 1;
            alarmDspStens = 1;
            alarmDspSones = 1;
            alarmLdSones = det_num;
            end

            A5: begin
            alarmDspMtens = 1;
            alarmDspMones = 1;
            alarmDspStens = 1;
            alarmDspSones = 1;
            end

        endcase
        case(cAlarm)
            ActivateAlarm: begin
            	alarm_en = 1;
            end
            DeactivateAlarm: begin
            	alarm_en = 0;
            end
        endcase
   end


   
   always @(*)begin
        if(rst)
	    dicRun = 0;
        else begin
        case(cState)
            STOP: dicRun = 0;
            RUN: dicRun = 1;
            default: dicRun = dicRun;
        endcase
        end
   end



   always @(posedge clk) begin
      cState <= nState;
      cAlarm <= nAlarm;
   end

endmodule