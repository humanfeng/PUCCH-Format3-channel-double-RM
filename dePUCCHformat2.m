function Rxinput_b=dePUCCHformat2(z,N_cell_ID,n_RNTI,subframe_N)
%生成PUCCH格式2，2a,2b,符号Z
global SYMBOL_L_SEQ_2;
global CPflag;
global Delta_PUCCH_shift;
global n_1_PUCCH;
global PUCCHN_1_cs;
global N_RB_sc;
global n_2_PUCCH;
global N_2_RB;
global PUCCHn_1;
global subframe_N;
N_PUCCH_seq = 12;
%z_len=length(z);
i=0;
j=0;
k=0;
Rxinput_d = zeros(1,10);
for j=1:2
    n_s = subframe_N*2 + j-1;
    if j==1
         u=25;
      else
         u=0;
      end
    for k=1:5
        l=SYMBOL_L_SEQ_2(CPflag+1,k);
        TxPUCCHn_cell_cs=TxPUCCHCaln_cell_cs(n_s,l,CPflag,N_cell_ID);
        PUCCHAlpha2=PUCCHGenAlpha2(n_2_PUCCH,n_s,N_RB_sc,N_2_RB,PUCCHN_1_cs,TxPUCCHn_cell_cs,l);
        %alpha = 2 * pi * 2/12;
        M_RS_sc = N_RB_sc;
        r_alpha_u_v = rsgenforPUCCH(PUCCHAlpha2,u,M_RS_sc) ;  %生成r_alpha_u_v序列
        r_alpha_u_v_conj = conj(r_alpha_u_v);             %求共轭
        %解Z序列，由Z序列得出d(n)
        n=5*(j-1)+k;
        for i = 1 : N_RB_sc         %corrcoef
            z_index = N_PUCCH_seq * ( n - 1) + (i - 1);  %序号 
            temp = z(z_index + 1) * r_alpha_u_v_conj(i); %/abs(r_alpha_u_v(i))即模为1
            Rxinput_d(n) = Rxinput_d(n) + temp;
        end
        Rxinput_d(n) = Rxinput_d(n)/N_RB_sc; 
    end
end
    %解调制
    
    Rxinput_b1 = qpsk_demod(Rxinput_d); 
    

    Rxinput_b1_len = length(Rxinput_b1);            %求长度
    RandomSeqCinite = (floor(n_s / 2) + 1) * (2 * N_cell_ID + 1) * 2^16 + n_RNTI;
    c = GenRandomSeq(Rxinput_b1_len, RandomSeqCinite);

    for i=1:Rxinput_b1_len
        
            Rxinput_rm_b(i)=mod((Rxinput_b1(i)+c(i)),2);
        
    end
    
  Rxinput_rm_b = 1 - 2*Rxinput_rm_b;            %RM译码需要双极性化
  Rxinput_b = FHTrmdecode(Rxinput_rm_b);  % RM译码
