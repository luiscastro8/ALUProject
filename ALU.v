//========================================
//ALU Digial Abstraction State Labels
//Operation codes for differnt operations
//========================================
`define add 5'b00001
`define sub 5'b00010 
`define mult 5'b00011
`define div 5'b00100
`define sr 5'b00101
`define sl 5'b00110
`define anD 5'b00111
`define oR 5'b01000
`define xOr 5'b01001
`define nOt 5'b01010
`define nanD 5'b01011
`define noR 5'b01100
`define nxOr 5'b01101

//=======================================================
//ALU Triggers/Inputs
//Combinational logic inputs are enabled is enabled is 1
//Combinational logic inputs are disabled is enabled is 0
//=======================================================
`define enabled 1'b0
`define disabled 1'b1

module combinationalLogic(rst, noOp, cmd, sa, sb, so);
	input rst, noOp;
	input[4:0] cmd;
	output[1:0] sa, sb;
	output[3:0] so;

	assign sa = {rst, ~rst & ~noOp};
	assign sb = {rst | (~noOp & cmd[4]), ~rst & ~noOp};
	assign so = {rst | (~noOp & cmd[3]),
		     rst | (~noOp & cmd[2]),
		     rst | (~noOp & cmd[1]),
		     ~rst & ~noOp & cmd[0]};
endmodule

// Selector bit needs to be go through a decoder
module Mux16(a15, a14, a13, a12, a11, a10, a9, a8, a7, a6, a5, a4, a3, a2, a1, a0, s, b) ;
	parameter k = 32;
	input [k-1:0] a15, a14, a13, a12, a11, a10, a9, a8, a7, a6, a5, a4, a3, a2, a1, a0 ;
	input [15:0] s;
	output[k-1:0] b;
	assign b = ({k{s[0]}} & a15) |
                ({k{s[1]}} & a14) |
                ({k{s[2]}} & a13) |
                ({k{s[3]}} & a12) |
                ({k{s[4]}} & a11) |
                ({k{s[5]}} & a10) |
                ({k{s[6]}} & a9) |
                ({k{s[7]}} & a8) |
                ({k{s[8]}} & a7) |
                ({k{s[9]}} & a6) |
                ({k{s[10]}} & a5) |
                ({k{s[11]}} & a4) |
                ({k{s[12]}} & a3) | 
                ({k{s[13]}} & a2) | 
                ({k{s[14]}} & a1) |
                ({k{s[15]}} & a0) ;
endmodule

module Mux4(a3, a2, a1, a0, s, b) ;
	parameter k = 16;
	input [k-1:0] a3, a2, a1, a0 ;
	input [3:0] s;
	output[k-1:0] b;
	assign b = 
                ({k{s[0]}} & a3) | 
                ({k{s[1]}} & a2) | 
                ({k{s[2]}} & a1) |
                ({k{s[3]}} & a0) ;
endmodule

module ADD(a, b, out, overflow);
    input signed [15:0] a, b;
    output signed [31:0] out;
    output overflow;
    assign out = a + b;
    assign overflow = out[16];
endmodule

module SUB(a, b, out, underflow);
    input signed [15:0] a, b;
    output signed [31:0] out;
    output underflow;
    assign out = a - b;
endmodule

module MULT(a, b, out);
    input signed [15:0] a, b;
    output signed [31:0] out;
    assign out = a * b;
endmodule

module DIV(a, b, out, divByZero);
    input signed [15:0] a, b;
    output signed [31:0] out;
    output divByZero;
    assign divByZero = ~(|b);
    assign out = a / b;
endmodule

module SLL(a, b, out);
    input[15:0] a, b;
    output [31:0] out;
    assign out = a << b;
endmodule

module SRL(a, b, out);
    input[15:0] a, b;
    output [31:0] out;
    assign out = a >> b;
endmodule

module AND(a, b, out);
    input [15:0] a, b;
    output [31:0] out;
    assign out = a & b;
endmodule

module OR(a, b, out);
    input [15:0] a, b;
    output [31:0] out;
    assign out = a | b;
endmodule

module XOR(a, b, out);
    input [15:0] a, b;
    output [31:0] out;
    assign out = a ^ b;
endmodule

module NOT(a, out);
    input [15:0] a;
    output [31:0] out;
    assign out = ~a;
endmodule

module NAND(a, b, out);
    input [15:0] a, b;
    output [31:0] out;
    assign out = a ~& b;
endmodule

module NOR(a, b, out);
    input [15:0] a, b;
    output [31:0] out;
    assign out = a ~| b;
endmodule

module register (CLK, D, Q);
	parameter N=16;
	input CLK;
	input [N-1:0] D;
	output [N-1:0] Q;
	reg [N-1:0] Q;
	always @(posedge CLK)
	Q = D;
	//begin
	//$display(D);
	//end
endmodule // reg8

module accumulator (A, accum,overflow, clk, clr);
 parameter N=32;
 input [N-1:0] A;
 input clk, clr;
 output [N-1:0] accum;
 output reg overflow;

 reg [N-1:0] accum;

 always@(clk) begin
    if(clk) begin
        {overflow,accum} <= accum + A;
    end
    else if(~clr) begin
        accum = 8'b00000000;
    end
 end

endmodule

// This has been tested
module dec2 (in, out);
input [1:0] in;
output [3:0] out;
assign out = { in[1] & in[0],
				in[1] & ~in[0],
				~in[1] & in[0],
				~in[1] & ~in[0]				
};

endmodule


module dec4 (in, out);
input [3:0] in;
output [15:0] out;
assign out = { in[3] & in[2] & in[1] & in[0],
				in[3] & in[2] & in[1] & ~in[0],
				in[3] & in[2] & ~in[1] & in[0],
				in[3] & in[2] & ~in[1] & ~in[0],
				in[3] & ~in[2] & in[1] & in[0],
				in[3] & ~in[2] & in[1] & ~in[0],
				in[3] & ~in[2] & ~in[1] & in[0],
				in[3] & ~in[2] & ~in[1] & ~in[0],
				~in[3] & in[2] & in[1] & in[0],
				~in[3] & in[2] & in[1] & ~in[0],
				~in[3] & in[2] & ~in[1] & in[0],
				~in[3] & in[2] & ~in[1] & ~in[0],
				~in[3] & ~in[2] & in[1] & in[0],
				~in[3] & ~in[2] & in[1] & ~in[0],
				~in[3] & ~in[2] & ~in[1] & in[0],
				~in[3] & ~in[2] & ~in[1] & ~in[0]				
};

endmodule

module breadboard(CLK, A, B, CMD, RST, noOp, AcumOut, overflow, divByZero);

parameter n = 16;

input CLK, RST, noOp;
output [n*2-1:0]AcumOut;
output overflow, divByZero;

wire signed [n-1:0] Aout, Bout;
input [n-1:0] A, B;
input [4:0] CMD;
wire [n*2-1:0] AcumOut;
wire [n*2-1:0] MuxOut;
wire [n-1:0] MuxAout, MuxBout;
wire [3:0] so;
wire [15:0] soo;

// For calc modules
wire [(n*2)-1:0] addOut, subOut, SLOut, SROut, divOut, mulOut;
wire [(n*2)-1:0] andOut, orOut, xorOut, notOut; 

// The multplexor selectors
wire [1:0] sa, sb;
wire [3:0] soa, sob;

// The error wires
wire overflow;
wire divByZero;

dec2 DecA (sa, soa);
dec2 DecB (sb, sob);

Mux4 AMux (Aout, A, 16'b00000000, 16'b00000000, soa, MuxAout);
Mux4 BMux (Bout, B, 16'b00000000, AcumOut[15:0], sob, MuxBout);  

register regA (~CLK, MuxAout, Aout);
register regB (~CLK, MuxBout, Bout);

combinationalLogic CL(RST, noOp, CMD, sa, sb, so);

ADD add (Aout, Bout, addOut, overflow);
SUB sub(Aout, Bout, subOut, overflow);
MULT mult(Aout, Bout, mulOut);
DIV div(Aout, Bout, divOut, divByZero);
SLL sl(Aout, Bout, SLOut);
SRL sr(Aout, Bout, SROut);
AND anD(Aout, Bout, andOut);
OR oR(Aout, Bout, orOut);
XOR xOr(Aout, Bout, xorOut);
NOT noT(Aout, notOut);

dec4 DecO(so, soo);

Mux16 calcMux (AcumOut, addOut, subOut, mulOut, divOut, SROut, SLOut, 
andOut, orOut, xorOut, notOut, ~andOut, ~orOut, ~xorOut, 32'b00000000, 32'b00000000,
soo, MuxOut);

register #(32) Acum (CLK, MuxOut, AcumOut);

endmodule

module testbench();

// The inputs and outputs of the ALU
reg clk, rst, noOp;
reg [4:0] cmd;
reg [15:0] A, B;
wire [31:0] out;
wire overflow, divByZero;
wire signed [31:0] AcumOut; 

breadboard ALU (clk, A, B, cmd, rst, noOp, AcumOut, overflow, divByZero);
 

	//=============================================
	//The Display Thread with Clock Control
	//=============================================
	initial
		begin
			forever
				begin
					#5 
					clk = 0 ;
					#5
					clk = 1 ;
				end
		end
	
	//=============================================
	//The Display Thread with Clock Control
	//=============================================
	initial 
		begin
		#1 //Offset the Square Wave
		$display("Num1                     Num 2                    Operation Current Output                                     Next State");
			forever
					begin
					#10
					if(overflow == 1 || divByZero == 1)
					    $display("%16b (%5d) %16b (%5d)   %b   Running %16b %16b (%6d) ERROR", 
					    ALU.Aout, ALU.Aout, ALU.Bout, ALU.Bout, cmd, AcumOut[31:16], AcumOut[15:0], AcumOut);
					else    
					    $display("%16b (%5d) %16b (%5d)   %b   Running %16b %16b (%6d) Running", 
					    ALU.Aout, ALU.Aout, ALU.Bout, ALU.Bout, cmd, AcumOut[31:16], AcumOut[15:0], AcumOut);
					end
	end			
	

	
	initial
		begin
		#2 //Offset the Square Wave
		A = 16'd10; B = 16'd20; rst = 1; noOp = 0; cmd = 5'b0; // Setting the registers to zero with reset
		#10 
		rst = 0; noOp = 1;
		#10
		noOp = 0;
		cmd = `add; 
		#10
        cmd = `sub;
        #10
		cmd = 5'b10100; // The divide command, but load from the accumlator.
		#10
        cmd = `mult;
        #10
        cmd = `div;
        #10
        A = 16'd16; B = 16'd2;
        cmd = `sl;
        #10 
		cmd = `sr;
		#10
		A = 16'd15; B = 16'd7;
		cmd = `anD;
		#10
		cmd = `oR;
		#10
		cmd = `xOr;
		#10
		cmd = `nOt;
		#10
		cmd = `nanD;
		#10
		cmd = `noR;
		#10
		cmd = `nxOr;
		#10
		A = 16'd60000; B = 16'd6000;
		cmd = `add;
		#10
		B = 16'd0;
		cmd = `div;
		#10
		$finish;
		end
endmodule


