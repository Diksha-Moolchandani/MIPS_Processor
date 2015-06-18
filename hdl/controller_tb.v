`timescale 1ns / 1ps
`define clkperiodby2 10
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:45:35 06/16/2015
// Design Name:   controller
// Module Name:   C:/Users/dell/Desktop/diksha/MIPS_Processor/controller_tb.v
// Project Name:  MIPS_Processor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module controller_tb;

	// Inputs
	reg [31:0] IR;
	reg clk;
	
	// Outputs

	// Instantiate the Unit Under Test (UUT)
	MIPS_uP uut (
		.IR(IR),
		.clk(clk)
		
	);

	initial begin
		// Initialize Inputs
		IR = 0;
		clk = 0;
		

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		IR = 32'h10000000;        //LOAD from maddr=0 to addra = 0
		#80
		IR = 32'b0001000_00010_000000000000010_00000;
		#80		
		/*IR = 32'h02010000;        //multiply addra =0 and addrb = 1 and store in addra=0
		#60
		IR = 32'h20000060;        //store from addra=0 to maadra=3
		#60
		IR = 32'h00000000;
		#40*/
		$stop;

	end
	always 
		#`clkperiodby2 clk <= ~clk;
		
endmodule

