function dshou= qpsk_demod(dsymbsh);  % qpsk demodulation

len= length(dsymbsh);

%   m= 1 /sqrt(2);
% for n = 1:len
%     a(n)= -4 * real(dsymbsh(n))* m;
%     b(n)= -4 * imag(dsymbsh(n))* m;
%     
% end
% g=[a;b];
% dshou=reshape(g,1,2*len);

for n=1:len
    %判断第一个比特
    if real(dsymbsh(n))>0
     a(n)=0;
    else
     a(n)=1;
    end
    %判断第二个比特
    if imag(dsymbsh(n))>0
     b(n)=0;
    else
     b(n)=1;
    end
end

g=[a;b];

dshou=reshape(g,1,2*len);




   
        
        