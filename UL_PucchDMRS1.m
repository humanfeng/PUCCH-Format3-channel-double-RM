%**************************************************************************
%Copyright (C), 2012, CQUPT
%FileName:     PUCCHDMRSformat1
%Description:  generate reference signal for format 1a/1b
%Author:       DSP_GROUP
%Input:
%Output:       RS_1: reference signal for format 1a/1b
%History:
%      <time>      <version >
%      2012/5/15      1.0
%**************************************************************************
function RS_1 =UL_PucchDMRS1()

global CPflag;
global N_cell_ID;
global n_RNTI;
global Subframe_N;
global Delta_PUCCH_shift;
global n_1_PUCCH;
global PUCCHN_1_cs;
global N_RB_sc;
global input_d_10;
global n_2_PUCCH;
global N_2_RB;
global PUCCHn_1;
global Group_hopping_enabled;
global Sequence_hopping_enabled;
global pucch_type;
global N_PUCCH_seq;

M_RS_sc = N_RB_sc;     %�ο��ź���ռ���ز���

%format1/1a/1b
if(pucch_type==0 | pucch_type==1 | pucch_type==2)
    z=1;
    %��Ƶ���м�RS��ռ������
    if (CPflag==0)
        w_1=[1 1 1;1 exp(1j*2*pi/3) exp(1j*4*pi/3);1 exp(1j*4*pi/3) exp(1j*2*pi/3)];
        N_PUCCH_RS=3;
    else
        w_1=[1 1;1 -1;0 0];
        N_PUCCH_RS=2;
    end
    
    for  j=1:2          %��ʱ϶ѭ��
        n_s = Subframe_N*2 + j-1;    %ʱ϶��
        [PUCCHN_1 PUCCHn_oc PUCCHn_1] = PUCCHDMRSParaCalculate(n_s,PUCCHN_1_cs,CPflag,...
            Delta_PUCCH_shift,n_1_PUCCH,N_RB_sc);
        %ѡ��ÿ��ʱ϶��Ӧ��Uֵ
        if Group_hopping_enabled==0
            f_gh=0;
        else
            f_gh=TxPUCCHCalf_gh(n_s,N_cell_ID);
        end
        u=mod(f_gh+mod(N_cell_ID,30),30);
        for m=1:N_PUCCH_RS
            l=m+1;
            %����TxPUCCHn_cell_cs;
            TxPUCCHn_cell_cs=TxPUCCHCaln_cell_cs(n_s,l,CPflag,N_cell_ID);
            PUCCHAlpha1=PUCCHDMRSGenAlpha1(TxPUCCHn_cell_cs,PUCCHn_oc,PUCCHn_1,n_s,...
                CPflag,Delta_PUCCH_shift,PUCCHN_1,l,N_RB_sc);
            r_alpha_u_v = rsgenforPUCCH(PUCCHAlpha1,u,M_RS_sc) ;  %����r_alpha_u_v����
            
            for n = 1 : N_PUCCH_seq
                %����Z����
                z_index = (j-1) * N_PUCCH_RS * M_RS_sc + (m-1) * N_PUCCH_seq + n - 1;  %���
                temp = w_1(PUCCHn_oc+1,m) * z * r_alpha_u_v(n);       %Ԫ��ֵ
                RS_1(z_index + 1) = temp;
            end
        end
    end
end
