// Name: alu.v
// Module: ALU
// Input: OP1[32] - operand 1
//        OP2[32] - operand 2
//        OPRN[6] - operation code
// Output: OUT[32] - output OUT for the operation
//
// Notes: 32 bit combinatorial ALU
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Oct 19, 2014        Kaushik Patra   kpatra@sjsu.edu         Added ZERO status output
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module ALU(OUT, ZERO, OP1, OP2, OPRN);
// input list
input [`DATA_INDEX_LIMIT:0] OP1; // operand 1
input [`DATA_INDEX_LIMIT:0] OP2; // operand 2
input [`ALU_OPRN_INDEX_LIMIT:0] OPRN; // operation code
// output list
output [`DATA_INDEX_LIMIT:0] OUT;
output ZERO;
// wire
wire [31:0] MUL_LO, MUL_HI, SHFT, ADD_SUB, AND, OR, NOR, MUX, NULL;
wire SnA_AND, SnA_NOT, SnA, CO;
// register

not NOT_INST(SnA_NOT, OPRN[0]);
and AND_INST(SnA_AND, OPRN[0], OPRN[3]);
or OR_INST(SnA, SnA_AND, SnA_NOT);

RC_ADD_SUB_32 ADD_SUB_INST(ADD_SUB, CO, OP1, OP2, SnA);
SHIFT32 BARREL_SHIFT_INST(SHFT, OP1, OP2, OPRN[0]);
MULT32 MUL_INST(MUL_HI, MUL_LO, OP1, OP2);

AND32_2x1 AND32_INST(AND, OP1, OP2);
OR32_2x1 OR32_INST(OR, OP1, OP2);
NOR32_2x1 NOR32_INST(NOR, OP1, OP2);

MUX32_16x1 MX16_INST(MUX, NULL, ADD_SUB, ADD_SUB, MUL_LO, SHFT, SHFT, AND, OR, NOR, 
		    {31'b0, ADD_SUB[31]}, NULL, NULL, NULL, NULL, NULL, NULL, OPRN[3:0]);

NOR32x1 NOR32x1_INST(ZERO, MUX);
assign OUT = MUX;
endmodule
