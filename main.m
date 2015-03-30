

%**************************************************************************
%Copyright (C), 2014, CQUPT
%FileName:     PUCCH3 channel double RM
%Description:  channel estimation and equalization
%Author:       youboFeng
%=====================================================================
%本次仿真PUCCH 链路信道估计,频域上取1个资源块,子载波间隔deltaf=15kHz
%由于传输时以子帧为单位的,所以仿真时时域上取一个子帧,即两个时隙
%对于普通CP,一个时隙中的第一个符号CP=160,其余符号CP=144
%子载波subcarrier之间的导频间隔为0,即频域上导频连续排放,所以只做时域插值,频域不需要
%取14个SC-FDMA符号,一个ofdm符号长度为1/14ms.
%采用QPSK和PUCCH格式2b专用QPSK混合调制
%模型：1发2收
%**************************************************************************
clc;
clear all;
close all;
clc;
clear all;
global SYMBOL_L_SEQ;
global SYMBOL_L_SEQ_2;
global CPflag;
global Delta_PUCCH_shift;
global n_1_PUCCH;
global PUCCHN_1_cs;
global PUCCHn_1;
global N_RB_sc;
global N_cell_ID;
global n_RNTI;
global N_UL_RB;

global N_2_RB;
global pucch_type;
global N_ULRB;
global subframe_N ;
global CPflag;
global n_2_PUCCH;
global ackNackSRS_SimuTran;%是否允许同时发送PUCCH与SRS

global n_3_PUCCH;
global N_port;
global Group_hopping_enabled                                   %用于决定序列是否组跳频
global numbits
Group_hopping_enabled=1;
N_UL_RB=25;
n_3_PUCCH=2;
N_port=4;
PUCCHn_1=zeros(1,14);
SYMBOL_L_SEQ = [0 1 5 6;0 1 4 5];%在1/1a/1b情况下，常规/扩展CP需要计算的符号数
SYMBOL_L_SEQ_2 = [0 2 3 4 6;0 1 2 4 5 ];%在2/2a/2b情况下，常规/扩展CP需要计算的符号数
CPflag = 0;
N_ULRB = 25;
Delta_PUCCH_shift = 1;         %与发送端TxDelta_PUCCH_shift一样
n_1_PUCCH = 10;                    %用于传输PUCCH格式1/1a/1b的非负资源序号          
PUCCHN_1_cs = 5;                %表示1/1a/1b与2/2a/2b混合使用时，格式1/1a/1b 中的循环移位数  
N_RB_sc = 12;                       %频域上资源块的大小，子载波数
N_cell_ID = 0;
n_RNTI = 256;
N_2_RB = 0;                         %每一个时隙中预留给PUCCH格式2/2a/2b传输的资源块数目
n_2_PUCCH = 100;                %用于传输PUCCH格式2/2a/2b的非负资源序号                     
Deta_ss = 0;                           %由高层给定，用于求PUSCH基序列移位模式（sequence-shift pattern）
N_PUCCH_seq=12;
M_RS_sc = N_PUCCH_seq;        %PUCCH的DMRS生成
Group_hopping_enabled = 1;       %用于决定序列是否组跳频
Sequence_hopping_enabled = 0; %用于决定是否序列跳频
subframe_N = 2;
ackNackSRS_SimuTran=0;
pucch_type =2;                          %1/1a/1b/2/2a/2b=0/1/2/3/4/5 
pucch_type3=6;
Num_InRM=11;
%--------------------------------------------------------------------
   %bit_sourse3 = [1 0 1 0 1 0 1 0 1 0 1 0 1 0 ];
   %bit_sourse3 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 ]; %测试数据不要以连续多个零结尾，否则译码错误
   %bit_sourse3 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 ];
    bit_sourse3 = [1 0 1 0 1 0 1 1 1 1 1 1 1 1 ];
   %bit_sourse3 = [1 1 1 1 1 1 1 0 0 0 0 0 0 0 ];
   %bit_sourse3 = [0 0 0 0 0 0 0 1 1 1 1 1 1 1 ];
   %bit_sourse3 = [0 0 0 0 0 0 0 0 0 0]; %10个0
   %bit_sourse3 = [1 0 1 0 1 0 1 0 1 0]; %5个1 0 
   %bit_sourse3 = [1 1 1 1 1 1 1 1 1 1]; %10个1
   %bit_sourse3 = [1 1 1 1 1 0 0 0 0 0]; 
   %bit_sourse3 = [0 0 0 0 0 1 1 1 1 1]; 
   SingleRM_bit_sourse3 = [0 0 0 0 0 1 1 1 1 1];
   numbits = length(bit_sourse3);
   numbits1 = ceil(numbits/2);
   numbits2 = numbits-numbits1;
   B = 4*N_RB_sc;
   if ( numbits<=11 )
     RM_bit_sourse3 = TxRM3211(bit_sourse3,32);  %调用RM32编码（输入数据个数<=11）
     for ii = 1:B
        temp = mod(ii-1,32);
        RM_bit_sourse3_cycle(ii) = RM_bit_sourse3(temp+1);
     end
   elseif ( numbits>11 && numbits<=21 )
