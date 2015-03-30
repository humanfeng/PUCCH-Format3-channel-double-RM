%**************************************************************************
%Copyright (C), 2012, CQUPT
%FileName:     ZF_equation
%Description:  channel equalization for PUCCH
%Author:       DSP_GROUP
%Input:        1.descfdma: data after OFDM demoded
%              2.H_data: channel estimation
%Output:       equ_data_ls: equalizated data 
%History:         
%      <time>      <version >    
%      2012/5/15      1.0     
%**************************************************************************
function equ_data_ls = ZF_equalization(descfdma,H_data,pucch_type)
global SYMBOL_L_SEQ;
global SYMBOL_L_SEQ_2;
global N_RB_sc;
%global pucch_type;
global CPflag;
global ackNackSRS_SimuTran;
[M,N] = size(descfdma);
re_data1 = descfdma./H_data;%包括导频
if pucch_type < 3                    %1/1a/1b
    if CPflag == 0
        D = 4;%数据符号数
        L = 7;%子帧总符号数
        for i = 1:2
            re_data(:,(i-1)*D+1) = re_data1(:,(i-1)*L+1);%去除导频
            re_data(:,(i-1)*D+2) = re_data1(:,(i-1)*L+2);
            re_data(:,(i-1)*D+3) = re_data1(:,(i-1)*L+6);
            if (ackNackSRS_SimuTran ==1) && (i==2)
                break;
            else
                re_data(:,(i-1)*D+4) = re_data1(:,(i-1)*L+7);
            end
        end
    else
        D = 4;%数据符号数
        L = 6;%子帧总符号数
        for i = 1:2
            re_data(:,(i-1)*D+1) = re_data1(:,(i-1)*L+1);%去除导频
            re_data(:,(i-1)*D+2) = re_data1(:,(i-1)*L+2);
            re_data(:,(i-1)*D+3) = re_data1(:,(i-1)*L+5);
            if (ackNackSRS_SimuTran ==1) && (i==2)
                re_data(:,(i-1)*D+4) = [];
            else
                re_data(:,(i-1)*D+4) = re_data1(:,(i-1)*L+6);
            end
        end
    end
else                                        %2/2a/2b
    if CPflag == 0
        D = 5;%数据符号数
        L = 7;%scfdma符号数
        for i = 1:2
            re_data(:,(i-1)*D+1) = re_data1(:,(i-1)*L+1);%去除导频
            re_data(:,(i-1)*D+2) = re_data1(:,(i-1)*L+3);
            re_data(:,(i-1)*D+3) = re_data1(:,(i-1)*L+4);
            re_data(:,(i-1)*D+4) = re_data1(:,(i-1)*L+5);
            re_data(:,(i-1)*D+5) = re_data1(:,(i-1)*L+7);
        end
    else%格式2
        D = 5;%数据符号数
        L = 6;%scfdma符号数
        for i = 1:2
            re_data(:,(i-1)*D+1) = re_data1(:,(i-1)*L+1);%去除导频
            re_data(:,(i-1)*D+2) = re_data1(:,(i-1)*L+2);
            re_data(:,(i-1)*D+3) = re_data1(:,(i-1)*L+3);
            re_data(:,(i-1)*D+4) = re_data1(:,(i-1)*L+5);
            re_data(:,(i-1)*D+5) = re_data1(:,(i-1)*L+6);
        end
    end
end
equ_data_ls = reshape(re_data, 1, N_RB_sc * size(re_data,2));
%======================================================

