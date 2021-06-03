`timescale 1ns/1ps
module BARREL_SHIFTER_TB;
reg [31:0] A;
reg [31:0] S;
reg LnR;

wire [31:0] Y;
SHIFT32 SHFT_INST(.Y(Y), .D(A), .S(S), .LnR(LnR));

initial
begin
#10;
#10 A='b1; S='b1; LnR='b0;
#10 golden(Y,'b0, A, S, LnR);
#10 A='b10000000000000000000000000000000; S='b1; LnR='b0;
#10 golden(Y,'b1000000000000000000000000000000, A, S, LnR);
#10 A='b10; S='b10; LnR='b0;
#10 golden(Y,'b0, A, S, LnR);
#10 A='b100; S='b10; LnR='b0;
#10 golden(Y,'b1, A, S, LnR);
#10 A='b100; S='b11; LnR='b0;
#10 golden(Y,'b0, A, S, LnR);
#10 A='b11000; S='b11; LnR='b0;
#10 golden(Y,'b11, A, S, LnR);
#10 A='b11111111111111111111111111111111; S='b1; LnR='b0;
#10 golden(Y,'b1111111111111111111111111111111, A, S, LnR);
#10 A='b11111111111111111111111111111111; S='b10000; LnR='b0;
#10 golden(Y,'b1111111111111111, A, S, LnR);
#10 A='b11111111111111111111111111111111; S='b11111; LnR='b0;
#10 golden(Y,'b1, A, S, LnR);
#10 A='b10000000000000000000000000000000; S='b11111; LnR='b0;
#10 golden(Y,'b1, A, S, LnR);
#10 A='b1110; S='b11; LnR='b0;
#10 golden(Y,'b1, A, S, LnR);
#10 A='b1111; S='b11; LnR='b0;
#10 golden(Y,'b1, A, S, LnR);
#10 A='b1; S='b1; LnR='b1;
#10 golden(Y,'b10, A, S, LnR);
#10 A='b10000000000000000000000000000000; S='b1; LnR='b1;
#10 golden(Y,'b100000000000000000000000000000000, A, S, LnR);
#10 A='b10; S='b10; LnR='b1;
#10 golden(Y,'b1000, A, S, LnR);
#10 A='b100; S='b10; LnR='b1;
#10 golden(Y,'b10000, A, S, LnR);
#10 A='b100; S='b11; LnR='b1;
#10 golden(Y,'b100000, A, S, LnR);
#10 A='b11000; S='b11; LnR='b1;
#10 golden(Y,'b11000000, A, S, LnR);
#10 A='b1; S='b101; LnR='b1;
#10 golden(Y,'b100000, A, S, LnR);
#10 A='b10; S='b10000; LnR='b1;
#10 golden(Y,'b100000000000000000, A, S, LnR);
#10 A='b100; S='b10; LnR='b1;
#10 golden(Y,'b10000, A, S, LnR);
#10 A='b100; S='b11; LnR='b1;
#10 golden(Y,'b100000, A, S, LnR);
#10 A='b11111111111111000; S='b10000; LnR='b1;
#10 golden(Y,'b111111111111110000000000000000000, A, S, LnR);
#10 A='b11111111111111111111111111111111 ; S='b1; LnR='b1;
#10 golden(Y,'b11111111111111111111111111111110, A, S, LnR);
#10 A='b11111111111111111111111111111111; S='b10; LnR='b1;
#10 golden(Y,'b11111111111111111111111111111100, A, S, LnR);
#10 A='b11111111111111111111111111111111; S='b11111; LnR='b1;
#10 golden(Y,'b10000000000000000000000000000000, A, S, LnR);
#10 A='b10000000000000000000000000000000; S='b11111; LnR='b1;
#10 golden(Y,'b0, A, S, LnR);
#10 A='b10000000000000000000000000000000; S='b1; LnR='b1;
#10 golden(Y,'b0, A, S, LnR);
end

task golden;
input [31:0] Y;
input [31:0] G_Y;
input [31:0] A;
input [31:0] S;
input LnR; 
begin
   if(LnR)
   begin
      $write("%d << %d | G_Y: %d | resulted: %d", A, S, G_Y, Y);
      if (Y == G_Y) 
      begin
         $write("[PASSED]");
      end
      else
      begin
	 $write("[FAILED]");
      end
   end 
   else
   begin
      $write("%d >> %d | G_Y: %d | resulted: %d", A, S, G_Y, Y);
      if (Y == G_Y) 
      begin
         $write("[PASSED]");
      end
      else
      begin
	 $write("[FAILED]");
      end
   end
   $write("\n");
end
endtask
endmodule 
