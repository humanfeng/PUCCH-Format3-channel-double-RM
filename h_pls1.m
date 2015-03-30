%**************************************************************************
%Copyright (C), 2012, CQUPT
%FileName:     h_pls
%Description:  channel estimation for PUCCH
%Author:       DSP_GROUP
%Input:        1.descfdma: data after OFDM demoded
%              2.pilot_sequence: local reference signal
%Output:       1.H_pls: channel estimation of reference signal
%              2.re_data: received data except RS
%History:         
%      <time>      <version >    
%      2012/5/15      1.0     
%**************************************************************************
function  [H_pls,re_data] = h_pls1(descfdma,pilot_sequence,pucch_type)
% global pucch_type;
global CPflag;
global ackNackSRS_SimuTran;

% symbol_sourse1(8*12+1 : 9*12,1:7) = symbol_sourse(:,1:7);
% symbol_sourse1(6*12+1 : 7*12,8:14) = symbol_sourse(:,8:14);
re_pilotseq = zeros(12,4);        %接收端导频提取
% symbol_sourse1(8*12+1 : 9*12,1:7) = symbol_sourse(:,1:7);
% symbol_sourse1(6*12+1 : 7*12,8:14) = symbol_sourse(:,8:14);
if pucch_type < 3                   %格式1/1a/1b插入导频
    if CPflag==0                      %普通CP
        L = 7;
        dmrsnum=3;                  %每时隙中DMRS占用的符号数目
        index = [2 3 4];  %每时隙中DMRS所在的符号下标
            re_data(:,1:L) =  descfdma(8*12+1 : 9*12,1:L); 
            if ackNackSRS_SimuTran == 0
            re_data(:,L+1:2*L) =  descfdma(6*12+1 : 7*12,L+1:2*L); 
            elseif ackNackSRS_SimuTran ==1
            re_data(:,L+1:2*L-1) =  descfdma(6*12+1 : 7*12,L+1:2*L-1);  
            end
            for i=1:dmrsnum
            re_pilotseq(:,i) = descfdma(8*12+1 : 9*12,index(i)+1);
            re_pilotseq(:,i+dmrsnum) = descfdma(6*12+1 : 7*12,index(i)+1+L);
            end
     elseif CPflag==1                   %扩展CP
        dmrsnum=2;
         L = 6;
         index = [2 3];
         re_data(:,1:L) =  descfdma(8*12+1 : 9*12,1:L);  
         if ackNackSRS_SimuTran == 0
         re_data(:,L+1:2*L) =  descfdma(6*12+1 : 7*12,L+1:2*L); 
         elseif ackNackSRS_SimuTran ==1
         re_data(:,L+1:2*L-1) =  descfdma(6*12+1 : 7*12,L+1:2*L-1);
         end
            for i=1:dmrsnum
            re_pilotseq(:,i) = descfdma(8*12+1 : 9*12,index(i)+1);
            re_pilotseq(:,i+dmrsnum) = descfdma(6*12+1 : 7*12,index(i)+1+L);
           end
    end
else                                   %格式2/2a/2b插入导频
      if CPflag==0
        dmrsnum=2;                  %每时隙中DMRS占用的符号数目
         L = 7;
        index = [1 5];  %每时隙中DMRS所在的符号下标
            re_data(:,1:L) =  descfdma(8*12+1 : 9*12,1:L);  
            re_data(:,L+1:2*L) =  descfdma(6*12+1 : 7*12,L+1:2*L);  
            for i = 1:dmrsnum
          re_pilotseq(:,i) = descfdma(8*12+1 : 9*12,index(i)+1);
          re_pilotseq(:,i+dmrsnum) = descfdma(6*12+1 : 7*12,index(i)+1+L);
            end
      elseif CPflag == 1
        dmrsnum = 1;
        L = 6;
         index = [3];
            re_data(:,1:L) =  descfdma(8*12+1 : 9*12,1:L);  
            re_data(:,L+1:2*L) =  descfdma(6*12+1 : 7*12,L+1:2*L);           
            for i = 1:dmrsnum
           re_pilotseq(:,i) = descfdma(8*12+1 : 9*12,index(i)+1);
           re_pilotseq(:,i+dmrsnum) = descfdma(6*12+1 : 7*12,index(i)+1+L);
            end
      end
end
H_pls = re_pilotseq ./ pilot_sequence;
%==========================OK================================
