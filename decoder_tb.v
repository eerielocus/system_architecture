module DEC_5x32_TB;

wire [31:0] result;
reg [4:0] control;

DECODER_5x32 l(result, control);

	initial begin
		#5;
		#5 control='b0;
		#5 golden(result,'b1, control);
		#5;
		#5 control='b1;
		#5 golden(result,'b10, control);
		#5;
		#5 control='b10;
		#5 golden(result,'b100, control);
		#5;
		#5 control='b11;
		#5 golden(result,'b1000, control);
		#5;
		#5 control='b100;
		#5 golden(result,'b10000, control);
		#5;
		#5 control='b111;
		#5 golden(result,'b10000000, control);
	end
	task golden;
		input [31:0] calculated;
		input [31:0] expected;
		input [4:0] control;
		begin
			$write("%d got %d, control %d", expected, calculated, control);
			if (calculated==expected) begin
				$write("[PASSED]");
			end else begin
				$write("[FAILED]");
			end 
			$write("\n");
		end
	endtask
endmodule