%--------------单个RM------------------------------------------------------       
       SingleRM_bit = TxRM3211(SingleRM_bit_sourse3,B);  %调用RM32编码（输入数据个数<=11）
%--------------双个常规RM------------------------------------------------------
       addzeros1 = zeros(1,Num_InRM-numbits1);
       addzeros2 = zeros(1,Num_InRM-numbits2);
       bit_sourse3_addzeros1 = [bit_sourse3(1:numbits1) addzeros1];
       bit_sourse3_addzeros2 = [bit_sourse3(numbits1+1:numbits) addzeros2];
       NormDRM_bit_part1 = TxRM3211(bit_sourse3_addzeros1,24);  %调用RM32编码（输入数据个数<=11）
       NormDRM_bit_part2 = TxRM3211(bit_sourse3_addzeros2,24);  %调用RM32编码（输入数据个数<=11）
       NormDRM_bit = [NormDRM_bit_part1 NormDRM_bit_part2];
%--------------重叠RM------------------------------------------------------
       bit_sourse3_part1 = bit_sourse3(1:numbits1);
       bit_sourse3_part2 = bit_sourse3(numbits1+1:numbits);
       addhead1 = bit_sourse3_part1(1:Num_InRM-numbits1);
       addhead2 = bit_sourse3_part2(1:Num_InRM-numbits1);
       if (numbits1>numbits2)
          bit_sourse3_part2=[bit_sourse3_part2 1];
       end
       bit_sourse3_part1ADDhead2 = [bit_sourse3_part1 addhead2];
       bit_sourse3_part2ADDhead1 = [bit_sourse3_part2 addhead1];
       OverlapDRM_bit_part1 = TxRM3211(bit_sourse3_part1ADDhead2,24);  %调用RM32编码（输入数据个数<=11）
       OverlapDRM_bit_part2 = TxRM3211(bit_sourse3_part2ADDhead1,24);  %调用RM32编码（输入数据个数<=11）
       OverlapDRM_bit = [OverlapDRM_bit_part1 OverlapDRM_bit_part2];  
   end
    reference3 = PUCCHDMRSformat3(N_cell_ID,n_RNTI,subframe_N);   %3DMRS生成
    [pilot_sequence3,inter_pilot_out3] = inter_pilot(reference3,pucch_type3);%在一个全零的12*14的矩阵中插入DMRS
