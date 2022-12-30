`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:40:33 12/29/2022
// Design Name:   CoarseCounter
// Module Name:   C:/Users/hcal/Documents/TDC_Firmw_rev2/drs4eb/firmware/3s400/trest.v
// Project Name:  drs4_eval5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CoarseCounter
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module trest;

	// Inputs
	reg clk_CC;
	reg start_CC;
	reg stop_CC;
	reg reset_CC;

	// Outputs
	wire Valid_CC;
	wire [11:0] CountOutCC;

	// Instantiate the Unit Under Test (UUT)
	CoarseCounter uut (
		.clk_CC(clk_CC), 
		.start_CC(start_CC), 
		.stop_CC(stop_CC), 
		.reset_CC(reset_CC), 
		.Valid_CC(Valid_CC), 
		.CountOutCC(CountOutCC)
	);

	initial clk_CC = 0;
	always #15	clk_CC = ~ clk_CC;
	initial begin
		// Initialize Inputs
		clk_CC = 0;
		start_CC = 0;
		stop_CC = 0;
		reset_CC = 0;

		// Wait 100 ns for global reset to finish
		#100;
			start_CC = 1;
			stop_CC = 0;
		#50
			start_CC = 0;
			stop_CC = 0;
		#50
			start_CC = 0;
			stop_CC = 1;
		#50
			start_CC = 0;
			stop_CC = 0;
		#50
			$finish;
		  
		// Add stimulus here

	end
      
endmodule