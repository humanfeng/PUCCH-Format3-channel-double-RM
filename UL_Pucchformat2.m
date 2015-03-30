%**************************************************************************
%Copyright (C), 2012, CQUPT
%FileName:     dePUCCHformat2
%Description:  channel decoding for format 2/2a/2b
%Author:       DSP_GROUP
%Input:        1.z:
%Output:       Rxinput_b: decoded CQI bit for format 2/2a/2b
%History:
%      <time>      <version >
%      2012/5/15      1.0
%**************************************************************************
function Rxinput_b=UL_Pucchformat2(z)
%译码PUCCH格式2/2a/2b,得到符号Z
global SYMBOL_L_SEQ_2;
global CPflag;
global n_RNTI;
global N_cell_ID;
global Delta_PUCCH_shift;
global n_1_PUCCH;
global PUCCHN_1_cs;
global N_RB_sc;
global n_2_PUCCH;
global N_2_RB;
global PUCCHn_1;
global Subframe_N;
global Group_hopping_enabled;

N_PUCCH_seq = 12;
Rxinput_d = zeros(1,10);

%解扩
for j=1:2
    n_s = Subframe_N*2 + j-1;
    if Group_hopping_enabled==0
        f_gh=0;
    else
        f_gh=TxPUCCHCalf_gh(n_s,N_cell_ID);
    end
    u=mod(f_gh+mod(N_cell_ID,30),30);
    for k=1:5
        l=SYMBOL_L_SEQ_2(CPflag+1,k);
        TxPUCCHn_cell_cs=TxPUCCHCaln_cell_cs(n_s,l,CPflag,N_cell_ID);
        PUCCHAlpha2=PUCCHGenAlpha2(n_2_PUCCH,n_s,N_RB_sc,N_2_RB,PUCCHN_1_cs,TxPUCCHn_cell_cs,l);
        %alpha = 2 * pi * 2/12;
        M_RS_sc = N_RB_sc;
        r_alpha_u_v = rsgenforPUCCH(PUCCHAlpha2,u,M_RS_sc) ;  %生成r_alpha_u_v序列
        r_alpha_u_v_conj = conj(r_alpha_u_v);             %求共轭
        %解Z序列，由Z序列得出d(n)
        n=5*(j-1)+k;
        for i = 1 : N_RB_sc         %corrcoef
            z_index = N_PUCCH_seq * ( n - 1) + (i - 1);  %序号
            temp = z(z_index + 1) * r_alpha_u_v_conj(i); %/abs(r_alpha_u_v(i))即模为1
            Rxinput_d(n) = Rxinput_d(n) + temp;
        end
        Rxinput_d(n) = Rxinput_d(n)/N_RB_sc;
    end
end

%解调制
Rxinput_b1 = PUCCH_qpsk_demod(Rxinput_d);

%生成扰码序列
Rxinput_b1_len = length(Rxinput_b1);            %求长度
RandomSeqCinite = (floor(n_s / 2) + 1) * (2 * N_cell_ID + 1) * 2^16 + n_RNTI;
c = GenRandomSeq(Rxinput_b1_len, RandomSeqCinite);

%解扰
for i=1:Rxinput_b1_len    
    Rxinput_rm_b(i)=mod((Rxinput_b1(i)+c(i)),2);    
end

%RM译码
Rxinput_rm_b = 1 - 2*Rxinput_rm_b;            %RM译码需要双极性化
Rxinput_b = FHTrmdecode(Rxinput_rm_b);  % RM译码
