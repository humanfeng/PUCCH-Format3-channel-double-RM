function  sc_fdma_cutcp = cut_cp(sym_addnoise)
global CPflag;
M = size(sym_addnoise,2);%列数，30720列
if CPflag == 0
    L = 7;N = 14;
end
sym_addnoise1(1,:) = sym_addnoise(1:M/2);
sym_addnoise1(2,:) = sym_addnoise(M/2+1:M);%2个时隙
[M1,N1] = size(sym_addnoise1);%sym_addnoise1是2*15360
k=0;
sc_fdma_cutcp = [];
for n=1:M1
        sc_fdma_cutcp1 = [];     
        sc_fdma_cutcp1 = sym_addnoise1(n,161:2048+160);
        for l = 2:L    
        sc_fdma_cutcp1 = [sc_fdma_cutcp1 sym_addnoise1(n,144+1+(2048+160)+(2048+144)*(l-2):(2048+160)+(2048+144)*(l-1))];       
        end
         sc_fdma_cutcp = [sc_fdma_cutcp  sc_fdma_cutcp1];
end
%==========================================================================
