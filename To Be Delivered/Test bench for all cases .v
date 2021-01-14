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
///////write and read for trady =1
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

/////////write and read 3 data only
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
frame=1;
#10
irdy=1;
cbe=4'bzzzz;
enable=1;
adreg=32'hzzzzzzzz;

end

//////write oRR read 3 data only
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
frame=1;
#10
irdy=1;
cbe=4'bzzzz;
enable=1;
adreg=32'hzzzzzzzz;

end

////Read when Irady =1
initial
begin
frame=1;
irdy=1;
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
irdy=1;
#10
irdy=0;
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