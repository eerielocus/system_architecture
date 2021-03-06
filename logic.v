// Name: logic.v
// Module: 
// Input: 
// Output: 
//
// Notes: Common definitions
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
// 64-bit two's complement
module TWOSCOMP64(Y,A);
// output list
output [63:0] Y;
// input list
input [63:0] A;
// wire
wire [63:0] NOT;
wire CO;
// register
reg [63:0] ONE = 64'b1;
reg SnA = 0;

genvar i;
generate
   for (i = 0; i < 64; i = i + 1)
   begin
      not NOT_INST(NOT[i], A[i]);
   end
endgenerate

RC_ADD_SUB_64 ADD_INST(Y, CO, NOT, ONE, SnA);

endmodule

// 32-bit two's complement
module TWOSCOMP32(Y,A);
// output list
output [31:0] Y;
// input list
input [31:0] A;
// wire
wire [31:0] NOT;
wire CO;
// register
reg [31:0] ONE = 32'b1;
reg SnA = 0;

genvar i;
generate
   for (i = 0; i < 32; i = i + 1)
   begin
      not NOT_INST(NOT[i], A[i]);
   end
endgenerate

RC_ADD_SUB_32 ADD_INST(Y, CO, NOT, ONE, SnA);
endmodule

// PC/SP register
module REG32_PP(Q, D, LOAD, CLK, RESET);
parameter PATTERN = 32'h00000000;
// output
output [31:0] Q;
// input
input CLK, LOAD;
input [31:0] D;
input RESET;
// wire
wire [31:0] Qbar;

genvar i;
generate
for(i = 0; i < 32; i = i + 1)
     begin : reg32_gen_loop
    if (PATTERN[i] == 0)
        REG1 reg_inst(.Q(Q[i]), .Qbar(Qbar[i]), .D(D[i]), .L(LOAD), .C(CLK), .nP(1'b1), .nR(RESET));
    else
        REG1 reg_inst(.Q(Q[i]), .Qbar(Qbar[i]), .D(D[i]), .L(LOAD), .C(CLK), .nP(RESET), .nR(1'b1));
    end
endgenerate
endmodule 

// 32-bit registere +ve edge, Reset on RESET=0
module REG32(Q, D, LOAD, CLK, RESET);
// output
output [31:0] Q;
// input
input CLK, LOAD;
input [31:0] D;
input RESET;
// wire
wire [31:0] Qbar;

genvar i;
generate
   for (i = 0; i < 32; i = i + 1)
   begin
      REG1 REG_INST(Q[i], Qbar[i], D[i], LOAD, CLK, 1'b1, RESET);
   end
endgenerate
endmodule

// 1 bit register +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module REG1(Q, Qbar, D, L, C, nP, nR);
// input
input D, C, L;
input nP, nR;
// output
output Q, Qbar;
// wire
wire MUX, Q_OUT;

MUX1_2x1 MX_INST(MUX, Q_OUT, D, L);
D_FF FF_INST(Q_OUT, Qbar, MUX, C, nP, nR);

assign Q = Q_OUT;

endmodule

// 1 bit flipflop +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_FF(Q, Qbar, D, C, nP, nR);
// input
input D, C;
input nP, nR;
// output
output Q, Qbar;
// wire
wire D_Q, D_QBAR, C_NOT;

not NOT_INST(C_NOT, C);
D_LATCH D_INST(D_Q, D_QBAR, D, C, nP, nR);
SR_LATCH S_INST(Q, Qbar, D_Q, D_QBAR, C_NOT, nP, nR);
endmodule

// 1 bit D latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_LATCH(Q, Qbar, D, C, nP, nR);
// input
input D, C;
input nP, nR;
// output
output Q,Qbar;
// wire
wire NAND [1:0];
wire NOT_D;

not NOT_INST(NOT_D, D);
nand NAND_INST_1(NAND[0], D, C);
nand NAND_INST_2(NAND[1], C, NOT_D);
nand NAND_INST_3(Q, nP, NAND[0], Qbar);
nand NAND_INST_4(Qbar, NAND[1], Q, nR);

endmodule

// 1 bit SR latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module SR_LATCH(Q, Qbar, S, R, C, nP, nR);
// input
input S, R, C;
input nP, nR;
// output
output Q, Qbar;
// wire
wire NAND [1:0];

nand NAND_INST_1(NAND[0], S, C);
nand NAND_INST_2(NAND[1], C, R);
nand NAND_INST_3(Q, nP, NAND[0], Qbar);
nand NAND_INST_4(Qbar, NAND[1], Q, nR);

endmodule

// 5x32 Line decoder
module DECODER_5x32(D,I);
// output
output [31:0] D;
// input
input [4:0] I;
// wire
wire [15:0] DEC;
wire NOT_4;

DECODER_4x16 DEC_INST(DEC, I[3:0]);
not NOT_INST(NOT_4, I[4]);

genvar i;
generate
   for (i = 0; i < 16; i = i + 1)
   begin
      and AND_INST_1(D[i], DEC[i], NOT_4);
      and AND_INST_2(D[i + 16], DEC[i], I[4]);
   end
endgenerate
endmodule

// 4x16 Line decoder
module DECODER_4x16(D,I);
// output
output [15:0] D;
// input
input [3:0] I;
// wire
wire [7:0] DEC;
wire NOT_3;

DECODER_3x8 DEC_INST(DEC, I[2:0]);
not NOT_INST(NOT_3, I[3]);

genvar i;
generate
   for (i = 0; i < 8; i = i + 1)
   begin
      and AND_INST_1(D[i], DEC[i], NOT_3);
      and AND_INST_2(D[i + 8], DEC[i], I[3]);
   end
endgenerate
endmodule

// 3x8 Line decoder
module DECODER_3x8(D,I);
// output
output [7:0] D;
// input
input [2:0] I;
// wire
wire [3:0] DEC;
wire NOT_2;

DECODER_2x4 DEC_INST(DEC, I[1:0]);
not NOT_INST(NOT_2, I[2]);

genvar i;
generate
   for (i = 0; i < 4; i = i + 1)
   begin
      and AND_INST_1(D[i], DEC[i], NOT_2);
      and AND_INST_2(D[i + 4], DEC[i], I[2]);
   end
endgenerate
endmodule

// 2x4 Line decoder
module DECODER_2x4(D,I);
// output
output [3:0] D;
// input
input [1:0] I;
// wire
wire NOT_0, NOT_1;

not NOT_INST_0(NOT_0, I[0]);
not NOT_INST_1(NOT_1, I[1]);

and AND_INST_3(D[0], NOT_1, NOT_0);
and AND_INST_2(D[1], NOT_1, I[0]);
and AND_INST_1(D[2], I[1], NOT_0);
and AND_INST_0(D[3], I[1], I[0]);
endmodule 