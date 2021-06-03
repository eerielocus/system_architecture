`timescale 1ns/1ps
module REG1_TB;
reg p, d, c, r, l;
wire q1, q2;
REG1 REG_INST(q1, q2, d, l, c, p, r);
initial 
begin
   p='b1;
#5 l='b1;
#5 d='b1; r='b1;
#5 c='b1; 
#5 c='b0;
#5 
#5 golden(q1, 'b1, l, d, r);

end
task golden; 
input result, expected, l, d, r; 
begin
   $write("L:%d D:%d R:%d | expected Q:%d | resulted Q:%d", l, p, r, expected, result);
   if (result == expected) 
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
