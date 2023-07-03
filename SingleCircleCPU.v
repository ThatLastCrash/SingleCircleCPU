module SingleCircleCPU(clk,run,
		pc,instru,                      // PC值，取的指令
		//RegWr,			//寄存器写使能
		//Branch,Jump,	//跳转标志
		//ExtOP,		//立即数扩展有符号还是无符号
		//AluSrc,		//alu数据源选择标志
		//MemWr,		//存储器写使能
		//MemtoReg,	//最终结果选择标志，1是存储器，0是alu计算结果
		//RegDst,		//目的寄存器选择
		Rw,					
		Rs,Rt,Rd,
		busA,busB,busW,			//寄存器
		DataOut,		 // 存储器读出来的值
		busOut,   		 //busB 选择的输出源操作数
		Result,    		 //ALU的结果
		Zero,            // 0信号alu的ZF
		AluCtr,  		 // ALU操作控制信号，1是立即数，0是busB
		op,func,
		immOut,
		addr_mem
		//imm16			//立即数
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


wire[32:1] Mem[256:0];	//存储器

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
Instruction ins(clk,run, Branch,Jump,Zero,instru,pc,addr_mem);         //  取指令,在instru中


mux2to1_regdst mux1(Rt,Rd,RegDst,Rw);                             // 确定目的寄存器RW
RegFile regfile(clk,RegWr,Rw,Rs,Rt,busW,busA,busB);	//得到busA,busB
signZeroExtend sz(imm16,ExtOP,immOut);  	       // 0,1扩展
mux2to1 mux2(busB,immOut,AluSrc,busOut);                     //busB 选择的输出源操作数，送入alu
ALU alu(busA,busOut,AluCtr,Zero,Result,Overflow);   	//alu运算得出结果在result中
cache mem(clk,MemWr,Result,busB,DataOut);		//存储器，result作为address
mux2to1 mux3(Result,DataOut,MemtoReg,busW);      // 输出的结果，ALU的结果还是存储器的结果
endmodule
