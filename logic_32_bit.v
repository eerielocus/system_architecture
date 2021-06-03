// Name: logic_32_bit.v
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

// 32-bit NOR
module NOR32_2x1(Y,A,B);
// output 
output [31:0] Y;
// input
input [31:0] A;
input [31:0] B;

genvar i;
generate
   for (i = 0; i < 32; i = i + 1)
   begin
      nor NOR_INST(Y[i], A[i], B[i]);
   end
endgenerate
endmodule

// 32-bit AND
module AND32_2x1(Y,A,B);
// output 
output [31:0] Y;
// input
input [31:0] A;
input [31:0] B;

genvar i;
generate
   for (i = 0; i < 32; i = i + 1)
   begin
      and AND_INST(Y[i], A[i], B[i]);
   end
endgenerate
endmodule

// 32-bit inverter
module INV32_1x1(Y,A);
// output 
output [31:0] Y;
// input
input [31:0] A;

genvar i;
generate
   for (i = 0; i < 32; i = i + 1)
   begin
      not NOT_INST(Y[i], A[i]);
   end
endgenerate
endmodule

// 32-bit OR
module OR32_2x1(Y,A,B);
// output 
output [31:0] Y;
// input
input [31:0] A;
input [31:0] B;
// wire
wire [31:0] NOR_INV;

NOR32_2x1 NOR_INST(NOR_INV, A, B);
INV32_1x1 INV_INST(Y, NOR_INV);
endmodule

// 27-bit OR
module OR27x1(Y,A);
// output
output Y;
// input
input [26:0] A;
// wire
wire [24:0] OR;

genvar i;
generate
   for (i = 0; i < 25; i = i + 1)
   begin
      if (i == 0)
      begin
         or OR_INST_0(OR[0], A[0], A[1]);
      end
      else
      begin
         or OR_INST(OR[i], OR[i - 1], A[i + 1]);
      end
   end
endgenerate

or OR_INST_1(Y, OR[24], A[26]);
endmodule

// 32-bit OR
module OR32x1(Y,A);
// output
output Y;
// input
input [31:0] A;
// wire
wire [29:0] OR;

genvar i;
generate
   for (i = 0; i < 30; i = i + 1)
   begin
      if (i == 0)
      begin
         or OR_INST_0(OR[0], A[0], A[1]);
      end
      else
      begin
         or OR_INST(OR[i], OR[i - 1], A[i + 1]);
      end
   end
endgenerate

or OR_INST_1(Y, OR[29], A[31]);
endmodule 