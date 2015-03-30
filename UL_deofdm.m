%**************************************************************************
%Copyright (C), 2012, CQUPT
%FileName:     de_basesignalgen
%Description:  OFDM demoded
%Author:       DSP_GROUP
%Input:        Sc_rec: data after cutting CP
%Output:       defdma: data after OFDM　demoded
%History:         
%      <time>      <version >    
%      2012/5/15      1.0     
%**************************************************************************
function defdma = UL_deofdm(Sc_rec)
%--------------------------------------------
global N_RB_sc;
global N_UL_RB;
Ts = 1 / ( 15000 * 2048 ) ; % 基本时间单元 ；
dealtf = 15000;             % 子载波间隔 
N = 2048 ;                  % a constant different with subcarrier spacing ；

L=7;
[R,S]=size(Sc_rec);%2048*14
e=zeros(1,2048);
% OFDM调制时的载波旋转因子
for n = 1 : N 
        e ( n ) = exp(-1i * 2 * pi / N * (1/2 - floor(N_RB_sc * N_UL_RB / 2)) * (n-1));
end
e=[e;e;e;e;e;e;e;e;e;e;e;e;e;e];
e=e.';


input=e.*Sc_rec;
defdma = fft(input,N)/N;
defdma=defdma(1:N_RB_sc * N_UL_RB,:);