%%SingleRM PUCCH3加扰
    SingleRM_symbol3 = PUCCHformat3(SingleRM_bit,N_cell_ID,n_RNTI,subframe_N,pucch_type3,ackNackSRS_SimuTran);  %控制信息生成
    SingleRM_symbol_sourse3 = data_map3(inter_pilot_out3,SingleRM_symbol3);%12*14矩阵,按照从上往下的顺序映射
    SingleRM_scfdma_signal3 = basesignalgen(SingleRM_symbol_sourse3);%利用ifft,SC-FDMA基带信号生成2048*14 
    SingleRM_scfdma3_reshape = reshape(SingleRM_scfdma_signal3,1,2048*14); %并串转换1* 28672     
    SingleRM_scfdma_cpout3 = insert_cp(SingleRM_scfdma3_reshape);%加CP之后,形成1行，30720列(=28672+2048)的矩阵     
%%常规双RM PUCCH3加扰
    NormDRM_symbol3 = PUCCHformat3(NormDRM_bit,N_cell_ID,n_RNTI,subframe_N,pucch_type3,ackNackSRS_SimuTran);  %控制信息生成
    NormDRM_symbol_sourse3 = data_map3(inter_pilot_out3,NormDRM_symbol3);%12*14矩阵,按照从上往下的顺序映射
    NormDRM_scfdma_signal3 = basesignalgen(NormDRM_symbol_sourse3);%利用ifft,SC-FDMA基带信号生成2048*14 
    NormDRM_scfdma3_reshape = reshape(NormDRM_scfdma_signal3,1,2048*14); %并串转换1* 28672     
    NormDRM_scfdma_cpout3 = insert_cp(NormDRM_scfdma3_reshape);%加CP之后,形成1行，30720列(=28672+2048)的矩阵   
%%重叠双RM PUCCH3加扰
    OverlapDRM_symbol3 = PUCCHformat3(OverlapDRM_bit,N_cell_ID,n_RNTI,subframe_N,pucch_type3,ackNackSRS_SimuTran);  %控制信息生成
    OverlapDRM_symbol_sourse3 = data_map3(inter_pilot_out3,OverlapDRM_symbol3);%12*14矩阵,按照从上往下的顺序映射
    OverlapDRM_scfdma_signal3 = basesignalgen(OverlapDRM_symbol_sourse3);%利用ifft,SC-FDMA基带信号生成2048*14 
    OverlapDRM_scfdma3_reshape = reshape(OverlapDRM_scfdma_signal3,1,2048*14); %并串转换1* 28672     
    OverlapDRM_scfdma_cpout3 = insert_cp(OverlapDRM_scfdma3_reshape);%加CP之后,形成1行，30720列(=28672+2048)的矩阵   

 %--------------------------归一化-----------------------------
 % scfdma_cpout = scfdma_cpout/max(abs(scfdma_cpout)); 
 %-------------------------------------------------------------
 SNR_dB = -10:15;
 BER_singleRM = zeros(1,length(SNR_dB));
 BER_NormDRM = zeros(1,length(SNR_dB));
 BER_OverlapRM = zeros(1,length(SNR_dB));
 
 Throughput_singleRM = zeros(1,length(SNR_dB));
 Throughput_NormDRM  = zeros(1,length(SNR_dB));
 Throughput_OverlapRM = zeros(1,length(SNR_dB));
 for ii = 1:length(SNR_dB)
    BitErr_singleRM = 0;
    BitErr_NormDRM  = 0;
    BitErr_OverlapRM= 0;
 for numm = 1:1000                      %每一个SNR值计算5次，以增大数据量
 % %************************************多径+噪声***********************************
    chan1=rayleighchan((1/30.72)*10^(-6),5,[0,30e-9,70e-9,90e-9,110e-9,190e-9,410e-9],[0,-1,-2,-3,-8,-17.2,-20.8]);%EPA5
