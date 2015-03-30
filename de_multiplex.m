function  out_data=de_multiplex(re_data,N_UL_RB)

re_data1=flipdim(re_data,1);%��bit_recieve1���������ϵ����ݵ�������
re_data2=[re_data1(:,1),re_data1(:,3:5),re_data1(:,7:8),re_data1(:,10:12),re_data1(:,14)];
[M,N]=size(re_data2);
re_data2=re_data2';%10*12����
re_data3=[re_data1(:,2),re_data1(:,6),re_data1(:,9),re_data1(:,13)];
re_data3=re_data3';
N_ULsymb=7;% number of SC-FDMA symbols in an uplink slot at normal cyclic prefix
N_cellID=1;%С��ID
%ns=1:2;%ʱ϶�ſ���ȡ0��19,matlab�б�����1��ʼ����ʱ϶��ȡֵ1��20.
N_RBsc=12;
M_RSsc=N_UL_RB*N_RBsc;%M_RSsc=N_RBsc
%N_RSZC=11;
v=0;%v=0��1��36.211��21ҳ
%for u=1:30;%u=0:29
  %for n=1:M_RSsc;%0<= n <M_RSsc
f_gh=0;%��������Ƶ������
f_PUCCHss=mod(N_cellID,30);
delta_ss=1;%(0,1,...29)
u=mod(f_gh+f_PUCCHss,30);
%for m=1:N_RSZC;%0<= m <=N_RSZC-1
    %q1=N_RSZC*(u+1)/31;
    %q=floor(q1+0.5)+v*(-1)^floor(2*q1);
    %x_q(m)=exp(-j*(pi*q*(m-1)*m/N_RSZC));
%end
   %r1(u,n)=x_q(u,m)*(mod(n-1,N_RSZC));%36.211��������
 % end
%end
%for n=1:M_RSsc%0<= n <M_RSsc
    %r1(n)=x_q(mod(n-1,N_RSZC)+1);%36.211��������r1��1*36����
%end
% -------------multiplex part
p1 = [-1 1 3 -3 3 3 1 1 3 1 -3 3;                    % definition the value of p(u,n)
      1 1 3 3 3 -1 1 -3 -3 1 -3 3;              % 36.211,table5.5.1.2-1
      1 1 -3 -3 -3 -1 -3 -3 1 -3 1 -1;
      -1 1 1 1 1 -1 -3 -3 1 -3 1 -1;
      -1 3 1 -1 1 -1 -3 -1 1 -1 1 3;
      1 -3 3 -1 -1 1 1 -1 -1 3 -3 1;
      -1 3 -3 -3 -3 3 1 -1 3 3 -3 1;
      -3 -1 -1 -1 1 -3 3 -1 1 -3 3 1;
       1 -3 3 1 -1 -1 -1 1 1 3 -1 1;
       1 -3 -1 3 3 -1 -3 1 1 1 1 1;
      -1 3 -1 1 1 -3 -3 -1 -3 -3 3 -1;
       3 1 -1 -1 3 3 -3 1 3 1 3 3 ;
       1 -3 1 1 -3 1 1 1 -3 -3 -3 1;
       3 3 -3 3 -3 1 1 3 -1 -3 3 3;
       -3 1 -1 -3 -1 3 1 3 3 3 -1 1;
       3 -1 1 -3 -1 -1 1 1 3 1 -1 -3;
       1 3 1 -1 1 3 3 3 -1 -1 3 -1;
       -3 1 1 3 -3 3 -3 -3 3 1 3 -1;
       -3 3 1 1 -3 1 -3 -3 -1 -1 1 -3;
       -1 3 1 3 1 -1 -1 3 -3 -1 -3 -1;
       -1 -3 1 1 1 1 3 1 -1 1 -3 -1;
       -1 3 -1 1 -3 -3 -3 -3  -3 1 -1 -3;
       1 1 -3 -3 -3 -3 -1 3 -3 1 -3 3;
       1 1 -1 -3 -1 -3 1 -1 1 3 -1 1;
       1 1 3 1 3 3 -1 1 -1 -3 -3 1;
       1 -3 3 3 1 3 3 1 -3 -1 -1 3;
       1 3 -3 -3 3 -3 1 -1 -1 3 -1 -3;
       -3 -1 -3 -1 -3 3 1 -1 1 3 -3 -3;
       -1 3 -3 3 -1 3 3 -3 3 3 -1 -1;
       3 -3 -3 -1 -1 -3 -1 3 -3 3 1 -1
        ];
  for n = 1:12
      r_1(u,n) = exp(j * p1(u,n) * pi / 4); % Base sequences r1(u,n) of length less than 3*NRBsc
   end                              % 36.211,section 5.5.1.2

   r1= r_1(u,:);
