function c = GenRandomSeq(numbits,c_init)

% Pseudo-random sequences c(i) generation for PUCCH,which is defined by
%                   c(n)=(x1(n+Nc)+x2(n+Nc))mod2, where Nc=1600
%                   x1(n+31)=(x1(n+3)+x1(n))mod2,shall be initialized with x1(0)=1,x1(n)=0,n=1,2,...,30; 
%                   x2(n+31)=(x1(n+3)+x1(n))mod2,shall be initialized with c_init=(floor(n_s/2)+1)*(2*N_cell_ID+1)*2^16 + n_RNTI;
%                   set N_id=2;                                     
Nc = 1600;

x11 =1;       % --------------------
               % sequence x1 initializition
     % x1(0)=1,x1(n)=0,n=1,2,...,30;
x12 = zeros(1,30); 
x1 = [x11 x12];
           %----------------------

for i = 1:(Nc + numbits - 31)                   % generate sequence x1
    x1(i + 31) = mod((x1(i + 3) + x1(i)),2);
end


%x21 = dec2bin(c_init,31);      % ------------------------
x2=de2bi (c_init,31);
%x22 = zeros(1,31-N_id);                           % sequence x2 initializition
%x2 = [x21 x22];                          % x2(1)=0,x2(2)=1;x2(n)=0,n=3,...,31;
          
       %---------------------------

for i = 1:(Nc + numbits - 31)                  % generate sequence x2
    x2(i + 31) = mod((x2(i + 3) + x2(i + 2) + x2(i + 1) + x2(i)),2);
end


for i = 1:numbits                           % generate Pseudo-random sequences c(i)
    c(i) = mod((x1(i + Nc) + x2(i + Nc)),2);
end