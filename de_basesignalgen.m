 function deSc_Fdma = de_basesignalgen(Sc_Fdma_rec)
% function out_dft = de_basesignalgen(in_dft_1);
global N_RB_sc;
global N_UL_RB;
global in_dft_1;
Ts = 1 / ( 15000 * 2048 ) ; % basic time unit ��
dealtf = 15000; % subcarrier spacing 
N = 2048 ; % a constant different with subcarrier spacing ��

for ii = 1:N;
   table(ii) = exp(-j * 2 * pi/N * (1/2 - floor(12 * N_UL_RB / 2)) * (ii'-1));
end

table=[table;table;table;table;table;table;table;table;table;table;table;table;table;table];
table=table.';

input=table.*Sc_Fdma_rec;
deSc_Fdma = fft(input,N)/N;
deSc_Fdma(N_RB_sc*N_UL_RB+1:N,:) = [];
% Ts = 1 / ( 15000 * 300);
% dealtf = 15000; 
% N=300;
%  for ii = 1:N;
%   table(ii)= exp(-j * 2 * pi/N * (1/2 - floor(12 * 25 / 2)) * (ii-1));
%  end
% table=table.';
%  input=table.*in_dft_1;
%  out_dft=fft(input,N)/N;

