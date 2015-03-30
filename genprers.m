clc
clear;
N_RB_sc=12;
r2_alpha_u_v_quantizing{1}=0;
for PUCCHn_cs=0:11
    alpha=2 * pi * PUCCHn_cs/N_RB_sc;
    for n=1:12
        r2_alpha_u_v(PUCCHn_cs+1,n)=exp(j * alpha * (n - 1));
        r2_alpha_u_v_quantizing{PUCCHn_cs+1,2*n-1}=quantizing(real(r2_alpha_u_v(PUCCHn_cs+1,n)));
        r2_alpha_u_v_quantizing{PUCCHn_cs+1,2*n}= quantizing(imag(r2_alpha_u_v(PUCCHn_cs+1,n)));
    end
end
r2_alpha_u_v_quantizing