// Name: mult.v
// Module: MULT32 , MULT32_U
//
// Output: HI: 32 higher bits
//         LO: 32 lower bits
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//
// Notes: 32-bit multiplication
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sisu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module MULT32(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A;
input [31:0] B;
// wire
wire XOR;
wire [31:0] MC, MP, MX1, MX2;
wire [63:0] MULT_U, TWO_C, PROD;

TWOSCOMP32 TWO_INST_1(MC, A);
MUX32_2x1 MX_INST_1(MX1, A, MC, A[31]);
TWOSCOMP32 TWO_INST_2(MP, B);
MUX32_2x1 MX_INST_2(MX2, B, MP, B[31]);

xor XOR_INST(XOR, A[31], B[31]);

MULT32_U MULT_INST(MULT_U[63:32], MULT_U[31:0], MX1, MX2);
TWOSCOMP64 TWO_INST_3(TWO_C, MULT_U);
MUX32_2x1 MX_INST_3(PROD[63:32], MULT_U[63:32], TWO_C[63:32], XOR);
MUX32_2x1 MX_INST_4(PROD[31:0], MULT_U[31:0], TWO_C[31:0], XOR);

assign HI = PROD[63:32];
assign LO = PROD[31:0];

endmodule

module MULT32_U(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A;
input [31:0] B;
// wire
wire [31:0] CO;
wire [31:1] S [31:0];

assign CO[0] = 1'b0;
AND32_2x1 AND_INST({S[0], LO[0]}, A, {32{B[0]}});

genvar i;
generate
   for (i = 1; i < 32; i = i + 1)
   begin
      wire [31:0] M;
      AND32_2x1 AND_INST(M, A, {32{B[i]}});
      RC_ADD_SUB_32 ADD_INST({S[i], LO[i]}, CO[i], M, {CO[i - 1], S[i - 1]}, 1'b0);
   end
endgenerate

assign HI = {CO[31], S[31]};

endmodule
