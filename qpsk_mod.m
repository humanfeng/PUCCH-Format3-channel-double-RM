 function d = qpsk_mod(b1,numbits)  % qpsk modulation
% 
% pairs of bits,b(i),b(i+1)are mapped to complex-valued modulation symbols d_symb=Re+j*Im 
% modulation scheme:   b(i) b(i+1)|     Re     |   Im
%                       0     0   | 1/sqrt(2)  |   1/sqrt(2)
%                       0     1   | 1/sqrt(2)  |  -1/sqrt(2)
%                       1     0   | -1/sqrt(2) |   1/sqrt(2)
%                       1     1   | -1/sqrt(2) |  -1/sqrt(2)

for n = 1:2:numbits     
switch b1(n)
   case 0
   Re(n) = 1/sqrt(2); 
   case 1
   Re(n) = -1/sqrt(2);
end
switch b1(n + 1)
    case 0
    Im(n) = 1/sqrt(2);
    case 1
    Im(n) = -1/sqrt(2);
end
%Re(n)= if1or0 (b1(n));
%Im(n)= if1or0 (b1(n + 1));
d(floor(n / 2) + 1) = Re(n) + j * Im(n);
end


 
    