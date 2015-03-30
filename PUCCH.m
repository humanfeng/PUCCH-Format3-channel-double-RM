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
global ackNackSRS_SimuTran
SYMBOL_L_SEQ=[0 1 5 6;0 1 4 5];%��1/1a/1b����£�����/��չCP��Ҫ����ķ�����
SYMBOL_L_SEQ_2=[0 2 3 4 6;0 1 2 4 5 ];%��2/2a/2b����£�����/��չCP��Ҫ����ķ�����
CPflag=0;
Delta_PUCCH_shift = 1;         %�뷢�Ͷ�TxDelta_PUCCH_shiftһ��
n_1_PUCCH = 289;                 %���ڴ���PUCCH��ʽ1/1a/1b�ķǸ���Դ���          
PUCCHN_1_cs = 5;                %��ʾ1/1a/1b��2/2a/2b���ʹ��ʱ����ʽ1/1a/1b �е�ѭ����λ��  
N_RB_sc = 12;                       %Ƶ������Դ��Ĵ�С�����ز���
N_cell_ID = 11;
n_RNTI = 256;
N_2_RB = 10;                         %ÿһ��ʱ϶��Ԥ����PUCCH��ʽ2/2a/2b�������Դ����Ŀ
n_2_PUCCH = 100;                %���ڴ���PUCCH��ʽ2/2a/2b�ķǸ���Դ���                     
ackNackSRS_SimuTran = 1;   %�Ƿ�����ͬʱ����PUCCH��SRS
Deta_ss = 0;                           %�ɸ߲������������PUSCH��������λģʽ��sequence-shift pattern��
N_PUCCH_seq=12;
M_RS_sc = N_PUCCH_seq;        %PUCCH��DMRS����
Group_hopping_enabled = 1;       %���ھ��������Ƿ�����Ƶ
Sequence_hopping_enabled = 1; %���ھ����Ƿ�������Ƶ
subframe_N = 2;
pucch_tpye = 3;              %PUCCH��Ϣ����
                                      %0:format1; 
                                      %1:format1a; 
                                      %2:format1b; 
                                      %3:format2;
									  %4:format2a;
									  %5:format2b
%PUCCHn_1(1)=0;
if pucch_tpye < 3                  %���ڸ�ʽ1/1a/1b 
    numbits = 1;                     %��ʽ1/1a��numbits=2;%��ʽ1a/1b
%input_b = randint(1,numbits);% ����������У�����Ϊ0��1��
    input_b = 1;                      %input_b=[0 1];
    z = PUCCHformat1(input_b,N_cell_ID,n_RNTI,subframe_N,pucch_tpye,ackNackSRS_SimuTran);
    Z=PUCCHDMRS(pucch_tpye,N_cell_ID,n_RNTI,subframe_N);
    
    Rxinput_b = dePUCCHformat1(z,N_cell_ID,n_RNTI,subframe_N,pucch_tpye);
    input_b 
    Rxinput_b
else                                        %���ڸ�ʽ2/2a/2b 
    numbits = 7;
    input_b = randint(1,numbits);  % ����������У�����Ϊ0��1��
    %10011000011101100011101000001001
%     input_b = [1 0 0 1 1 0 0 0 0 1 1 1 0 ];
    input_d_10=[1 0];%��ʽ2b
    input_rm_b = RM20encode(input_b);   %����RM���루�������ݸ���<=13��
    z = PUCCHformat2(input_rm_b,N_cell_ID,n_RNTI,subframe_N);
    Z = PUCCHDMRS(pucch_tpye,N_cell_ID,n_RNTI,subframe_N);
    
    Rxinput_rm_b = dePUCCHformat2(z,N_cell_ID,n_RNTI,subframe_N);
    Rxinput_rm_b = 1 - 2*Rxinput_rm_b;  %rm������Ҫ˫���Ի�
    Rxinput_b = FHTrmdecode(Rxinput_rm_b);  % ����������У�����Ϊ0��1��
    input_b
    Rxinput_b
end