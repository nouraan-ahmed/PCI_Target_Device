module ClockGen(CLK);
output CLK;
reg CLK;
initial
CLK=0;
always
#5 CLK= ~CLK;
endmodule


module PCI_DEVICE(CLK,RST,FRAME,AD,CBE,enable,IRDY,TRDY,DEVSEL);
input CLK,RST,FRAME,IRDY;
inout [31:0] AD;
input [3:0] CBE;
output reg TRDY;
output reg DEVSEL;
reg [1:0] State;
reg [31:0] ADREG;
reg [31:0] R;
reg [31:0]buffer[0:2];
reg [31:0]largebuffer[0:5];
reg w_nr;
wire RST;
input enable;
initial
begin
buffer[32'h00000000]=32'h00000555;
buffer[32'h00000001]=32'h00000325;
buffer[32'h00000002]=32'h00000362;
end
reg [31:0] adr ,adrr ;
reg [31:0] lad ;
reg [31:0] data1 ;
parameter ADDRESS=32'h00000000;
parameter CBE_READ=4'b0110;
parameter CBE_WRITE=4'b0111;
parameter S1=2'b00; //IDLE
parameter S2=2'b01; //ADDRESS
parameter S3=2'b10; //TURN AROUND
parameter S4=2'b11; //TRANSFER DATA
wire Start=~FRAME;

assign AD=(!enable) ? ADREG : 32'bz;

always@(negedge CLK or negedge RST)
begin
if(RST)
begin
TRDY<=1;
DEVSEL<=1;
assign adr =ADDRESS;
assign lad=32'h00000000;
end
else
begin
if(Start)
begin
if(CBE==CBE_READ)
begin
w_nr=0;
end
else if(CBE==CBE_WRITE)
begin
w_nr=1;
end
TRDY<=1;
DEVSEL<=1;
end
end
begin
if(!w_nr)//READ
begin
if(adr<32'h00000003)
begin
ADREG<=buffer[adr];
end
if(adr>=32'h00000003)
begin
adrr=32'h00000000;
ADREG<=largebuffer[adrr];//large reading
assign adrr = adrr +1;
end
if(!IRDY & !FRAME & enable ==0)
begin
assign adr = adr +1;
end
if(enable==0)
begin
DEVSEL<=0;
TRDY<=0;
end
end
else if(w_nr)//WRITE
begin
if(!IRDY)
begin
R = {{8{CBE[3]}},{8{CBE[2]}},{8{CBE[1]}},{8{CBE[0]}}};
buffer[adr]<= AD &R ;
data1<=buffer[adr];
assign adr = adr +1;
end
if(enable==1)
begin
DEVSEL<=0;
TRDY<=0;
end
if(adr>32'h00000003)
begin
if(adr==32'h00000004)
begin
TRDY<=1;
end
largebuffer[lad]<= buffer[lad];
buffer[lad-1]<= AD &R ;
assign lad=lad+1;
end
end
if(IRDY&enable==1)
begin
DEVSEL<=1;
TRDY<=1;
end
end
 
end
endmodule


module testdevice();

reg [3:0] cbe;
reg frame;
reg irdy;
reg enable; //check if read or write
//bidircs
wire [31:0] ad;
reg [31:0] adreg;
wire devsel;
wire trdy;
reg reset;

assign ad=(enable)? adreg:32'bz;
//write and read for trady =1
initial
begin
frame=1;
irdy=1;
reset=1;
//WRITE OPERATION
#10
reset=0;
frame=0;
irdy=1;
cbe=4'b0111;
adreg=32'h00000000;
enable=1;
#10
irdy=0;
frame=0;
enable=1;
//byte enable
cbe=4'b1010;
//data
adreg=32'h00000191;
#10
cbe=4'b1001;
//data
adreg=32'h00005555;
#10
cbe=4'b1001;
//data
adreg=32'h00005565;
#10
cbe=4'b1000;
//data
adreg=32'h00000100;
#10
#10
reset = 0;
cbe=4'b1011;
//data
adreg=32'h00004444;
#10
cbe=4'b1110;
//data
adreg=32'h00005566;
frame=1;
#10
irdy=1;
cbe=4'bzzzz;
enable=1;
adreg=32'hzzzzzzzz;
reset=1;

#10
//READ OPEARATION
reset=0;
frame=0;
irdy=1;
cbe=4'b0110;
adreg=32'h00000000;
enable=1;
#10
irdy=0;
enable=1;
adreg=32'hzzzzzzzz;
#10
frame=0;
enable=0;
adreg=ad;
#10
irdy=0;
#10
irdy=0;
#10
irdy=0;
#10
irdy=0;
#10
frame=1;
#10
irdy=1;
cbe=4'bzzzz;
enable=1;
adreg=32'hzzzzzzzz;

end
 
ClockGen clock (CLK);
PCI_DEVICE D(CLK,reset,frame,ad,cbe,enable,irdy,trdy,devsel);

endmodule
