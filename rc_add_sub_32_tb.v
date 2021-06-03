`timescale 1ns/1ps
module RC_ADD_SUB_32_TB;
	reg [31:0] operand1, operand2;
	reg subtractNotAdd;
	wire [31:0] result;
	wire carryOut;
	RC_ADD_SUB_32 rc1(.Y(result), .CO(carryOut),
		.A(operand1), .B(operand2), .SnA(subtractNotAdd));
	initial begin
		#5 operand1 = 0; operand2 = 0; subtractNotAdd = 0; 
		#5 $write("\nOp1:%d Op2:%d sNa:%d \n\t= result:%d carryOut:%d\n", operand1, operand2, subtractNotAdd, result, carryOut);
		#5 operand1 = 0; operand2 = 0; subtractNotAdd = 1; 
		#5 $write("\nOp1:%d Op2:%d sNa:%d \n\t= result:%d carryOut:%d\n", operand1, operand2, subtractNotAdd, result, carryOut);
		#5 operand1 = 5; operand2 = 2; subtractNotAdd = 0; 
		#5 $write("\nOp1:%d Op2:%d sNa:%d \n\t= result:%d carryOut:%d\n", operand1, operand2, subtractNotAdd, result, carryOut);
		#5 operand1 = 5; operand2 = 2; subtractNotAdd = 1; 
		#5 $write("\nOp1:%d Op2:%d sNa:%d \n\t= result:%d carryOut:%d\n", operand1, operand2, subtractNotAdd, result, carryOut);
		#5 operand1 = 2; operand2 = 5; subtractNotAdd = 0; 
		#5 $write("\nOp1:%d Op2:%d sNa:%d \n\t= result:%d carryOut:%d\n", operand1, operand2, subtractNotAdd, result, carryOut);
		#5 operand1 = 2; operand2 = 5; subtractNotAdd = 1; 
		#5 $write("\nOp1:%d Op2:%d sNa:%d \n\t= result:%d carryOut:%d\n", operand1, operand2, subtractNotAdd, result, carryOut);
		#5 operand1 = 100; operand2 = 1000; subtractNotAdd = 0; 
		#5 $write("\nOp1:%d Op2:%d sNa:%d \n\t= result:%d carryOut:%d\n", operand1, operand2, subtractNotAdd, result, carryOut);
		#5 operand1 = 32'h00ff; operand2 = 32'h0ffff; subtractNotAdd = 1; 
		#5 $write("\nOp1:%h Op2:%h sNa:%d \n\t= result:%h carryOut:%d\n", operand1, operand2, subtractNotAdd, result, carryOut);
		#5 operand1 = 32'h00; operand2 = 32'h01; subtractNotAdd = 1; 
		#5 $write("\nOp1:%h Op2:%h sNa:%d \n\t= result:%h carryOut:%d\n", operand1, operand2, subtractNotAdd, result, carryOut);
		#5 operand1 = 2147483647; operand2 = 5; subtractNotAdd = 0; 
		#5 $write("\nOp1:%d Op2:%d sNa:%d \n\t= result:%d carryOut:%d\n", operand1, operand2, subtractNotAdd, result, carryOut);
	end
endmodule 
