function out_cutpilot=deSc_Fdma_cutpilot(deSc_Fdma,pilot_interofdm,pilot_intersubc)
[M,N]=size(deSc_Fdma);
for j=2:pilot_interofdm+1:N
    for i=1:M
        deSc_Fdma(i,j)=0;
    end
end
for j=6:pilot_interofdm+1:N
    for i=1:M  
       deSc_Fdma(i,j)=0;
    end
end
out_cutpilot=deSc_Fdma;
        