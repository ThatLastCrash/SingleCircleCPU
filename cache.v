module cache(CLK,WE,Address,Data_In,Data_Out);
    parameter NUMB = 256;
    parameter SIZE = 32;
    
    input CLK;
    input WE;
    input [SIZE:1]Data_In;		//д�������
    input [SIZE:1]Address;		//��ַ
    output [SIZE:1]Data_Out;	//��������
    
    reg [SIZE:1] Mem[256:0];	//�洢��
    
    integer i;
    initial
        for(i=0;i<NUMB;i=i+1) Mem[i]<=i;
    always@(negedge CLK)
    begin
        if(WE)//д��
                Mem[Address]<=Data_In;
    end
    
    assign Data_Out=Mem[Address];
endmodule