%**************************************************************************
%Copyright (C), 2012, CQUPT
%FileName:     PUCCH_demap
%Description:  physical resource demapping for PUCCH
%Author:       DSP_GROUP
%Input:        z_out: data after OFDM demoded
%Output:       1.demapdata0: demapping with the PUCCH SR resource index
%              2.demapdata1: demapping with other resource index
%              3.Rx_SR: indication SR is included or not: 0-no;1-yes;
%History:
%      <time>      <version >
%      2012/5/15      1.0
%**************************************************************************
function [demapdata0,demapdata1,Rx_SR] = UL_Pucchdemap(z_out)
%没有考虑n_PRB,不计算m (P20),数据直接映射为一个完整的子帧进行处理
global pucch_type;
global N_UL_RB;
global N_RB_sc;
global n_1_PUCCH;
global n_2_PUCCH;
global n_1_PUCCH_SR;
global PUCCHN_1_cs;
global Delta_PUCCH_shift;
global N_2_RB;
global SR_positive;
demapdata0 = zeros(N_RB_sc,14);
demapdata1 = zeros(N_RB_sc,14);
if pucch_type <3
    % 对SR资源解映射
    if n_1_PUCCH_SR < (3*PUCCHN_1_cs/Delta_PUCCH_shift)
        PUCCH_m = N_2_RB;
    else
        PUCCH_m = floor((n_1_PUCCH_SR -(3*PUCCHN_1_cs/Delta_PUCCH_shift))/(3*N_RB_sc/Delta_PUCCH_shift))+N_2_RB+ceil(PUCCHN_1_cs/8);
    end
    if mod(PUCCH_m,2)==0
        PUCCH_prb1 = floor(PUCCH_m/2);
        PUCCH_prb2 = N_UL_RB-1-floor(PUCCH_m/2);
        demapdata0(:,1:7) = z_out(PUCCH_prb1*12+1 : (PUCCH_prb1+1)*12,1:7);
        demapdata0(:,8:14) = z_out(PUCCH_prb2*12+1 : (PUCCH_prb2+1)*12,8:14);
    else
        PUCCH_prb1 = N_UL_RB-1-floor(PUCCH_m/2);
        PUCCH_prb2 = floor(PUCCH_m/2);
        demapdata0(:,1:7) = z_out(PUCCH_prb1*12+1 : (PUCCH_prb1+1)*12,1:7);
        demapdata0(:,8:14) = z_out(PUCCH_prb2*12+1 : (PUCCH_prb2+1)*12,8:14);
    end
    % 对ACK/NACK资源解映射
    if n_1_PUCCH < (3*PUCCHN_1_cs/Delta_PUCCH_shift)
        PUCCH_m = N_2_RB;
    else
        PUCCH_m = floor((n_1_PUCCH -(3*PUCCHN_1_cs/Delta_PUCCH_shift))/(3*N_RB_sc/Delta_PUCCH_shift))+N_2_RB+ceil(PUCCHN_1_cs/8);
    end
    if mod(PUCCH_m,2)==0
        PUCCH_prb1 = floor(PUCCH_m/2);
        PUCCH_prb2 = N_UL_RB-1-floor(PUCCH_m/2);
        demapdata1(:,1:7) = z_out(PUCCH_prb1*12+1 : (PUCCH_prb1+1)*12,1:7);
        demapdata1(:,8:14) = z_out(PUCCH_prb2*12+1 : (PUCCH_prb2+1)*12,8:14);
    else
        PUCCH_prb1 = N_UL_RB-1-floor(PUCCH_m/2);
        PUCCH_prb2 = floor(PUCCH_m/2);
        demapdata1(:,1:7) = z_out(PUCCH_prb1*12+1 : (PUCCH_prb1+1)*12,1:7);
        demapdata1(:,8:14) = z_out(PUCCH_prb2*12+1 : (PUCCH_prb2+1)*12,8:14);
    end
else
    % 对format 2/2a/2b资源解映射
    PUCCH_m = floor(n_2_PUCCH/N_RB_sc);
    if mod(PUCCH_m,2)==0
        PUCCH_prb1 = floor(PUCCH_m/2);
        PUCCH_prb2 = N_UL_RB-1-floor(PUCCH_m/2);
        demapdata1(:,1:7) = z_out(PUCCH_prb1*12+1 : (PUCCH_prb1+1)*12,1:7);
        demapdata1(:,8:14) = z_out(PUCCH_prb2*12+1 : (PUCCH_prb2+1)*12,8:14);
    else
        PUCCH_prb1 = N_UL_RB-1-floor(PUCCH_m/2);
        PUCCH_prb2 = floor(PUCCH_m/2);
        demapdata1(:,1:7) = z_out(PUCCH_prb1*12+1 : (PUCCH_prb1+1)*12,1:7);
        demapdata1(:,8:14) = z_out(PUCCH_prb2*12+1 : (PUCCH_prb2+1)*12,8:14);
    end
end
meas_pow=sum(sum(abs(demapdata0(:,1:7))));
if meas_pow > 12*7*0.8        % 7个符号总功率门限
    Rx_SR = 1;                % 有SR请求
else
    Rx_SR = 0;                % 无SR请求
end
%=======================================================
