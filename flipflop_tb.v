`timescale 1ns/1ps
module FLIPFLOP_TB;
reg D, C, nP, nR;
wire Q, Qbar;

D_FF D_FF_INST(Q, Qbar, D, C, nP, nR);

initial 
begin
#10 D='b0; nP='b0; nR='b1;
#10 C='b0;
#10 C='b1;
#10 golden(Q, 'b1, D, C, nP, nR);
#10;
#10 D='b1; nP='b0; nR='b1;
#10 C='b0;
#10 C='b1;
#10 golden(Q, 'b1, D, C, nP, nR);
#10;
#10 D='b0; nP='b1; nR='b0;
#10 C='b0;
#10 C='b1;
#10 golden(Q, 'b0, D, C, nP, nR);
#10;
#10 D='b1; nP='b1; nR='b0;
#10 C='b0;
#10 C='b1;
#10 golden(Q, 'b0, D, C, nP, nR);
#10;
#10 D='b0; nP='b1; nR='b1;
#10 C='b0;
#10 C='b1;
#10 golden(Q, 'b0, D, C, nP, nR);
#10;
#10 D='b1; nP='b1; nR='b1;
#10 C='b0;
#10 C='b1;
#10 golden(Q, 'b1, D, C, nP, nR);
#10;
#10 D='b0; nP='b1; nR='b1;
#10 C='b0;
#10 C='b1;
#10 golden(Q, 'b0, D, C, nP, nR);
#10;
#10 D='b0; nP='b1; nR='b1;
#10 C='b0;
#10 C='b1;
#10 C='b0;
#10 golden(Q, 'b0, D, C, nP, nR);
#10;
end

task golden; 
input Q;
input G_Q;
input D;
input C;
input nP;
input nR;

begin
   $write("D:%d C:%d nP:%d nR:%d | expected: Q:%d | resulted: Q:%d", D, C, nP, nR, G_Q, Q);
   if (Q === G_Q) 
   begin			
      $write("[PASSED]");
   end 
   else
   begin
      $write("[FAILED]");
   end 
   $write("\n");
end
endtask
endmodule 