function  H11 = h_plmmse(descfdma,pilot_sequence,H_pls11,SNR_dB,t_max,trms,fd)
[M,N] = size(descfdma);  
[Q,R]=size(H_pls11);    
T=size(pilot_sequence,1);
beta=1;%QPSK调制
SNR=10^(SNR_dB/10);

for m = 1:T
    for n = 1:T       
        Rhh(m,n)=(1-exp((-1)*t_max*((1/trms)+j*2*pi*(m-n)/T)))./(trms*(1-exp((-1)*t_max/trms))*((1/trms)+j*2*pi*(m-n)/T));    
    end
end
ff=Rhh*inv(Rhh+(beta/SNR)*eye(Q));
for n=1:R    
     H11(:,n)=ff*H_pls11(:,n);  
end
%---------------------------------------
%以上是频域维纳滤波，以下是时域维纳滤波
ts = (1/30.72)*10^(-6);  %采样周期(1/30.72)*10^(-6)
sigma2 = beta/SNR;

    for p = 1:R
        for q = 1:R
            Rpp(p,q) = besselj(0,2*pi*fd*abs(p-q)*ts);%零阶贝赛尔函数
        end
    end
    Rpp1 = Rpp+sigma2*eye(R);
   for m = 1:Q
        H11(m,1:R) = (Rpp*inv(Rpp1)*H11(m,:).').';
   end
%==========================end of file=============================