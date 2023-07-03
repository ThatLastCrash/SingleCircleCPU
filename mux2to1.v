module mux2to1(busB,immOut,AluSrc,busOut);
input [31:0] busB;
input [31:0] immOut;
input AluSrc;
output wire [31:0] busOut;

assign busOut=AluSrc?immOut:busB;
endmodule