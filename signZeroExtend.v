module signZeroExtend(imm16,ExtOP,immOut);
input [15:0] imm16;
input ExtOP;
output wire [31:0]immOut;
wire [31:0]extend_1;
wire [31:0]extend_0;
assign extend_1=imm16[15]?{{16{1'b1}},imm16}:{{16{1'b0}},imm16};
assign extend_0={{16{1'b0}},imm16};
assign immOut=ExtOP?extend_1:extend_0;

endmodule
