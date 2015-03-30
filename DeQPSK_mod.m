function Rx_b = DeQPSK_mod(Rx_d)

for i = 1:length(Rx_d)
    if real(Rx_d(i))>0 & imag(Rx_d(i))>0   %进行解调
        Rx_b(2*i-1) = 0; 
        Rx_b(2*i) = 0;
    elseif real(Rx_d(i))>0 & imag(Rx_d(i))<0
        Rx_b(2*i-1)=0; 
        Rx_b(2*i)=1;
    elseif real(Rx_d(i))<0 & imag(Rx_d(i))>0
        Rx_b(2*i-1)=1; 
        Rx_b(2*i)=0; 
    else
        Rx_b(2*i-1)=1; 
        Rx_b(2*i)=1;
    end
end
