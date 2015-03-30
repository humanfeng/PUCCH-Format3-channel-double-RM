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
Delta_PUCCH_shift = 1;          %�뷢�Ͷ�TxDelta_PUCCH_shiftһ��
n_1_PUCCH = 55;                 %���ڴ���PUCCH��ʽ1/1a/1b�ķǸ���Դ���          
PUCCHN_1_cs = 5;                %��ʾ1/1a/1b��2/2a/2b���ʹ��ʱ����ʽ1/1a/1b �е�ѭ����λ��  
N_RB_sc = 12;                   %Ƶ������Դ��Ĵ�С�����ز���
N_cell_ID = 11;
n_RNTI = 256;
N_2_RB = 10;                    %ÿһ��ʱ϶��Ԥ����PUCCH��ʽ2/2a/2b�������Դ����Ŀ
n_2_PUCCH = 100;                %���ڴ���PUCCH��ʽ2/2a/2b�ķǸ���Դ���                     
ackNackSRS_SimuTran = 1;        %�Ƿ�����ͬʱ����PUCCH��SRS
Deta_ss = 0;                    %�ɸ߲������������PUSCH��������λģʽ��sequence-shift pattern��
N_PUCCH_seq=12;
M_RS_sc = N_PUCCH_seq;           %
Group_hopping_enabled = 1;       %���ھ��������Ƿ�����Ƶ
Sequence_hopping_enabled = 1;    %���ھ����Ƿ�������Ƶ

subframe_N = 2;

pucch_tpye = 5;                   %PUCCH��Ϣ����
                                      %0:FORMAT1; 
                                      %1:FORMAT1a; 
                                      %2:FORMAT1b; 
                                      %3:FORMAT2;
									  %4:FORMAT2a;
									  %5:FORMAT2b
 
[Z DMRS_10]=PUCCHDMRS(pucch_tpye,N_cell_ID,n_RNTI,subframe_N);


%�����ŵ�
% chan1=rayleighchan((1/30.72)*10^(-6),0,[0,30e-9,70e-9,90e-9,110e-9,190e-9,410e-9],[0,-1,-2,-3,-8,-17.2,-20.8]);
% % H=(randn(4,4)+j*randn(4,4))/sqrt(2);             %�ŵ������Ӧ����
% filout1=filter(chan1,DMRS_10);    %ÿһ�ж�ͨ���ŵ�
% filout1=H*DMRS_10;
 y = awgn(DMRS_10,snr); 
% y=DMRS_10;

DMRS_10_1=zeros(6,24);
a=zeros(24,1);
%�����������ܵ�ֵ�ֱ������Ӧ������,������������Ѿ�֪��PUCCH��Ϣ����
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
% %%%%%%%%%%%%%%����������ѡ�ź�%%%%%%%%%%%%%%%%%%%
% 

% ����һ
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


%������
% %***********************�����*************************
Result=DMRS_10_1*y';
[remax,index]=max(real(Result));
if index==3
    k=k+1;
end
end
% %ͳ�Ʒ���һ�������
k_1=k_1/10000;
k1_seq(ii)=1-k_1;

%ͳ�Ʒ������������
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
xlabel('�����(db)');
ylabel('�����(db)');
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
% legend('ml','v-blast','��һ��ȡ4����ѡ��','��һ��ȡ2����');
% xlabel('Eb/No in dB');
% ylabel('BER');
% title('4��4�յ�����ϵͳ�²���QPSK���Ʒ�ʽ�¸��㷨���ܱȽ�');





