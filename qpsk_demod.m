function dshou= qpsk_demod(dsymbsh);  % qpsk demodulation

len= length(dsymbsh);

for n=1:len
    %�жϵ�һ������
    if real(dsymbsh(n))>0
     a(n)=0;
    else
     a(n)=1;
    end
    %�жϵڶ�������
    if real(dsymbsh(n))>0
     b(n)=0;
    else
     b(n)=1;
    end
end

g=[a;b];

dshou=reshape(g,1,2*len);




   
        
        