% chan1=rayleighchan((1/30.72)*10^(-6),300,[0,30e-9,150e-9,310e-9,370e-9,710e-9,1090e-9,1730e-9,2510e-9],[0,-1.5,-1.4,-3.6,-0.6,-9.1,-7.0,-12.0,-16.9]);%EVA3
% chan1=rayleighchan((1/30.72)*10^(-6),5,[0,50e-9,120e-9,200e-9,230e-9,500e-9,1600e-9,2300e-9],[-1,-1,-1,0,0,0,-3,-5]);
% ***********************SingleRM PUCCH3多径+噪声***************************************************
     SingleRM_filout1_3 = filter(chan1,SingleRM_scfdma_cpout3);
     SingleRM_filout2_3 = filter(chan1,SingleRM_scfdma_cpout3); %经过2个随机EPA5，产生2个不同的接收信号
     SingleRM_scfdma_cpout_1_3 = SingleRM_filout1_3/max(abs(SingleRM_filout1_3));
     SingleRM_scfdma_cpout_2_3 = SingleRM_filout2_3/max(abs(SingleRM_filout2_3));
     SingleRM_sym_addnoise1_3 = awgn(SingleRM_scfdma_cpout_1_3,0);
     SingleRM_sym_addnoise2_3 = awgn(SingleRM_scfdma_cpout_2_3,SNR_dB(ii)); %1*30720
% ***********************正常双RM PUCCH3多径+噪声***************************************************
     NormDRM_filout1_3 = filter(chan1,NormDRM_scfdma_cpout3);
     NormDRM_filout2_3 = filter(chan1,NormDRM_scfdma_cpout3); %经过2个随机EPA5，产生2个不同的接收信号
     NormDRM_scfdma_cpout_1_3 = NormDRM_filout1_3/max(abs(NormDRM_filout1_3));
     NormDRM_scfdma_cpout_2_3 = NormDRM_filout2_3/max(abs(NormDRM_filout2_3));
     NormDRM_sym_addnoise1_3 = awgn(NormDRM_scfdma_cpout_1_3,0);
     NormDRM_sym_addnoise2_3 = awgn(NormDRM_scfdma_cpout_2_3,SNR_dB(ii)); %1*30720
% ***********************重叠双RM PUCCH3多径+噪声***************************************************
     OverlapDRM_filout1_3 = filter(chan1,OverlapDRM_scfdma_cpout3);
     OverlapDRM_filout2_3 = filter(chan1,OverlapDRM_scfdma_cpout3); %经过2个随机EPA5，产生2个不同的接收信号
     OverlapDRM_scfdma_cpout_1_3 = OverlapDRM_filout1_3/max(abs(OverlapDRM_filout1_3));
     OverlapDRM_scfdma_cpout_2_3 = OverlapDRM_filout2_3/max(abs(OverlapDRM_filout2_3));
     OverlapDRM_sym_addnoise1_3 = awgn(OverlapDRM_scfdma_cpout_1_3,0);
     OverlapDRM_sym_addnoise2_3 = awgn(OverlapDRM_scfdma_cpout_2_3,SNR_dB(ii)); %1*30720
 %%%%%%%%%%%%%%%%%%%%%%%解pucch3的复值符号%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 if pucch_type3==6 
 % ***********************SingleRM  PUCCH3复值符号***************************************************   
    SingleRM_Pucch_cutcp1_3 = UL_cutcp(SingleRM_sym_addnoise1_3);                        %去除CP,2048*14行
    SingleRM_Pucch_cutcp2_3 = UL_cutcp(SingleRM_sym_addnoise2_3);                        %去除CP,2048*14行
