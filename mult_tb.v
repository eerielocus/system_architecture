`timescale 1ns/1ps
module MULT_TB;
reg [31:0] A;
reg [31:0] B;
wire [31:0] HI;
wire [31:0] LO;

MULT32 MULT_INST(HI, LO, A, B);

initial 
begin
#10;
#10 A='b0; B='b0;
#10 golden(HI, LO,'b0, 'b0, A, B);
#10;
#10 A='b1; B='b0;
#10 golden(HI, LO, 'b0, 'b0, A, B);
#10;
#10 A='b0; B='b1;
#10 golden(HI, LO, 'b0, 'b0, A, B);
#10;
#10 A='b1; B='b1;
#10 golden(HI, LO, 'b0, 'b1, A, B);
#10;
#10 A='b11; B='b1;
#10 golden(HI, LO, 'b0, 'b11, A, B);
#10;
#10 A='b10; B='b10;
#10 golden(HI, LO, 'b0, 'b100, A, B);
#10;
#10 A='b11; B='b11;
#10 golden(HI, LO, 'b0, 'b1001, A, B);
#10;
#10 A='hffffffff; B='b1;
#10 golden(HI, LO, 'hffffffff, 'hffffffff, A, B);
#10;
end

task golden;
input [31:0] HI;
input [31:0] LO;
input [31:0] G_HI;
input [31:0] G_LO;
input [31:0] A;
input [31:0] B;
begin
   if (LO == G_LO && HI == G_HI) 
   begin
      $write("[PASSED]");
   end
   else
   begin
      $write("%d * %d | expected: %d,%d | resulted: %d,%d", A, B, G_HI, G_LO, HI, LO);
      $write("[FAILED]");
   end 
      $write("\n");
   end
endtask
endmodule
