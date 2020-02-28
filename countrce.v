
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
// clock enabled counter
//
module countrce #(parameter WIDTH = 4)
   (
    output reg [WIDTH-1:0] q,
    input wire [WIDTH-1:0] d,
    input wire             ld, // load the counter
    input wire		       ce, //clock enable
    input wire		       rst, // synchronous reset
    input wire		       clk
    );

    // count.1 add code to replace q+1
    //         20% of points assigned to Lab3
	    wire [WIDTH-1:0] test;

	    N_bit_counter uu0(
    	    .result (test[WIDTH-1:0])     // Output
   	    ,.r1 (ld)        // input
   	    ,.up (1'b1)
   	    );

    // sequential logic
    always @(posedge clk) begin
        if (rst)
            q <= {WIDTH{1'b0}};
        else begin
        if (~ce)
            q <= q;
        else
        if (ld)
            q <= d;
        else
            // q <= q+1; // **** replace this
	    q[0] = !d[0];
	    q[1] = d[1]^ d[0];
	    q[2] = d[2]^(d[1] & d[0]);
	    q[3] = d[3]^(d[2] & d[1] & d[0]);
	    //q <= test;

	    
        end
   end
endmodule

