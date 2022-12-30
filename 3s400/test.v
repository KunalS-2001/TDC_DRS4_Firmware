`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:27:56 12/29/2022
// Design Name:   oversamplerTDC
// Module Name:   C:/Users/hcal/Documents/TDC_Firmw_rev2/drs4eb/firmware/3s400/test.v
// Project Name:  drs4_eval5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: oversamplerTDC
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test;

	// Inputs
	reg CLK_IN;
	reg START_IN;
	reg STOP_IN;
	reg RESET_IN;

	// Outputs
	wire DATA_VALID;
	wire [15:0] TDC_OUTPUT;

	// Instantiate the Unit Under Test (UUT)
	oversamplerTDC uut (
		.CLK_IN(CLK_IN), 
		.START_IN(START_IN), 
		.STOP_IN(STOP_IN), 
		.RESET_IN(RESET_IN), 
		.DATA_VALID(DATA_VALID), 
		.TDC_OUTPUT(TDC_OUTPUT)
	);
	initial CLK_IN = 0;
	always #15	CLK_IN = ~ CLK_IN;
	initial begin
		// Initialize Inputs
		CLK_IN = 0;
		START_IN = 0;
		STOP_IN = 0;
		RESET_IN = 0;

		// Wait 100 ns for global reset to finish
		#100;
			START_IN = 1;
			STOP_IN = 0;
		#50
			START_IN = 0;
			STOP_IN = 0;
		#50
			START_IN = 0;
			STOP_IN = 1;
		#50
			START_IN = 0;
			STOP_IN = 0;
		#50
			$finish;
		  
		// Add stimulus here

	end
      
endmodule

