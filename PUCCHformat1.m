function z=PUCCHformat1(input_b,N_cell_ID,n_RNTI,subframe_N,pucch_tpye,ackNackSRS_SimuTran)
%生成PUCCH格式1，1a,1b,符号Z
global SYMBOL_L_SEQ;
global CPflag;
global Delta_PUCCH_shift;
global n_1_PUCCH;
global PUCCHN_1_cs;
global N_RB_sc;
global input_b;
%global N_cell_ID;
%global n_RNTI;
 input_b_len=length(input_b);
% c = pseudo(input_b_len,n_RNTI,N_cell_ID,n_s); % Pseudo-random sequences c(i) generation
% 
% for i=1:input_b_len
%     input_b1(i)=mod((input_b(i)+c(i)),2); % scrambling b(i),resulting in a block of scrambled bits b1(0),...b1(numbits-1)
% end 
if pucch_tpye ~= 0                %如果不属于格式1
    input_d = mod_pucch(input_b,pucch_tpye);   %PUCCH特殊的调制
else                              %如果属于格式1,则设input_d值为1
    input_d = 1;
end


N_RB_sc = 12;
N_PUCCH_seq = 12;



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
    for i=1:N_PUCCH_SF
        l=SYMBOL_L_SEQ(CPflag+1,i);
        
        TxPUCCHn_cell_cs=TxPUCCHCaln_cell_cs(n_s,l,CPflag,N_cell_ID);
        
        PUCCHAlpha1=PUCCHGenAlpha1(TxPUCCHn_cell_cs,PUCCHn_oc,PUCCHn_1,n_s,...
                                   CPflag,Delta_PUCCH_shift,PUCCHN_1,l,...
                                   N_RB_sc);
        
        if mod(PUCCHn_1(n_s+1),2)==0
          S=1;
        else
          S = 1j;
        end
        
        
        %alpha = 2 * pi * 2/12;
        
        M_RS_sc = N_RB_sc;
        r_alpha_u_v = rsgenforPUCCH(PUCCHAlpha1,u,M_RS_sc) ;  %生成r_alpha_u_v序列
        
        for n = 1 : N_PUCCH_seq
            %生成y序列
            y(n) = input_d * r_alpha_u_v(n) ;
            %生成Z序列
            z_index = (j-1) * 4 * N_PUCCH_seq + (i-1) * N_PUCCH_seq + n - 1;  %序号
            temp = y(n) * S * w_n_oc(PUCCHn_oc+1 ,i);       %元素值
            z(z_index + 1) = temp;
        end
    end
end