nPUCCH(2) = 1; % resource index for PUCCH formats 2/2a/2b,provided by higher layers,here the number is assumed as 1;
cinit=N_cellID;
ns=5;%nsȡֵΪ4��5
lenc=8*N_ULsymb*ns+8*N_ULsymb+8;%����α������г���
c=pseudo(cinit,lenc);

%for ns=4:5 %ѡȡһ��ϵͳ֡�еĵ�������֡��ʱ϶4��ʱ϶5�����������ŵ���Ϣ
 ns=4; 
 for l=1:N_ULsymb
   for i=1:8
       n_c1(i,l)=c(8*N_ULsymb*ns+8*(l-1)+i-1)*(2^(i-1));
   end
      n_PRS1(l)=sum(n_c1(:,l));
 end
 ns=5;
 for l=1:N_ULsymb
   for i=1:8
       n_c2(i,l)=c(8*N_ULsymb*ns+8*(l-1)+i-1)*(2^(i-1));
   end
      n_PRS2(l)=sum(n_c2(:,l));
 end
 n_PRS1;
 n_PRS2;
n_cell_cs(4:5,:)=[n_PRS1;n_PRS2]

n_cell_cs(4:5,2)=n_cell_cs(4:5,3);
n_cell_cs(4:5,3)=n_cell_cs(4:5,4);
n_cell_cs(4:5,4)=n_cell_cs(4:5,5);
n_cell_cs(4:5,5)=n_cell_cs(4:5,7);
n_cell_cs(4:5,:);
n_cell_cs=n_cell_cs(4:5,1:5);
n_cs=mod(n_cell_cs+nPUCCH(2),N_RBsc);
a1=2*pi*n_cs/N_RBsc; % the cyclic shift a
                      % 36.211,p19
a=[a1(1,:),a1(2,:)];%һ����֡�г��ο��ź���ռOFDM�����������OFDM���Ŷ�Ӧ��ѭ����λ���ο�36.211 5.4.2P19
for i=1:length(a)
  for n=1:M_RSsc
   r_a(i,n)=exp(j*a(i)*(n-1))*r1(n);%�ο��ź����У�����a�ھ����õ���ʱ��������Ӧ��ֵ
 end
end
size(r_a);%�˴���10*12����
%for i=1:length(a)
 % for n=1:M_RSsc
   %ra(i,n)=conj(r_a(i,n));%�Բο����е�Ԫ��ȡ����
% end
%end
N_PUCCHSeq = 12; % the cyclic shifted length of PUCCH sequence,set as 12
for i = 1:10
  for n = 1:N_PUCCHSeq
     d1(i,n) = re_data2(i,n)/r_a(i,n); % d(0),...,d(9) is multiplied with a cyclically shifted length N_PUCCHSeq=12 sequence r_a with the length of 120
  end 
    d(i)=sum(d1(i,:))/12;
end
for i=1:4
   for  n = 1:N_PUCCHSeq
     d2(i,n)=re_data3(i,n)/r_a(i,n);
   end
   dd(i)=sum(d2(i,:))/12;
end
out_data=[d,1];%?????????
size(out_data);
