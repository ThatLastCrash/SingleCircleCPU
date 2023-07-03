module ALU(
input wire [31:0]A,
input wire [31:0]B,
input wire [2:0]ALUctr,

output reg Zero,
output reg [31:0]Result,
output reg Overflow
);
reg [31:0]Add_Result;
wire SUBctr,OVctr,SIGctr;
wire [1:0]OPctr;
reg Add_Carry;
reg Add_Sign;
reg Add_Overflow; 
reg [31:0]Compare;
reg Less;

assign SUBctr=ALUctr[2];
assign OVctr=!ALUctr[1]&ALUctr[0];
assign SIGctr=ALUctr[0];
assign OPctr={ALUctr[2]&ALUctr[1],!ALUctr[2]&ALUctr[1]&!ALUctr[0]};

reg [31:0]f;
reg [31:0]k;
reg temp;
always@(*)
begin
	{Add_Carry, Add_Result}=A+(B^{32{SUBctr}})+SUBctr;
	Add_Sign=Add_Result[31];
	
	k=(B^{32{SUBctr}});
	Add_Overflow=((A[31]==k[31]) && (A[31]!=Add_Result[31]));

	Less=SIGctr?(Add_Overflow^Add_Sign):(SUBctr^Add_Carry);
	Compare=Less?1:0;
	Zero=(Add_Result==0);
	Overflow=OVctr&Add_Overflow;
	case(OPctr)
		3'b00:
			Result=Add_Result;
		3'b01:
			Result=(A|B);
		3'b10:
			Result=Compare;
	endcase
end

endmodule
