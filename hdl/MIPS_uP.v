`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:46:13 06/16/2015 
// Design Name: 
// Module Name:    MIPS_uP 
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
module MIPS_uP #(
	parameter INS_WIDTH = 32,
	parameter ALU_WIDTH = 37,
	parameter REG_WIDTH = 18,
	parameter MEM_WIDTH = 32,
	parameter REG_ADDR_WIDTH = 5,
	parameter MEM_ADDR_WIDTH = 15,
	parameter OP_WIDTH = 3
	
)(
		input clk,
		output [ALU_WIDTH-1:0] p,
		input [INS_WIDTH-1:0] IR
    );
	 
	 
//wire [35:0] CONTROL0;	 
wire wra, wrb, mwra;
wire [REG_ADDR_WIDTH-1:0] addra,addrb;
wire [MEM_ADDR_WIDTH-1:0] maddra;
wire [REG_WIDTH-1:0] douta,doutb;
wire [REG_WIDTH-1:0] dina,dinb;
wire [MEM_WIDTH-1:0] mdouta;
wire [MEM_WIDTH-1:0] mdina;
wire [1:0] sel;
wire [REG_WIDTH-1:0] a,b,c;
//wire [31:0] IR;
//wire [36:0] p;

controller control_mips(
	.IR(IR),
	.clk(clk),
	.p(p),
	.reg_douta(douta),
	.reg_doutb(doutb),
	.mem_douta(mdouta),
	.a(a),
	.b(b),
	.c(c),
	.sel(sel),
	.mem_wra(mwra),
	.reg_wra(wra),
	.reg_wrb(wrb),
	.reg_dina(dina),
	.reg_dinb(dinb),
	.mem_dina(mdina),
	.reg_addra(addra),
	.reg_addrb(addrb),
	.mem_addra(maddra)
);

alu1 alu (
	//.clk(clk), // input clk
	.sel(sel), // input [1 : 0] sel
	.a(a), // input [17 : 0] a
	.b(b), // input [17 : 0] b
	.c(c), // input [17 : 0] c
	.p(p)); // ouput [36 : 0] p
	
reg_file reg_file (
  .clka(clk), // input clka
  .wea(wra), // input [0 : 0] wea
  .addra(addra), // input [4 : 0] addra
  .dina(dina), // input [17 : 0] dina
  .douta(douta), // output [17 : 0] douta
  .clkb(clk), // input clkb
  .web(wrb), // input [0 : 0] web
  .addrb(addrb), // input [4 : 0] addrb
  .dinb(dinb), // input [17 : 0] dinb
  .doutb(doutb) // output [17 : 0] doutb
);

data_mem data_mem (
  .clka(clk), // input clka
  .wea(mwra), // input [0 : 0] wea
  .addra(maddra), // input [11 : 0] addra
  .dina(mdina), // input [31 : 0] dina
  .douta(mdouta) // output [31 : 0] douta
 ); 
 
/* 
virtualio vio(
    .CONTROL(CONTROL0), // INOUT BUS [35:0]
    .CLK(clk), // IN
    .SYNC_IN(p), // IN BUS [36:0]
    .SYNC_OUT(IR) // OUT BUS [31:0]
);

icon icon (
    .CONTROL0(CONTROL0) // INOUT BUS [35:0]
);*/
endmodule
