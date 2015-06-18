`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    06:45:35 06/16/2015 
// Design Name: 
// Module Name:    controller 
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
module controller #(
	parameter INS_WIDTH = 32,
	parameter ALU_WIDTH = 37,
	parameter REG_WIDTH = 18,
	parameter MEM_WIDTH = 32,
	parameter REG_ADDR_WIDTH = 5,
	parameter MEM_ADDR_WIDTH = 15,
	parameter OP_WIDTH = 3
	
)(
	input [INS_WIDTH-1:0] IR,
	input clk,
	input [ALU_WIDTH-1:0] p,
	input [REG_WIDTH-1:0] reg_douta,
	input [REG_WIDTH-1:0] reg_doutb,
	input [MEM_WIDTH-1:0] mem_douta,
	output reg[REG_WIDTH-1:0] a, b,c,
	output reg[1:0] sel,
	output reg mem_wra,reg_wra,reg_wrb,
	output reg[REG_WIDTH-1:0] reg_dina,reg_dinb,
	output reg[MEM_WIDTH-1:0] mem_dina,
	output reg[REG_ADDR_WIDTH-1:0] reg_addra,reg_addrb,
	output reg[MEM_ADDR_WIDTH-1:0] mem_addra
    );
	 
wire [OP_WIDTH-1:0]opcode;
reg [1:0]state;
reg state1;
reg [REG_ADDR_WIDTH-1:0] R1,R2,R3;
reg [MEM_ADDR_WIDTH-1:0] r;	
wire [6:0] opcode_i; 

parameter 
	MUL 	= 3'b011,
	ADD 	= 3'b001,
	SUB 	= 3'b010,
	LOAD 	= 3'b100,
	STORE = 3'b101;

initial begin
//	opcode <= 3'b000;
	state <= 0;
	state1 <=0;
	reg_addra <= 0;
	reg_addrb <= 5'b00001;
	mem_addra <= 0;
	sel <= 0;
	reg_dina <= 0;
	reg_dinb <= 0;
	mem_dina <=0;
	reg_wra <=0;
	mem_wra<=0;
	reg_wrb <=0;
	
end
assign opcode_i = IR[31:25];
assign opcode = 	(opcode_i == 7'h1) ? MUL :
						(opcode_i == 7'h2) ? ADD :
						(opcode_i == 7'h4) ? SUB :
						(opcode_i == 7'h8) ? LOAD :
						(opcode_i == 7'h10) ? STORE : 0;
/*
always@(posedge clk)
begin
	opcode_i <= IR[31:25];
	case (opcode_i)
		7'h0  : opcode <= 0;
		7'h1  : opcode <= MUL;            //MULTIPLY
		7'h2  : opcode <= ADD;            //ADD
      7'h4  : opcode <= SUB;           //SUBTRACT
      7'h8  : opcode <= LOAD;           //LOAD
      7'h10 : opcode <= STORE;            //STORE
   endcase
end
*/
always@(posedge clk)
begin
	case(opcode)
		MUL: begin
			case(state)
				2'b00: begin
				
					R1 <= IR[24:20];
					R2 <= IR[19:15];
					R3 <= IR[14:10];
					state <= 2'b01;
				end
				2'b01: begin
					reg_wra 	<= 0;
					reg_wrb 	<= 0;
					reg_addra <= R1;
					reg_addrb <= R2;
					a     <= reg_douta;
					b     <= reg_doutb;
					c     <= 0;
					sel 	<= 2'b00;
					state <= 2'b10;
				end
				
				2'b10: begin
			
					reg_addra <= R3;
					reg_wra 	<= 1'b1;
					reg_dina	<= p;
				end
			endcase
		end
		
		ADD: begin
			case(state)
				2'b00: begin
					R1 <= IR[24:20];
					R2 <= IR[19:15];
					R3 <= IR[14:10];
					state <= 2'b01;
				end
				2'b01: begin
					reg_wra 	<= 0;
					reg_wrb 	<= 0;
					reg_addra <= R1;
					reg_addrb <= R2;
					a     <= reg_douta;
					c     <= reg_doutb;
					b     <= 0;
					sel 	<= 2'b01;
					state <= 2'b10;
				end
				
				2'b10: begin
					reg_addra <= R3;
					reg_wra 	<= 1'b1;
					reg_dina 	<= p;
				end
			endcase
		end
		
		SUB: begin
			case(state)
				2'b00: begin
					R1 <= IR[24:20];
					R2 <= IR[19:15];
					R3 <= IR[14:10];
					state <= 2'b01;
				end
				2'b01: begin
					reg_wra 	<= 0;
					reg_wrb 	<= 0;
					reg_addra <= R1;
					reg_addrb <= R2;
					c     <= reg_douta;
					a     <= reg_doutb;
					b     <= 0;
					sel 	<= 2'b10;
					state <= 2'b10;
				end
				
				2'b10: begin
					reg_addra <= R3;
					reg_wra 	<= 1'b1;
					reg_dina 	<= p;
				end
			endcase
		end
		
		LOAD: begin
			
			state1 <= 0;
			case(state1)
				1'b0: begin
					R1 <= IR[24:20];
					r  <= IR[19:5];
					state1 <= 1'b1;
				end
				1'b1: begin
					mem_addra<= r;
					mem_wra 	<= 0;
					reg_addra <= R1;
					reg_wra 	<= 1'b1;
					reg_dina 	<= mem_douta;
				end
			endcase
		end
		
		STORE: begin
			state1 <= 0;
			
			case(state1)
				1'b0: begin
					R1 <= IR[24:20];
					r  <= IR[19:5];
					state1 <= 1'b1;
				end
				1'b1: begin
					reg_addra <= R1;
					reg_wra 	<= 1'b0;
					mem_addra<= r;
					mem_wra 	<= 1'b1;
					mem_dina <= reg_douta ;
					
				end
			endcase
			
		end	
	endcase
end


endmodule
