`timescale 1ns/1ps
module MUX_TB;
reg A, B, S;

wire Y;

MUX1_2x1 mx_inst(.Y(Y), .I0(A), .I1(B), .S(S));

initial
begin
#5 S=0; A=0; B=0;
#5 S=0; A=1; B=0;
#5 S=0; A=0; B=1;
#5 S=0; A=1; B=1;
#5 S=1; A=0; B=0;
#5 S=1; A=1; B=0;
#5 S=1; A=0; B=1;
#5 S=1; A=1; B=1;
end
endmodule
