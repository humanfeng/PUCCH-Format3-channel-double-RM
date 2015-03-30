function H_data = linear_inter(re_data,Hp)
%H_data�������ݲ��ֺ͵�Ƶ���ֵ���Ӧ
%Ƶ���������ŷ��˵�Ƶ��������ʱ������ֵ�����ڱ��ظ���ֵ
global pucch_type;
global CPflag;
[M,N] = size(re_data);%12*14
H_data = zeros(M,N);
[R,S] = size(Hp);          
if CPflag == 0
    L = 7;
    if pucch_type < 3       %1/1a/1b�Ĳ�ֵ��ʱ϶��ƽ��
       for m = 1:M
        H_data(m,1:L) = sum(Hp(m,1:S/2))/(S/2);
        H_data(m,L+1:N) = sum(Hp(m,S/2+1:S))/(S/2);         
       end
    else                          %2/2a/2b�Ĳ�ֵ�����Բ�ֵ
ff = [2 6 9 13];
f = 1:14;
for i = 1:M
    H_data(i,f) = interp1(ff,Hp(i,1:4),f);   %ʱ���ֵ
end
 H_data(:,1) = Hp(:,1);
 H_data(:,N) = Hp(:,S);
end
end
 %=========================================================