%     SingleRM_Pucch_cutcp1_3 = UL_cutcp(SingleRM_scfdma_cpout3);                        %去除CP,2048*14行
%     SingleRM_Pucch_cutcp2_3 = UL_cutcp(SingleRM_scfdma_cpout3);                        %去除CP,2048*14行
    SingleRM_descfdma1_3 = UL_deofdm(SingleRM_Pucch_cutcp1_3);                     %OFDM解调
    SingleRM_descfdma2_3 = UL_deofdm(SingleRM_Pucch_cutcp2_3);                     %OFDM解调
    SingleRM_descfdma3=(SingleRM_descfdma1_3+SingleRM_descfdma2_3)/2;
    [SingleRM_H_pls3,SingleRM_re_data3] = h_pls1(SingleRM_descfdma3,pilot_sequence3,pucch_type3);
    SingleRM_H_ls3 = linear_inter(SingleRM_re_data3,SingleRM_H_pls3); 
    SingleRM_equ_data_ls3 = ZF_equalization(SingleRM_re_data3,SingleRM_H_ls3,pucch_type3);
    SingleRM_Rxinput_rm= dePUCCHformat3(SingleRM_equ_data_ls3,N_cell_ID,n_RNTI,subframe_N);
 % ***********************正常双RM PUCCH3复值符号***************************************************   
    NormDRM_Pucch_cutcp1_3 = UL_cutcp(NormDRM_sym_addnoise1_3);                        %去除CP,2048*14行
    NormDRM_Pucch_cutcp2_3 = UL_cutcp(NormDRM_sym_addnoise2_3);                        %去除CP,2048*14行
    NormDRM_descfdma1_3 = UL_deofdm(NormDRM_Pucch_cutcp1_3);                     %OFDM解调
    NormDRM_descfdma2_3 = UL_deofdm(NormDRM_Pucch_cutcp2_3);                     %OFDM解调
    NormDRM_descfdma3=(NormDRM_descfdma1_3+NormDRM_descfdma2_3)/2;
    [NormDRM_H_pls3,NormDRM_re_data3] = h_pls1(NormDRM_descfdma3,pilot_sequence3,pucch_type3);
    NormDRM_H_ls3 = linear_inter(NormDRM_re_data3,NormDRM_H_pls3); 
    NormDRM_equ_data_ls3 = ZF_equalization(NormDRM_re_data3,NormDRM_H_ls3,pucch_type3);
    NormDRM_Rxinput_rm = dePUCCHformat3(NormDRM_equ_data_ls3,N_cell_ID,n_RNTI,subframe_N);    
     % ***********************重叠双RM PUCCH3复值符号***************************************************   
    OverlapDRM_Pucch_cutcp1_3 = UL_cutcp(OverlapDRM_sym_addnoise1_3);                        %去除CP,2048*14行
    OverlapDRM_Pucch_cutcp2_3 = UL_cutcp(OverlapDRM_sym_addnoise2_3);                        %去除CP,2048*14行
    OverlapDRM_descfdma1_3 = UL_deofdm(OverlapDRM_Pucch_cutcp1_3);                     %OFDM解调
    OverlapDRM_descfdma2_3 = UL_deofdm(OverlapDRM_Pucch_cutcp2_3);                     %OFDM解调
    OverlapDRM_descfdma3 = (OverlapDRM_descfdma1_3+OverlapDRM_descfdma2_3)/2;
    [OverlapDRM_H_pls3,OverlapDRM_re_data3] = h_pls1(OverlapDRM_descfdma2_3,pilot_sequence3,pucch_type3);
    OverlapDRM_H_ls3 = linear_inter(OverlapDRM_re_data3,OverlapDRM_H_pls3); 
    OverlapDRM_equ_data_ls3 = ZF_equalization(OverlapDRM_re_data3,OverlapDRM_H_ls3,pucch_type3);
    OverlapDRM_Rxinput_rm = dePUCCHformat3(OverlapDRM_equ_data_ls3,N_cell_ID,n_RNTI,subframe_N);
    
   %%%%%%%%%%%%%%%%%%%%%%%RM译码%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    if numbits>=11
% ***********************SingleRM译码**************************************
      SingleRM_Rxinput_rm = 1 - 2*SingleRM_Rxinput_rm;
      SingleRM_b3 = FHTrmdecode(SingleRM_Rxinput_rm);  % RM译码
      SingleRM_bit_sourse3;
