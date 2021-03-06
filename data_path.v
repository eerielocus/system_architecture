// Name: data_path.v
// Module: DATA_PATH
// Output:  DATA : Data to be written at address ADDR
//          ADDR : Address of the memory location to be accessed
//
// Input:   DATA : Data read out in the read operation
//          CLK  : Clock signal
//          RST  : Reset signal
//
// Notes: - 32 bit processor implementing cs147sec05 instruction set
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module DATA_PATH(DATA_OUT, ADDR, ZERO, INSTRUCTION, DATA_IN, CTRL, CLK, RST);

// output list
output [`ADDRESS_INDEX_LIMIT:0] ADDR;
output ZERO;
output [`DATA_INDEX_LIMIT:0] DATA_OUT, INSTRUCTION;
// input list
input [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
input CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_IN;
// wire
wire PC_LOAD, PC_SEL_1, PC_SEL_2, PC_SEL_3, IR_LOAD, SP_LOAD,
     REG_R, REG_W, OP1_SEL, OP2_SEL_1, OP2_SEL_2, OP2_SEL_3, 
     OP2_SEL_4, R1_SEL_1, WA_SEL_1, WA_SEL_2, WA_SEL_3, NULL,
     WD_SEL_1, WD_SEL_2, WD_SEL_3, MA_SEL_1, MA_SEL_2, MD_SEL_1;
wire [31:0] PC_OUT, MUX_PC_1, MUX_PC_2, MUX_PC_3, SP_OUT;
wire [31:0] ADD_1, ADD_2, MA_1, MA_2;
wire [31:0] ALU_OUT, OP1, OP2_1, OP2_2, OP2_3, OP2_4;
wire [31:0] IR, RF_DATA_R1, RF_DATA_R2, WD_1, WD_2, WD_3;
wire [5:0] ALU_OPRN;
wire [4:0] RF_ADDR_R1, WA_1, WA_2, WA_3;
// assign wires to control signal
assign PC_LOAD = CTRL[0];	// Program Counter
assign PC_SEL_1 = CTRL[1];
assign PC_SEL_2 = CTRL[2];
assign PC_SEL_3 = CTRL[3];
assign IR_LOAD = CTRL[4];	// Instruction Register
assign SP_LOAD = CTRL[5];	// Stack Pointer
assign REG_R = CTRL[6];		// Register File Read
assign REG_W = CTRL[7];		// Register File Write
assign OP1_SEL = CTRL[8];	// Operand 1
assign OP2_SEL_1 = CTRL[9];
assign OP2_SEL_2 = CTRL[10];
assign OP2_SEL_3 = CTRL[11];
assign OP2_SEL_4 = CTRL[12];	// Operand 2
assign WD_SEL_1 = CTRL[13];
assign WD_SEL_2 = CTRL[14];
assign WD_SEL_3 = CTRL[15];	// Write Data
assign R1_SEL_1 = CTRL[16];
assign WA_SEL_1 = CTRL[17];
assign WA_SEL_2 = CTRL[18];
assign WA_SEL_3 = CTRL[19];	// Write Address
assign MA_SEL_1 = CTRL[20];
assign MA_SEL_2 = CTRL[21];	// Memory Address
assign MD_SEL_1 = CTRL[22];	// Memory Data
assign ALU_OPRN = CTRL[31:26];	// ALU Operation Code
// parse 32-bit MUX result to 26-bit ADDR output
assign ADDR = MA_2[25:0];
assign INSTRUCTION = DATA_IN;

// program counter
defparam PC_INST.PATTERN = `INST_START_ADDR;
REG32_PP PC_INST(PC_OUT, MUX_PC_3, PC_LOAD, CLK, RST);
// top-left adders and mux
RC_ADD_SUB_32 ADD_INST_1(ADD_1, NULL, 1, PC_OUT, 1'b0);
RC_ADD_SUB_32 ADD_INST_2(ADD_2, NULL, ADD_1, {{16{IR[15]}}, IR[15:0]}, 1'b0);
MUX32_2x1 MX_PC_INST_1(MUX_PC_1, RF_DATA_R1, ADD_1, PC_SEL_1);
MUX32_2x1 MX_PC_INST_2(MUX_PC_2, MUX_PC_1, ADD_2, PC_SEL_2);
MUX32_2x1 MX_PC_INST_3(MUX_PC_3, {6'b0, IR[25:0]}, MUX_PC_2, PC_SEL_3);
// instruction register
REG32 INSTR_REG(IR, DATA_IN, IR_LOAD, CLK, RST);
// register file
REGISTER_FILE_32x32 REG_MAIN(RF_DATA_R1, RF_DATA_R2, RF_ADDR_R1, IR[20:16], 
			     WD_3, WA_3, REG_R, REG_W, CLK, RST);
// stack pointer
defparam SP_INST.PATTERN = `INIT_STACK_POINTER;
REG32_PP SP_INST(SP_OUT, ALU_OUT, SP_LOAD, CLK, RST);
// instruction: OP1
MUX32_2x1 OP1_SEL_INST(OP1, RF_DATA_R1, SP_OUT, OP1_SEL);
// instruction: OP2
MUX32_2x1 OP2_SEL_INST_1(OP2_1, 1, {27'b0, IR[10:6]}, OP2_SEL_1);
MUX32_2x1 OP2_SEL_INST_2(OP2_2, {16'b0, IR[15:0]}, {{16{IR[15]}}, IR[15:0]}, OP2_SEL_2);
MUX32_2x1 OP2_SEL_INST_3(OP2_3, OP2_2, OP2_1, OP2_SEL_3);
MUX32_2x1 OP2_SEL_INST_4(OP2_4, OP2_3, RF_DATA_R2, OP2_SEL_4);
// instruction: ALU
ALU ALU_INST(ALU_OUT, ZERO, OP1, OP2_4, ALU_OPRN);
// instruction receiving
MUX32_2x1 WD_SEL_INST_1(WD_1, ALU_OUT, DATA_IN, WD_SEL_1);
MUX32_2x1 WD_SEL_INST_2(WD_2, WD_1, {IR[15:0], 16'b0}, WD_SEL_2);
MUX32_2x1 WD_SEL_INST_3(WD_3, ADD_1, WD_2, WD_SEL_3);
// instruction parsing
MUX5_2x1 R1_SEL_INST(RF_ADDR_R1, IR[25:21], 5'b00000, R1_SEL_1);
MUX5_2x1 WA_SEL_INST_1(WA_1, IR[15:11], IR[20:16], WA_SEL_1);
MUX5_2x1 WA_SEL_INST_2(WA_2, 5'b00000, 5'b11111, WA_SEL_2);
MUX5_2x1 WA_SEL_INST_3(WA_3, WA_2, WA_1, WA_SEL_3);
// address output
MUX32_2x1 MA_SEL_INST_1(MA_1, ALU_OUT, SP_OUT, MA_SEL_1);
MUX32_2x1 MA_SEL_INST_2(MA_2, MA_1, PC_OUT, MA_SEL_2);
// data output
MUX32_2x1 MD_SEL_INST(DATA_OUT, RF_DATA_R2, RF_DATA_R1, MD_SEL_1);
endmodule
