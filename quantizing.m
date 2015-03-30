function resulthex=quantizing(x)
%量化函数
max=hex2dec('7FFF');
minus=hex2dec('8000'); %负数高位(16位)置为1
x=floor(x*max);
if x<0 
    x=abs(x);    %求出X的绝对值
    x=max-x ;    %取反相当于用表示的最大值（15个1，1个比特用于表示符号）减去本身
    x=x+1;               %进行加1操作
    x=x+minus;           %负数高位(16位)置为1
    resulthex=dec2hex(x);
else
    resulthex=dec2hex(x);
end