% ***********************正常双RM译码**************************************
      NormDRM_Rxinput_rm_part1=NormDRM_Rxinput_rm(1,1:B/2);
      NormDRM_Rxinput_rm_part2=NormDRM_Rxinput_rm(1,B/2+1:B);
      NormDRM_Rxinput_rm_part1 = 1 - 2*NormDRM_Rxinput_rm_part1;
      NormDRM_Rxinput_rm_part2 = 1 - 2*NormDRM_Rxinput_rm_part2;
      NormDRM_Rxinput_b3_1 = FHTrmdecode24(NormDRM_Rxinput_rm_part1);  % RM译码
      NormDRM_Rxinput_b3_2 = FHTrmdecode24(NormDRM_Rxinput_rm_part2);  % RM译码
      NormDRM_b3=[NormDRM_Rxinput_b3_1(1,1:numbits1) NormDRM_Rxinput_b3_2(1,1:numbits2)];
      bit_sourse3;
% ***********************重叠RM译码***************************************
      Err_normRM1 = 0;
      Err_normRM2 = 0;
      Err_exchangeRM1 = 0;
      Err_exchangeRM2 = 0;
      Rxinput_overlap_rm1 = OverlapDRM_Rxinput_rm(1,1:B/2);
      Rxinput_overlap_rm2 = OverlapDRM_Rxinput_rm(1,B/2+1:B);
      Rxinput_overlap_rm1 = 1 - 2*Rxinput_overlap_rm1;
      Rxinput_overlap_rm2 = 1 - 2*Rxinput_overlap_rm2;
      Rxinput_b_norm1 = FHTrmdecode24(Rxinput_overlap_rm1);  % RM译码
      Rxinput_b_norm2 = FHTrmdecode24(Rxinput_overlap_rm2);  % RM译码
      Rxinput_b_norm1 = Rxinput_b_norm1(1:Num_InRM);
      Rxinput_b_norm2 = Rxinput_b_norm2(1:Num_InRM);
      Rxinput_Txnorm_rm1 = TxRM3211(Rxinput_b_norm1,24);  %调用RM32编码（输入数据个数<=11）
      Rxinput_Txnorm_rm2 = TxRM3211(Rxinput_b_norm2,24);  %调用RM32编码（输入数据个数<=11）
      Rxinput_Txnorm_rm1 = 1 - 2*Rxinput_Txnorm_rm1;
      Rxinput_Txnorm_rm2 = 1 - 2*Rxinput_Txnorm_rm2;
      Rxinput_b_exchange1 = [Rxinput_b_norm2(numbits1+1:Num_InRM) Rxinput_b_norm1(Num_InRM-numbits1+1:Num_InRM)];
      Rxinput_b_exchange2 = [Rxinput_b_norm1(numbits1+1:Num_InRM) Rxinput_b_norm2(Num_InRM-numbits1+1:Num_InRM)];
      Rxinput_Txexchange_rm1 = TxRM3211(Rxinput_b_exchange1,24);  %调用RM32编码（输入数据个数<=11）
      Rxinput_Txexchange_rm2 = TxRM3211(Rxinput_b_exchange2,24);  %调用RM32编码（输入数据个数<=11）
      Rxinput_Txexchange_rm1 = 1 - 2*Rxinput_Txexchange_rm1;
      Rxinput_Txexchange_rm2 = 1 - 2*Rxinput_Txexchange_rm2;
      for kk=1:B/2
         Err_normRM1= Err_normRM1 + ( Rxinput_overlap_rm1(kk)-Rxinput_Txnorm_rm1(kk) )^2;
         Err_normRM2= Err_normRM2 + ( Rxinput_overlap_rm2(kk)-Rxinput_Txnorm_rm2(kk) )^2;
         Err_exchangeRM1= Err_exchangeRM1 + ( Rxinput_overlap_rm1(kk)-Rxinput_Txexchange_rm1(kk) )^2;
         Err_exchangeRM2= Err_exchangeRM2 + ( Rxinput_overlap_rm2(kk)-Rxinput_Txexchange_rm2(kk) )^2;
      end 
      if Err_normRM1<Err_exchangeRM1
          Rx_overlapRM_b1=Rxinput_b_norm1;
      else
          Rx_overlapRM_b1=Rxinput_b_exchange1;
      end
      if Err_normRM2<Err_exchangeRM2
          Rx_overlapRM_b2=Rxinput_b_norm2;
      else
          Rx_overlapRM_b2=Rxinput_b_exchange2;
      end
      Rx_overlapRM_b3=[Rx_overlapRM_b1(1:numbits1) Rx_overlapRM_b2(1:numbits2)];
      bit_sourse3;
  else
     for jj = 1:32
        Rxinput_rm3(jj)=Rxinput_rm_cycle3(jj);
     end
      Rxinput_rm3 = 1 - 2*Rxinput_rm3;            %RM译码需要双极性化
      Rxinput_b3 = FHTrmdecode(Rxinput_rm3);  % RM译码
      bit_sourse3;
  end
 end
 %%%%%%%%%%%%%%%%%%%%%%统计PUCCH3 ACK/NACK 误比特率%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ***********************统计SingleRM 误比特********************************
 for i = 1:length(SingleRM_bit_sourse3)
     if SingleRM_b3(i) ~= SingleRM_bit_sourse3(i)
        BitErr_singleRM = BitErr_singleRM+1;
     end
 end
