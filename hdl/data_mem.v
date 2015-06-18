`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:51:39 06/16/2015 
// Design Name: 
// Module Name:    data_mem 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module data_mem #(
	parameter DATA 	= 32,
	parameter ADDR 	= 15
)(
	input 						clka,  
	input 						wea , 
	input 		[ADDR-1:0]	addra,
	input 		[DATA-1:0] 	dina,  
	output reg	[DATA-1:0] 	douta  	
);


reg [DATA-1:0] mem [0:2**ADDR-1];

always @(posedge clka) begin
	mem[2] <= 32'h00000006;
	mem[0] <= 32'h00000004;
	
	if (wea) begin
	mem[addra] <= dina;
	end
	
	douta <= mem[addra];
end

endmodule
