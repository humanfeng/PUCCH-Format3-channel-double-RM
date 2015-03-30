function Rxinput_b = dePUCCHformat1(z,N_cell_ID,n_RNTI,subframe_N,pucch_tpye)
%生成PUCCH格式1，1a,1b,符号Z
%z_len=length(z);
global SYMBOL_L_SEQ;
global CPflag;
global n_1_PUCCH;
global PUCCHN_1_cs;
global Delta_PUCCH_shift;
global N_RB_sc;
global ackNackSRS_SimuTran;
N_PUCCH_seq = 12;
% S = 1;
% w_n_oc = [1 1 1 1];
% S_conj = conj(S);                %求共轭
% w_n_oc_conj = conj(w_n_oc);      %求共轭
%Rxinput_y = zeros(1,N_PUCCH_seq);   %初始化y(n)

num_symbol=0;
for j=1:2
     % 求N_PUCCH_SF
      if( j==2 & ackNackSRS_SimuTran == 1)
          N_PUCCH_SF = 3;
      else 
          N_PUCCH_SF = 4;
      end
      
      % 根据N_PUCCH_SF求 w_n_oc
      if N_PUCCH_SF == 4
       w_n_oc = [1 1 1 1 ;1 -1 1 -1 ;1 -1 -1 1;];
      else
       w_n_oc =[1 1 1;1 exp(1j*2*pi / 3) exp(1j*4*pi / 3);1  exp(1j*4*pi / 3)  exp(1j*2*pi / 3) ];
      end
      
      %选择每个时隙对应的U值
      if j==1
        u=25;
      else
        u=0;
      end
          n_s = subframe_N*2 + j-1;
          [PUCCHN_1 PUCCHn_oc PUCCHn_1]=PUCCHParaCalculate(n_s,PUCCHN_1_cs,CPflag,Delta_PUCCH_shift,...
                                                     n_1_PUCCH,N_RB_sc);
 
       if mod(PUCCHn_1(n_s+1),2)==0
          S=1;
        else
          S = 1j;
        end
        
    for i=1:N_PUCCH_SF
        l=SYMBOL_L_SEQ(CPflag+1,i);
        TxPUCCHn_cell_cs=TxPUCCHCaln_cell_cs(n_s,l,CPflag,N_cell_ID);
        PUCCHAlpha1=PUCCHGenAlpha1(TxPUCCHn_cell_cs,PUCCHn_oc,PUCCHn_1,n_s,CPflag,...
                                   Delta_PUCCH_shift,PUCCHN_1,l,...
                                   N_RB_sc);
        Rxinput_y=0;
        Rxinput_d_sum=0;
        
        %alpha = 2 * pi * 2/12;
%         u = 11;    
        M_RS_sc = N_RB_sc;
        
        r_alpha_u_v = rsgenforPUCCH(PUCCHAlpha1,u,M_RS_sc) ;  %生成r_alpha_u_v序列
        r_alpha_u_v_conj = conj(r_alpha_u_v);             %求共轭

        %解Z序列，由Z序列得出y(n)
        S_conj = conj(S);                %求共轭
        w_n_oc_conj = conj(w_n_oc);      %求共轭
        for n = 1 : N_PUCCH_seq
            z_index = (j-1) * 4 * N_PUCCH_seq + (i-1) * N_PUCCH_seq + n - 1;  %序号
            Rxinput_y = z(z_index + 1) * S_conj * w_n_oc_conj(PUCCHn_oc+1,i);       %y = z/(s*w)=z*conj(s)*conj(w)
            temp = Rxinput_y * r_alpha_u_v_conj(n);
            Rxinput_d_sum = Rxinput_d_sum + temp;
        end
        num_symbol=num_symbol+1;
        RxPUCCHd1(4*(j-1)+i)=Rxinput_d_sum/N_PUCCH_seq;
    end
    
end
d_sum=0;
for i=1:num_symbol
    d_sum = d_sum+RxPUCCHd1(i);
end
RxPUCCHd=d_sum/num_symbol;

%解调制
Rxinput_b = demod_pucch(RxPUCCHd,pucch_tpye);


