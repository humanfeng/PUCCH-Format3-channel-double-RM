function  MATLABdata  = CCSdata2MATLABdata(CCSreal,CCSimage)
% ��CCS�е�������������ת��ΪMATLAB�п���ʹ�õ�����
%CRC��������������CCS���룩����0xF413F451 0xF0712341 0x2349ABCD������ʮ������������
%��16λ��ʾʵ������16λ��ʾ�鲿

CCSdataLength = length(CCSreal);
Inputreal = hex2dec(CCSreal);               % �������ʮ��������ת��Ϊʮ������
Inputimage = hex2dec(CCSimage);             % �������ʮ��������ת��Ϊʮ������

for m = 1:CCSdataLength                     % �ж�ʵ���鲿��������,Q15����
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
%��ԭ����ǰ��С��
n1 = Inputreal/2^15;
n2 = Inputimage/2^15;
MATLABdata = n1+j*n2;                       %ʵ�����鲿�ϲ�
%==========================================
