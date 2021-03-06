// Name: full_adder.v
// Module: FULL_ADDER
//
// Output: S : Sum
//         CO : Carry Out
//
// Input: A : Bit 1
//        B : Bit 2
//        CI : Carry In
//
// Notes: 1-bit full adder implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module FULL_ADDER(S, CO, A, B, CI);
// output
output S, CO;
// input
input A, B, CI;
// wire
wire HALF_ADD_S, HALF_ADD_CO_1, HALF_ADD_CO_2;

HALF_ADDER HA_INST_1(HALF_ADD_S, HALF_ADD_CO_1, A, B);
HALF_ADDER HA_INST_2(S, HALF_ADD_CO_2, HALF_ADD_S, CI);
or OR_INST(CO, HALF_ADD_CO_1, HALF_ADD_CO_2);

endmodule;
