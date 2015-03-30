%**************************************************************************
%Copyright (C), 2012, CQUPT
%FileName:     RxPUCCHDMRSformat2
%Description:  generate reference signal for format 2/2a/2b
%Author:       DSP_GROUP
%Input:        demapdata: data after OFDM demoding
%Output:       1.RS_2: reference signal for format 2/2a/2b
%              2.Rx_d_10: the 10th symbol for ACK/NACK(format 2a/2b)
%History:
%      <time>      <version >
%      2012/5/15      1.0
%**************************************************************************
function [RS_2 Rx_d_10]=UL_PucchDMRS2(demapdata)

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
global pucch_type
global N_PUCCH_seq

M_RS_sc = N_RB_sc;

%format2/2a/2b
if pucch_type>=3
    if (CPflag==0)
        w_1=[1 1];
        N_PUCCH_RS=2;
        l=[1 5];
        rx_RS = demapdata(:,[6 13]);
    else
        w_1=[1];
        N_PUCCH_RS=1;
        l=3;
    end
    
    for  j=1:2
        n_s = Subframe_N*2 + j-1;
        fgh_ns=0; %初始化TxULRS_u
        if (Group_hopping_enabled == 0)
            fgh_ns=0;
        else
            RandomSeqCinite =floor(N_cell_ID/30);
            RandomSeqInLen = 8*n_s + 8;
            RandomSeqDataOut= GenRandomSeq(RandomSeqInLen,RandomSeqCinite);
            for i=0:7
                fgh_ns=fgh_ns+mod(RandomSeqDataOut(8*n_s+i+1)*2.^i,30);
            end
        end
        fss_PUCCH=mod(N_cell_ID,30);
        u=mod(fgh_ns+fss_PUCCH,30);%TxULRS_u
        for m=1:N_PUCCH_RS
            z=1;
            %计算TxPUCCHn_cell_cs;
            TxPUCCHn_cell_cs=TxPUCCHCaln_cell_cs(n_s,l(m),CPflag,N_cell_ID);
            PUCCHAlpha2=PUCCHGenAlpha2(n_2_PUCCH,n_s,N_RB_sc,N_2_RB,PUCCHN_1_cs,TxPUCCHn_cell_cs,l(m));
            
            M_RS_sc = N_RB_sc;
            r_alpha_u_v = rsgenforPUCCH(PUCCHAlpha2,u,M_RS_sc) ;  %生成r_alpha_u_v序列
            
            for n = 1 : N_PUCCH_seq
                %生成RS_2序列
                z_index = (j-1) * N_PUCCH_RS * M_RS_sc + (m-1) * N_PUCCH_seq + n - 1;  %序号
                temp = w_1(m) * z * r_alpha_u_v(n);       %元素值
                RS_2(z_index + 1) = temp;
                if(m==1)
                    DMRS_1(z_index+1-(j-1)*12)=temp;
                elseif m==2
                    DMRS_10(z_index+1-j*12)=temp;
                end
            end
        end
    end
end
% 针对2a/2b, 检测包含在第10符号内的ACK/NACK信息，同时更新其参考信号的信道估计结果
Rx_d_10=0;

        h_rs11=demapdata(:,[2]).'/DMRS_1(1:12);
        h_rs12=demapdata(:,[9]).'/DMRS_1(13:24);
        rx_RS_est1=DMRS_10(1:12).* h_rs11;
        rx_RS_est2=DMRS_10(13:24).* h_rs12;
if pucch_type > 3
       
    if (pucch_type == 4)
        diff(1) = sum(abs(rx_RS(:,1).'- DMRS_10(1:12))) + sum(abs(rx_RS(:,2).'- DMRS_10(13:24)));
        diff(2) = sum(abs(rx_RS(:,1).'+ DMRS_10(1:12))) + sum(abs(rx_RS(:,2).'+ DMRS_10(13:24)));
        [a,b] = min(diff);
        if b == 1
            Rx_d_10 = 0;
        else
            Rx_d_10 = 1;
            DMRS_10 = -1* DMRS_10;
            RS_2(13:24) = -1*RS_2(13:24);
            RS_2(37:48) = -1*RS_2(37:48);
        end
    else
        diff(1) = sum(abs(rx_RS(:,1).'- rx_RS_est1)) + sum(abs(rx_RS(:,2).'-rx_RS_est2));
        diff(2) = sum(abs(rx_RS(:,1).'+ rx_RS_est1)) + sum(abs(rx_RS(:,2).'+rx_RS_est2));
        diff(3) = sum(abs(rx_RS(:,1).'- 1i * rx_RS_est1)) + sum(abs(rx_RS(:,2).'- 1i *rx_RS_est2));
        diff(4) = sum(abs(rx_RS(:,1).'+ 1i * rx_RS_est1)) + sum(abs(rx_RS(:,2).'+ 1i *rx_RS_est2));
        [a,b] = min(diff);
        if b == 1
            Rx_d_10 = [0 0];
        elseif b==2
            Rx_d_10 = [1 1];
            DMRS_10 = -1* DMRS_10;
            RS_2(13:24) = -1*RS_2(13:24);
            RS_2(37:48) = -1*RS_2(37:48);
        elseif b==3
            Rx_d_10 = [1 0];
            DMRS_10 = 1i* DMRS_10;
            RS_2(13:24) = 1i*RS_2(13:24);
            RS_2(37:48) = 1i*RS_2(37:48);
        else
            Rx_d_10 = [0 1];
            DMRS_10 = -1i* DMRS_10;
            RS_2(13:24) = -1i*RS_2(13:24);
            RS_2(37:48) = -1i*RS_2(37:48);
        end
    end
end
    
