function resulthex=quantizing(x)
%��������
max=hex2dec('7FFF');
minus=hex2dec('8000'); %������λ(16λ)��Ϊ1
x=floor(x*max);
if x<0 
    x=abs(x);    %���X�ľ���ֵ
    x=max-x ;    %ȡ���൱���ñ�ʾ�����ֵ��15��1��1���������ڱ�ʾ���ţ���ȥ����
    x=x+1;               %���м�1����
    x=x+minus;           %������λ(16λ)��Ϊ1
    resulthex=dec2hex(x);
else
    resulthex=dec2hex(x);
end
