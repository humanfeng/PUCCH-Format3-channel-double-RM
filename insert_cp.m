function Sc_Fdma_cpout = insert_cp(Sc_Fdma_reshape)
global CPflag;
%普通CP,l=0时,CP=160;1=<l<=6时,CP=144
T_CP = 0;
Sc_Fdma_cpout = [];
if CPflag == 0%普通CP,160 for l=0,144 for l=1,2,...,6
   N = 14;L = 7;
  for l = 1:N
   if mod(l,L) == 1
      T_CP = 160;
     Sc_Fdma_cpout = [Sc_Fdma_cpout,Sc_Fdma_reshape(2048*l-T_CP+1 : 2048*l)];
     Sc_Fdma_cpout = [Sc_Fdma_cpout,Sc_Fdma_reshape(2048*(l-1)+1 : 2048*l)];
  else
      T_CP = 144;
     Sc_Fdma_cpout = [Sc_Fdma_cpout,Sc_Fdma_reshape(2048*l-T_CP+1 : 2048*l)];
     Sc_Fdma_cpout = [Sc_Fdma_cpout,Sc_Fdma_reshape(2048*(l-1)+1 : 2048*l)];
  end    
  end
else %扩展CP,512 for l=0,1,...,5
    N = 12;
    for l = 1:N
      T_CP = 512;
     Sc_Fdma_cpout = [Sc_Fdma_cpout,Sc_Fdma_reshape(2048*l-T_CP+1 : 2048*l)];
     Sc_Fdma_cpout = [Sc_Fdma_cpout,Sc_Fdma_reshape(2048*(l-1)+1 : 2048*l)];
    end 
end
%==========================================================================