module SingleCircleCPU(clk,run,
		pc,instru,                      // PCֵ��ȡ��ָ��
		//RegWr,			//�Ĵ���дʹ��
		//Branch,Jump,	//��ת��־
		//ExtOP,		//��������չ�з��Ż����޷���
		//AluSrc,		//alu����Դѡ���־
		//MemWr,		//�洢��дʹ��
		//MemtoReg,	//���ս��ѡ���־��1�Ǵ洢����0��alu������
		//RegDst,		//Ŀ�ļĴ���ѡ��
		Rw,					
		Rs,Rt,Rd,
		busA,busB,busW,			//�Ĵ���
		DataOut,		 // �洢����������ֵ
		busOut,   		 //busB ѡ������Դ������
		Result,    		 //ALU�Ľ��
		Zero,            // 0�ź�alu��ZF
		AluCtr,  		 // ALU���������źţ�1����������0��busB
		op,func,
		immOut,
		addr_mem
		//imm16			//������
		//wrre    
		);
input clk,run;
//input RegWr,Branch,Jump,ExtOP,AluSrc,MemWr,MemtoReg,RegDst;
//input [2:0]AluCtr;
//input [15:0]imm16;
output [29:0]pc;
output [31:0]instru;

output [4:0] Rw;
output [31:0] busA;
output [31:0] busB;
output [31:0] busW;

output [31:0]DataOut;
output [31:0]busOut;
output [31:0]Result;
output Zero;

output [4:0]Rs;
output [4:0]Rt;
output [4:0]Rd;


wire[32:1] Mem[256:0];	//�洢��

wire RegWr,Branch,Jump,ExtOP,AluSrc,MemWr,MemtoReg,RegDst;
output wire [2:0]AluCtr;
output wire [5:0]op;
output wire [5:0]func;
wire [15:0]imm16;
output wire [31:0]immOut;
output [31:0]addr_mem;

assign op=instru[31:26];
assign Rs=instru[25:21];
assign Rt=instru[20:16];
assign Rd=instru[15:11];
assign func=instru[5:0];
assign imm16=instru[15:0];

Controller con(op,func,RegWr,Branch,Jump,ExtOP,AluSrc,AluCtr,MemWr,MemtoReg,RegDst);
Instruction ins(clk,run, Branch,Jump,Zero,instru,pc,addr_mem);         //  ȡָ��,��instru��


mux2to1_regdst mux1(Rt,Rd,RegDst,Rw);                             // ȷ��Ŀ�ļĴ���RW
RegFile regfile(clk,RegWr,Rw,Rs,Rt,busW,busA,busB);	//�õ�busA,busB
signZeroExtend sz(imm16,ExtOP,immOut);  	       // 0,1��չ
mux2to1 mux2(busB,immOut,AluSrc,busOut);                     //busB ѡ������Դ������������alu
ALU alu(busA,busOut,AluCtr,Zero,Result,Overflow);   	//alu����ó������result��
cache mem(clk,MemWr,Result,busB,DataOut);		//�洢����result��Ϊaddress
mux2to1 mux3(Result,DataOut,MemtoReg,busW);      // ����Ľ����ALU�Ľ�����Ǵ洢���Ľ��
endmodule
