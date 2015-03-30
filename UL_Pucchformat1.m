%**************************************************************************
%Copyright (C), 2012, CQUPT
%FileName:     dePUCCHformat1
%Description:  channel decoding for format 1a/1b
%Author:       DSP_GROUP
%Input:        1.z:
%Output:       Rxinput_b: decoded ACK/NACK bit for format 1a/1b
%History:
%      <time>      <version >
%      2012/5/15      1.0
%**************************************************************************
function Rxinput_b = UL_Pucchformat1(z)
%����PUCCH��ʽ1��1a,1b,����Z
global SYMBOL_L_SEQ;
global CPflag;
global n_RNTI;
global N_cell_ID;
global pucch_type;
global n_1_PUCCH;
global PUCCHN_1_cs;
global Delta_PUCCH_shift;
global N_RB_sc;
global ackNackSRS_SimuTran;
global Group_hopping_enabled;
global Sequence_hopping_enabled;
global Subframe_N;
global N_PUCCH_seq;

num_symbol=0;
for j=1:2
    % ��PUCCH��ռ������N_PUCCH_SF
    if( j==2 & ackNackSRS_SimuTran == 1)
        N_PUCCH_SF = 3;
    else
        N_PUCCH_SF = 4;
    end
    
    % ����N_PUCCH_SF����Ƶ����w_n_oc
    if N_PUCCH_SF == 4
        w_n_oc = [1 1 1 1 ;1 -1 1 -1 ;1 -1 -1 1;];
    else
        w_n_oc =[1 1 1;1 exp(1j*2*pi / 3) exp(1j*4*pi / 3);1  exp(1j*4*pi / 3)  exp(1j*2*pi / 3) ];
    end
    
    %ѡ��ÿ��ʱ϶��Ӧ��Uֵ
    n_s = Subframe_N*2 + j-1;
    if Group_hopping_enabled==0
        f_gh=0;
    else
        f_gh=TxPUCCHCalf_gh(n_s,N_cell_ID);
    end
    u=mod(f_gh+mod(N_cell_ID,30),30);
    % ������ز���;
    [PUCCHN_1 PUCCHn_oc PUCCHn_1]=PUCCHParaCalculate(n_s,PUCCHN_1_cs,CPflag,Delta_PUCCH_shift,...
        n_1_PUCCH,N_RB_sc);
    
    if mod(PUCCHn_1(n_s+1),2)==0
        S=1;
    else
        S = 1i;
    end
    
    for i=1:N_PUCCH_SF
        l=SYMBOL_L_SEQ(CPflag+1,i);
        TxPUCCHn_cell_cs=TxPUCCHCaln_cell_cs(n_s,l,CPflag,N_cell_ID);
        PUCCHAlpha1=PUCCHGenAlpha1(TxPUCCHn_cell_cs,PUCCHn_oc,PUCCHn_1,n_s,CPflag,...
            Delta_PUCCH_shift,PUCCHN_1,l,...
            N_RB_sc);
        Rxinput_y=0;
        Rxinput_d_sum=0;

        M_RS_sc = N_RB_sc;
        
        r_alpha_u_v = rsgenforPUCCH(PUCCHAlpha1,u,M_RS_sc) ;  %����r_alpha_u_v����
        r_alpha_u_v_conj = conj(r_alpha_u_v);             %����
        
        %��Z���У���Z���еó�y(n)
        S_conj = conj(S);                %����
        w_n_oc_conj = conj(w_n_oc);      %����
        for n = 1 : N_PUCCH_seq
            z_index = (j-1) * 4 * N_PUCCH_seq + (i-1) * N_PUCCH_seq + n - 1;  %���
            Rxinput_y = z(z_index + 1) * S_conj * w_n_oc_conj(PUCCHn_oc+1,i);       %y = z/(s*w)=z*conj(s)*conj(w)
            temp = Rxinput_y * r_alpha_u_v_conj(n);
            Rxinput_d_sum = Rxinput_d_sum + temp;
        end
        num_symbol=num_symbol+1;
        RxPUCCHd1(4*(j-1)+i)=Rxinput_d_sum/N_PUCCH_seq;
    end
    
end
d_sum=0;
for i=1:num_symbol
    d_sum = d_sum+RxPUCCHd1(i);
end
RxPUCCHd=d_sum/num_symbol;

%�����
Rxinput_b = demod_pucch(RxPUCCHd,pucch_type);


