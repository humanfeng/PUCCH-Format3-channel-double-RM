function errorbitnum=error_count(bit_sourse,bit_receive)
%将接收到的经过处理的比特与原始发送比特比较，输出错误的比特个数
M=size(bit_sourse,2);%列数
N=size(bit_receive,2);
M==N;
errorbitnum=0;
for m=1:M
    if    bit_sourse(m)==bit_receive(m)
    else
        errorbitnum=errorbitnum+1;
    end
end