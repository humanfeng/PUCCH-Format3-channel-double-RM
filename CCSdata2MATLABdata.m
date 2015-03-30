function  MATLABdata  = CCSdata2MATLABdata(CCSreal,CCSimage)
% 把CCS中的量化数据数据转变为MATLAB中可以使用的数据
%CRC输入数据流（从CCS导入），如0xF413F451 0xF0712341 0x2349ABCD……的十六进制数据流
%高16位表示实部，低16位表示虚部

CCSdataLength = length(CCSreal);
Inputreal = hex2dec(CCSreal);               % 将输入的十六进制数转换为十进制数
Inputimage = hex2dec(CCSimage);             % 将输入的十六进制数转换为十进制数

for m = 1:CCSdataLength                     % 判断实部虚部的正负号,Q15量化
  if Inputreal(m) < 2^15
     Inputreal(m) = Inputreal(m);     
  else
     Inputreal(m) = Inputreal(m)-2^16;
  end
  
  if Inputimage(m) < 2^15
     Inputimage(m) = Inputimage(m);     
  else
     Inputimage(m) = Inputimage(m)-2^16;
  end
end
%还原量化前的小数
n1 = Inputreal/2^15;
n2 = Inputimage/2^15;
MATLABdata = n1+j*n2;                       %实部与虚部合并
%==========================================
