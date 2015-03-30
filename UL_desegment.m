%**************************************************************************
%Copyright (C), 2012, CQUPT
%FileName:     TxSegmentation
%Description:  Calculation of relevant parameters
%Author:       DSP_GROUP
%Input:        CRCoutdata: the length of data
%Output:       1.C:the number of blocks 
%              2.C_plus:the number of big blocks
%              3.C_sub:the number of small blocks
%              4.K_sub:the number of bits for big blocks
%              5.K_plus:the number of bits for small blocks
%              6.F:the number of NULL
%History:
%      <time>      <version >
%      2012/5/15      1.0
%**************************************************************************
function [C C_plus C_sub K_sub K_plus F] = UL_desegment(CRCoutdata)

B = (CRCoutdata);
Z = 6144;   
% 交织表中K的值，按列存放
K = [40,48,56,64,72,80,88,96,104,112,120,128,136,144,152,160,168,176,184,192,200,208,216,224,232,240,248,256,264,272,280,288,296,304,312,320,328,336,344,352,360,368,376,384,392,400,408,416,424,432,440,448,456,464,472,480,488,496,504,512,528,544,560,576,592,608,624,640,656,672,688,704,720,736,752,768,784,800,816,832,848,864,880,896,912,928,944,960,976,992,1008,1024,1056,1088,1120,1152,1184,1216,1248,1280,1312,1344,1376,1408,1440,1472,1504,1536,1568,1600,1632,1664,1696,1728,1760,1792,1824,1856,1888,1920,1952,1984,2016,2048,2112,2176,2240,2304,2368,2432,2496,2560,2624,2688,2752,2816,2880,2944,3008,3072,3136,3200,3264,3328,3392,3456,3520,3584,3648,3712,3776,3840,3904,3968,4032,4096,4160,4224,4288,4352,4416,4480,4544,4608,4672,4736,4800,4864,4928,4992,5056,5120,5184,5248,5312,5376,5440,5504,5568,5632,5696,5760,5824,5888,5952,6016,6080,6144];

% Total number of code blocks C is determined 
if B <= Z
    L=0;
    C=1;
    B1 = B;
else
    L=24;
    C=ceil(B/(Z-L));                         % 向上取整
    B1 = B+C*L;
end

% 确定C_sub、C_plus的值，K_plus、K_sub的值以及在交织表中的位置
if C>0
    for i = 1:188                             % 交织表中总共有188个元素
        if K(i) >= (B1/C)                     % 确定K_plus的值
           K_plus = K(i);
           a = i;                             % 确定K_plus在交织表中的位置，K_sub的在交织表中的位置是K_plus的前一个
           break;
        end
    end
    
    if C == 1                                 % C==1时    
       C_plus = 1;
       K_sub = 0;
       C_sub = 0;
       
    elseif C>1                                % C>1时
        K_sub = K(a-1);                       % 确定K_sub的值
        K_offset = K_plus - K_sub;            % 确定K_offset的值
        C_sub = floor((C*K_plus-B1)/K_offset);  % 确定C_sub的值
        C_plus = C - C_sub;                   % 确定C_plus的值
    end
end

% 确定填充比特的个数F
F = C_plus*K_plus + C_sub*K_sub - B1;