% ***********************统计正常双RM 误比特********************************
 for i = 1:length(bit_sourse3)
     if NormDRM_b3(i) ~= bit_sourse3(i)
        BitErr_NormDRM = BitErr_NormDRM + 1;
     end
 end
% ***********************统计重叠RM 误比特********************************
 for i = 1:length(bit_sourse3)
     if Rx_overlapRM_b3(i) ~= bit_sourse3(i)
        BitErr_OverlapRM = BitErr_OverlapRM + 1;
     end
 end
 end
% ***********************统计平均误比特率********************************
 
    BER_singleRM(ii) = BitErr_singleRM /numm/length(SingleRM_bit_sourse3);
    BER_NormDRM(ii) = BitErr_NormDRM /numm /length(bit_sourse3);
    BER_OverlapRM(ii) = BitErr_OverlapRM/numm /length(bit_sourse3) ;
% ***********************统计吞吐量********************************    
   Throughput_singleRM(ii) = numm*length(SingleRM_bit_sourse3) - BitErr_singleRM ;
   Throughput_NormDRM (ii) = numm*length(bit_sourse3) - BitErr_NormDRM ;
   Throughput_OverlapRM (ii)= numm*length(bit_sourse3) - BitErr_OverlapRM ;
 end
 format long;
 
 figure(1);
 semilogy (SNR_dB,BER_singleRM,'-*g');
 
 hold on
 semilogy (SNR_dB,BER_NormDRM,'-ob');
 hold off 
 
 hold on
 semilogy (SNR_dB,BER_OverlapRM,'-^r');
 hold off
 
 grid on;
 xlabel('信噪比SNR(db)');
 ylabel('误比特率BER');
 legend('SingleRM误比特率','常规双RM误比特率','重叠RM误比特率')
 
 figure(2);
 semilogy (SNR_dB,Throughput_singleRM,'-*g');
 
 hold on
 semilogy (SNR_dB,Throughput_NormDRM,'-ob');
 hold off 
 
 hold on
 semilogy (SNR_dB,Throughput_OverlapRM,'-^r');
 hold off
 
 grid on;
 xlabel('信噪比SNR(db)');
 ylabel('吞吐量bit');
 legend('SingleRM吞吐量','常规双RM吞吐量','重叠RM吞吐量')
 hold off  %%%%%%%%%%%%%%%%%%%%
 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
