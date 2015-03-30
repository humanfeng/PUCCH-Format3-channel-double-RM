function output = basesignalgen(input)
global N_UL_RB
Ts = 1 / ( 15000 * 2048 ) ; % basic time unit ；
NRBSC = 12; % subcarriers in a resource block ；
dealtf = 15000; % subcarrier spacing 
N = 2048 ; % a constant different with subcarrier spacing ；
% N_RB_UL=25;    
% insert 0 in the middle of all subcarribers for ifft ;????/?
%[r,s]=size(input);
%NRBDL=r/12;
%for l=1:s

    %input((NRBDL*NRBSC/2+2):(NRBDL*NRBSC+1),l)=input((NRBDL*NRBSC/2+1):NRBDL*NRBSC,l);
    %input(NRBDL*NRBSC/2+1,l)=0;
%end
%for n = 1 : N ;
   % e ( n ) = exp( j * 2 * pi / N * ( - floor( NRBDL * NRBSC / 2 ) ) * ( n - 1 ) );%下行
%end
%e=[e;e;e;e;e;e;e;e;e;e;e;e;e;e];
%e=e.';
%output=N*e.*ifft(input,N);
for ii = 1:2048;
   table(ii) = exp(j * 2 * pi /N* (1/2 - floor(12 * N_UL_RB / 2)) * (ii'-1));%上行基带信号生成
end
table=[table;table;table;table;table;table;table;table;table;table;table;table;table;table];
table=table.';
output = N*table.* ifft(input,N);
%====================================================================