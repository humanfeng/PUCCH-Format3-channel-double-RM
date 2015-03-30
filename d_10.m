clc;
clear;
global SYMBOL_L_SEQ;
global SYMBOL_L_SEQ_2;
global CPflag;
global Delta_PUCCH_shift;
global n_1_PUCCH;
global PUCCHN_1_cs;
global N_RB_sc;
global N_cell_ID;
global n_RNTI;
global n_2_PUCCH;
global N_2_RB;
global input_d_10;

ii=1;
for snr=-18:-2
k=0;
k_1=0;
for i=1:10000
input_d_10=[0 0];

CPflag=0;
Delta_PUCCH_shift = 1;          %与发送端TxDelta_PUCCH_shift一样
n_1_PUCCH = 55;                 %用于传输PUCCH格式1/1a/1b的非负资源序号          
PUCCHN_1_cs = 5;                %表示1/1a/1b与2/2a/2b混合使用时，格式1/1a/1b 中的循环移位数  
N_RB_sc = 12;                   %频域上资源块的大小，子载波数
N_cell_ID = 11;
n_RNTI = 256;
N_2_RB = 10;                    %每一个时隙中预留给PUCCH格式2/2a/2b传输的资源块数目
n_2_PUCCH = 100;                %用于传输PUCCH格式2/2a/2b的非负资源序号                     
ackNackSRS_SimuTran = 1;        %是否允许同时发送PUCCH与SRS
Deta_ss = 0;                    %由高层给定，用于求PUSCH基序列移位模式（sequence-shift pattern）
N_PUCCH_seq=12;
M_RS_sc = N_PUCCH_seq;           %
Group_hopping_enabled = 1;       %用于决定序列是否组跳频
Sequence_hopping_enabled = 1;    %用于决定是否序列跳频

subframe_N = 2;

pucch_tpye = 5;                   %PUCCH信息类型
                                      %0:FORMAT1; 
                                      %1:FORMAT1a; 
                                      %2:FORMAT1b; 
                                      %3:FORMAT2;
									  %4:FORMAT2a;
									  %5:FORMAT2b
 
[Z DMRS_10]=PUCCHDMRS(pucch_tpye,N_cell_ID,n_RNTI,subframe_N);


%瑞利信道
% chan1=rayleighchan((1/30.72)*10^(-6),0,[0,30e-9,70e-9,90e-9,110e-9,190e-9,410e-9],[0,-1,-2,-3,-8,-17.2,-20.8]);
% % H=(randn(4,4)+j*randn(4,4))/sqrt(2);             %信道冲击响应矩阵
% filout1=filter(chan1,DMRS_10);    %每一列都通过信道
% filout1=H*DMRS_10;
 y = awgn(DMRS_10,snr); 
% y=DMRS_10;

DMRS_10_1=zeros(6,24);
a=zeros(24,1);
%生成六个可能的值分别存入相应的数组,这里假设我们已经知道PUCCH信息类型
% pucch_tpye=4;
% input_d_10=[0];
% [Z DMRS_10]=PUCCHDMRS(pucch_tpye,N_cell_ID,n_RNTI,subframe_N);
% DMRS_10_1(1,:)=DMRS_10;
% 
% input_d_10=[1];
% [Z DMRS_10]=PUCCHDMRS(pucch_tpye,N_cell_ID,n_RNTI,subframe_N);
% DMRS_10_1(2,:)=DMRS_10;

pucch_tpye=5;
input_d_10=[0 0];
[Z DMRS_10]=PUCCHDMRS(pucch_tpye,N_cell_ID,n_RNTI,subframe_N);
DMRS_10_1(3,:)=DMRS_10;

input_d_10=[0 1];
[Z DMRS_10]=PUCCHDMRS(pucch_tpye,N_cell_ID,n_RNTI,subframe_N);
DMRS_10_1(4,:)=DMRS_10;

input_d_10=[1 0];
[Z DMRS_10]=PUCCHDMRS(pucch_tpye,N_cell_ID,n_RNTI,subframe_N);
DMRS_10_1(5,:)=DMRS_10;

input_d_10=[1 1];
[Z DMRS_10]=PUCCHDMRS(pucch_tpye,N_cell_ID,n_RNTI,subframe_N);
DMRS_10_1(6,:)=DMRS_10;
% %%%%%%%%%%%%%%生成六个被选信号%%%%%%%%%%%%%%%%%%%
% 

% 方法一
Result1=DMRS_10_1(3,:)*y';
Result1=Result1/24;
if (real(Result1)>0)&&(abs(real(Result1))>=abs(imag(Result1)))
  t=1;
elseif (imag(Result1)<0)&&(abs(imag(Result1))>abs(real(Result1)))
  t=2;
elseif (real(Result1)<0)&&(abs(real(Result1))<=abs(imag(Result1)))
  t=4;
else
  t=3;
end
if t==1
k_1=k_1+1;
end


%方法二
% %***********************做相关*************************
Result=DMRS_10_1*y';
[remax,index]=max(real(Result));
if index==3
    k=k+1;
end
end
% %统计方法一的误块率
k_1=k_1/10000;
k1_seq(ii)=1-k_1;

%统计方法二的误块率
k=k/10000;
k_seq(ii)=1-k;
ii=ii+1;
end
snr=-18:-2;
format long;
% plot(snr,k_seq,'-r');
semilogy (snr,k_seq,'-r');
hold on
semilogy (snr,k1_seq,'-g');
grid on;
xlabel('信噪比(db)');
ylabel('误块率(db)');
a=1;
% [Z DMRS_10]=PUCCHDMRS_1(pucch_tpye,N_cell_ID,n_RNTI,subframe_N);
% a=DMRS_10*y';
% Result=a/24;
% semilogy (i,k,'r-o')
% semilogy (i,k,'r-o')
% semilogy (snr_dB,err_ber_blast_zf2,'r-d')
% semilogy (snr_dB,err_ber_mlblast,'b:+')
% semilogy (snr_dB,err_ber_mlblast1,'g-s')
% grid on;
% axis([-5,15,0.0001,1]);
% legend('ml','v-blast','第一层取4个候选点','第一层取2个点');
% xlabel('Eb/No in dB');
% ylabel('BER');
% title('4发4收的天线系统下采用QPSK调制方式下各算法性能比较');





