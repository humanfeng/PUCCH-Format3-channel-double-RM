function errorbitnum=error_count(bit_sourse,bit_receive)
%�����յ��ľ�������ı�����ԭʼ���ͱ��رȽϣ��������ı��ظ���
M=size(bit_sourse,2);%����
N=size(bit_receive,2);
M==N;
errorbitnum=0;
for m=1:M
    if    bit_sourse(m)==bit_receive(m)
    else
        errorbitnum=errorbitnum+1;
    end
end