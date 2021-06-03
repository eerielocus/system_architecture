// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: CTRL  : Control signal for data path
//         READ  : Memory read signal
//         WRITE : Memory Write signal
//
// Input:  ZERO : Zero status from ALU
//         CLK  : Clock signal
//         RST  : Reset Signal
//
// Notes: - Control unit synchronize operations of a processor
//          Assign each bit of control signal to control one part of data path
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module CONTROL_UNIT(CTRL, READ, WRITE, ZERO, INSTRUCTION, CLK, RST); 
// Output signals
output [`CTRL_WIDTH_INDEX_LIMIT:0] CTRL;
output READ, WRITE;
// input signals
input ZERO, CLK, RST;
input [`DATA_INDEX_LIMIT:0] INSTRUCTION;
// wire
wire [2:0] proc_state;
// register
reg [`CTRL_WIDTH_INDEX_LIMIT:0] CTRL;
reg READ, WRITE;
// registers for parsing

PROC_SM SM_INST(proc_state, CLK, RST);

always @ (proc_state)
begin
   // FETCH: set MEM_ADDR to PC, 1 to MEM_READ, RF R/W to 0
   // 'b0000 0000 0000 0000 0000 0000 0000 0000
   if (proc_state === `PROC_FETCH) 
   begin
      READ = 1'b1;
      WRITE = 1'b0;
      CTRL = 'b00000000001000000000000000000000;
   end
   // DECODE: store MEM_DATA to INST_REG, use provided code for parse, 
   // set RF_ADDR_R to RS/RT with RF set to read
   if (proc_state === `PROC_DECODE) 
   begin
      READ = 1'b0;
      WRITE = 1'b0;
      CTRL = 'b00000000001000000000000001010000;
   end
   // EXE: set ALU operands/opcode to functions following CS147DV set
   if (proc_state === `PROC_EXE)
   begin
      READ = 1'b0;
      WRITE = 1'b0;
      case (INSTRUCTION[31:26])
	 // R-type instructions
	 6'h00 :
	 begin
	    case (INSTRUCTION[5:0])
               // 		10987654321098765432109876543210
               6'h20 : CTRL = 'b00000100001000000001000001000000; // Addition
               6'h22 : CTRL = 'b00001000001000000001000001000000; // Subtract
               6'h2c : CTRL = 'b00001100001000000001000001000000; // Multiply
               6'h01 : CTRL = 'b00010100001000000000101001000000; // Shift left
               6'h02 : CTRL = 'b00010000001000000000101001000000; // Shift right
               6'h24 : CTRL = 'b00011000001000000001000001000000; // AND
               6'h25 : CTRL = 'b00011100001000000001000001000000; // OR
               6'h27 : CTRL = 'b00100000001000000001000001000000; // NOR
               6'h2a : CTRL = 'b00100100001000000001000001000000; // Set less than
               6'h08 : CTRL = 'b00000000000000000000000001001001; // Jump register
            endcase
	 end
	 // I-type instructions
         // 		  10987654321098765432109876543210
	 6'h08 : CTRL = 'b00000100001000001000010001000000; // Addition immediate
	 6'h1d : CTRL = 'b00001100001000000000010001000000; // Multiplication immediate
	 6'h0c : CTRL = 'b00011000001000000000000001000000; // AND immediate
	 6'h0d : CTRL = 'b00011100001000000000000001000000; // OR immediate
	 6'h0f : CTRL = 'b00000000001000000000000001000000; // Load upper immediate
	 6'h0a : CTRL = 'b00100100001000000001010001000000; // Set less than immediate
         6'h04 : CTRL = 'b00001000000000000001000001000000; // Branch equal
         6'h05 : CTRL = 'b00001000000000000001000001000000; // Branch not equal
	 6'h23 : CTRL = 'b00000100000000000000010001000000; // Load word
	 6'h2b : CTRL = 'b00000100000000000000010001000000; // Store word
	 // J-type instructions (LUI, JMP, JAL may not need ALU operation)
         // 		  10987654321098765432109876543210
	 6'h1b : CTRL = 'b00000000000100010000000000000000; // Push
         6'h1c : CTRL = 'b00000100000000000000100100100000; // Pop
      endcase
   end
   // MEM: Only LW, SW, PUSH, and POP are involved
   if (proc_state === `PROC_MEM)
   begin
      READ = 1'b0;
      WRITE = 1'b0;
      case (INSTRUCTION[31:26])
	 6'h23 :
	 begin
         // 	     10987654321098765432109876543210
	    CTRL = 'b00000100000000000000010001000000; // Load word
	    READ = 1'b1;
	 end
	 6'h2b :
	 begin
         // 	     10987654321098765432109876543210
	    CTRL = 'b00000100000000000000010001000000; // Store word
	    WRITE = 1'b1;
	 end
	 6'h1b :
	 begin
         // 	     10987654321098765432109876543210
            CTRL = 'b00000000010100010000000001000000; // Push
	    WRITE = 1'b1;
	 end
	 6'h1c :
	 begin
         // 	     10987654321098765432109876543210
	    CTRL = 'b00000000000100000000000000000000; // Pop
            READ = 1'b1;
	 end
      endcase
   end
   // WB: Write back to RF or PC_REG
   if (proc_state === `PROC_WB)
   begin
      READ = 1'b0;
      WRITE = 1'b0;
      case (INSTRUCTION[31:26])
	 // R-type instructions
	 6'h00 :
	 begin
            case (INSTRUCTION[5:0])
            // 		        10987654321098765432109876543210
               6'h20 : CTRL = 'b00000100001010001001000011001011; // Addition
               6'h22 : CTRL = 'b00001000001010001001000011001011; // Subtract
               6'h2c : CTRL = 'b00001100001010001001000011001011; // Multiply
               6'h01 : CTRL = 'b00010100001010001000101011001011; // Shift left
               6'h02 : CTRL = 'b00010000001010001000101011001011; // Shift right
               6'h24 : CTRL = 'b00011000001010001001000011001011; // AND
               6'h25 : CTRL = 'b00011100001010001001000011001011; // OR
               6'h27 : CTRL = 'b00100000001010001001000011001011; // NOR
               6'h2a : CTRL = 'b00100100001010001001000011001011; // Set less than
               6'h08 : CTRL = 'b00000000000000000000000001001001; // Jump register
            endcase
	 end
	 // I-type instructions
	 // 		  10987654321098765432109876543210
	 6'h08 : CTRL = 'b00000100001010101000010011001011; // Addition immediate
	 6'h1d : CTRL = 'b00001100001010101000010011001011; // Multiplication immediate
	 6'h0c : CTRL = 'b00011000001010101000000011001011; // AND immediate
	 6'h0d : CTRL = 'b00011100001010101000000011001011; // OR immediate
         6'h0f : CTRL = 'b00000000001010101100000011001011; // Load upper immediate
	 6'h0a : CTRL = 'b00100100001010101001010011001011; // Set less than immediate
         6'h04 :
         begin
            if (ZERO == 1'b0)
            begin
	       CTRL = 'b00001000000000000001000001001101; // Branch equal
            end
            else
            begin
               CTRL = 'b00001000000000000001000001001011;
            end
         end
         6'h05 : 
         begin
            if (ZERO != 1'b0)
            begin
	       CTRL = 'b00001000000000000001000001001101; // Branch not equal
            end
            else
            begin
               CTRL = 'b00001000000000000001000001001011;
            end
         end
	 6'h23 : CTRL = 'b00000000000010101010000011001011; // Load word
         6'h2b : CTRL = 'b00000100000000000000010001001011; // Store word
	 // J-type instructions
	 // 		  10987654321098765432109876543210
	 6'h02 : CTRL = 'b00000000000000000000000000000001; // Jump to address
	 6'h03 : CTRL = 'b00000000000001000000000010000001; // Jump and link
         6'h1b : CTRL = 'b00001000000000000000100100101011; // Push
	 6'h1c : CTRL = 'b00000000000000001010000010001011; // Pop
      endcase
   end
end
endmodule

//------------------------------------------------------------------------------------------
// Module: CONTROL_UNIT
// Output: STATE      : State of the processor
//         
// Input:  CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Processor continuously cycle witnin fetch, decode, execute, 
//          memory, write back state. State values are in the prj_definition.v
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
module PROC_SM(STATE,CLK,RST);
// list of inputs
input CLK, RST;
// list of outputs
output [2:0] STATE;

// registers
reg [2:0] STATE_REG;
reg [2:0] NEXT_STATE_REG;

assign STATE = STATE_REG;

// initialize state
initial
begin
   STATE_REG = 2'bxx;
   NEXT_STATE_REG = `PROC_FETCH;
end

// reset state machine
always @(negedge RST)
begin
   STATE_REG = 2'bxx;
   NEXT_STATE_REG = `PROC_FETCH;
end

// next state
always @(posedge CLK)
begin
   case (STATE)
      `PROC_FETCH : NEXT_STATE_REG = `PROC_DECODE;
      `PROC_DECODE : NEXT_STATE_REG = `PROC_EXE;
      `PROC_EXE : NEXT_STATE_REG = `PROC_MEM;
      `PROC_MEM : NEXT_STATE_REG = `PROC_WB;
      `PROC_WB : NEXT_STATE_REG = `PROC_FETCH;
   endcase
   STATE_REG = NEXT_STATE_REG; // switch the state
end
endmodule
