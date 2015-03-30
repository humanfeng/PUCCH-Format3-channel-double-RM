%**************************************************************************
%Copyright (C), 2012, CQUPT
%FileName:     cut_cp
%Description:  cut cyclic prefix (CP) of received data
%Author:       DSP_GROUP
%Input:        sym_addnoise: received baseband data of 1 subframe
%Output:       sc_fdma_cutcp: data after cutting CP
%History:         
%      <time>      <version >    
%      2012/5/15      1.0     
%**************************************************************************
function  sc_fdma_cutcp = UL_cutcp(sym_addnoise)
global CPflag;
M = size(sym_addnoise,2);
if CPflag == 0      %  ����CP
    L = 7;N = 14;
end
%2��ʱ϶���
sym_addnoise1(1,:) = sym_addnoise(1:M/2);
sym_addnoise1(2,:) = sym_addnoise(M/2+1:M);
k=0;
sc_fdma_cutcp = [];
for n=1:2
    sc_fdma_cutcp1 = [];
    sc_fdma_cutcp1 = sym_addnoise1(n,161:2048+160);         %��1������                      
    for l = 2:L                                             %��2-7������ 
        sc_fdma_cutcp1 = [sc_fdma_cutcp1 sym_addnoise1(n,144+1+(2048+160)+(2048+144)*(l-2):(2048+160)+(2048+144)*(l-1))];
    end
    sc_fdma_cutcp = [sc_fdma_cutcp  sc_fdma_cutcp1];
end
sc_fdma_cutcp = reshape(sc_fdma_cutcp,2048,2*L);            %����ת��
%==========================================================================
