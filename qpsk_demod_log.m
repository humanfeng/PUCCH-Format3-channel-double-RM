function dshou= qpsk_demod_log(num_antenna,dsymbsh);  % qpsk demodulation

len= length(dsymbsh);

if num_antenna == 1
    m= 1 /sqrt(2);
else
    m=1 / 2;
end

for n = 1:len
    a(n)= -4 * real(dsymbsh(n))* m;
    b(n)= -4 * imag(dsymbsh(n))* m;
    
end
g=[a;b];
dshou=reshape(g,1,2*len);




   
        
        