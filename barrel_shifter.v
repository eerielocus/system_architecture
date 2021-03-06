// Name: barrel_shifter.v
// Module: SHIFT32_L , SHIFT32_R, SHIFT32
//
// Notes: 32-bit barrel shifter
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

// 32-bit shift amount shifter
module SHIFT32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [31:0] S;
input LnR;
// wire
wire [31:0] BRL;
wire OR;

BARREL_SHIFTER32 B_INST(BRL, D, S[4:0], LnR);
OR27x1 OR_INST(OR, S[31:5]);
MUX32_2x1 MX_INST(Y, BRL, 0, OR);

endmodule

// Shift with control L or R shift
module BARREL_SHIFTER32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;
input LnR;
// wire
wire [31:0] LEFT, RIGHT;

SHIFT32_L L_INST(LEFT, D, S);
SHIFT32_R R_INST(RIGHT, D, S);
MUX32_2x1 MX_INST(Y, RIGHT, LEFT, LnR);

endmodule

// Right shifter
module SHIFT32_R(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;
// wire
wire [31:0] MUX [3:0];

genvar i;
generate
   for (i = 0; i < 32; i = i + 1)
   begin
      if (i == 31)
      begin
         MUX1_2x1 MX_INST_1(MUX[0][i], D[i], 1'b0, S[0]);
      end
      else
      begin
         MUX1_2x1 MX_INST_2(MUX[0][i], D[i], D[i + 1], S[0]);
      end
   end
endgenerate

genvar j, k;
generate
   for (j = 0; j < 3; j = j + 1)
   begin
      for (k = 0; k < 32; k = k + 1)
      begin
         if (k >= 32 - 2 ** (j + 1))
         begin
            MUX1_2x1 MX_INST_3(MUX[j + 1][k], MUX[j][k], 1'b0, S[j + 1]);
         end
         else
         begin
            MUX1_2x1 MX_INST_4(MUX[j + 1][k], MUX[j][k], MUX[j][k + 2 ** (j + 1)], S[j + 1]);
         end
      end
   end
endgenerate

genvar n;
generate
   for (n = 0; n < 32; n = n + 1)
   begin
      if (n >= 16)
      begin
         MUX1_2x1 MX_INST_5(Y[n], MUX[3][n], 1'b0, S[4]);
      end
      else
      begin
         MUX1_2x1 MX_INST_6(Y[n], MUX[3][n], MUX[3][n + 16], S[4]);
      end
   end
endgenerate
endmodule

// Left shifter
module SHIFT32_L(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;
// wire
wire [31:0] MUX [3:0];

genvar i;
generate
   for (i = 0; i < 32; i = i + 1)
   begin
      if (i == 0)
      begin
         MUX1_2x1 MX_INST_1(MUX[0][i], D[i], 1'b0, S[0]);
      end
      else
      begin
         MUX1_2x1 MX_INST_2(MUX[0][i], D[i], D[i - 1], S[0]);
      end
   end
endgenerate

genvar j, k;
generate
   for (j = 0; j < 3; j = j + 1)
   begin
      for (k = 0; k < 32; k = k + 1)
      begin
         if (k < 2 ** (j + 1))
         begin
            MUX1_2x1 MX_INST_3(MUX[j + 1][k], MUX[j][k], 1'b0, S[j + 1]);
         end
         else
         begin
            MUX1_2x1 MX_INST_4(MUX[j + 1][k], MUX[j][k], MUX[j][k - 2 ** (j + 1)], S[j + 1]);
         end
      end
   end
endgenerate

genvar n;
generate
   for (n = 0; n < 32; n = n + 1)
   begin
      if (n <= 16)
      begin
         MUX1_2x1 MX_INST_5(Y[n], MUX[3][n], 1'b0, S[4]);
      end
      else
      begin
         MUX1_2x1 MX_INST_6(Y[n], MUX[3][n], MUX[3][n - 16], S[4]);
      end
   end
endgenerate
endmodule

