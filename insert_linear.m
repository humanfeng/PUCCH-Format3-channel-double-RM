function H_data = insert_linear(Hp)
%H_data�������ݲ��ֺ͵�Ƶ���ֵ���Ӧ
%Ƶ���������ŷ��˵�Ƶ��������ʱ������ֵ
global pucch_type;
global CPflag;
global N_RB_sc;
% [M,N] = size(RBdata);%12*14
H_data = zeros(12,14);
[R,S] = size(Hp); 

     %--------ȷ��LL��L1��L2
    if (pucch_type==0||pucch_type==1||pucch_type==2)&&(CPflag == 1)%1/1a/1b��չCP=2,3
        LL=6; L1=2+1;L2=3+1;
    else%2/2a/2b��ͨCP=1,5
        LL=7; 
        L1=2;L2=6;
    end
    %-------------------
  %��һ��ʱ϶
  for k = 1:N_RB_sc
   for L = 1:7
       H_data(k,L) = (L2-L)/(L2-L1)*Hp(k,L1)+(L-L1)/(L2-L1)*Hp(k,L2);%���Բ�ֵ
   end
  end
  %�ڶ���ʱ϶
  L1=9;L2=13; 
  for k = 1:N_RB_sc
   for L = 8:14
       H_data(k,L) = (L2-L)/(L2-L1)*Hp(k,L1)+(L-L1)/(L2-L1)*Hp(k,L2);%���Բ�ֵ
   end
  end