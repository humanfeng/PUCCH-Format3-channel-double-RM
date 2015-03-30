function Z=PUCCHDMRSformat3(N_cell_ID,n_RNTI,subframe_N)

global CPflag;
global Delta_PUCCH_shift;
global n_1_PUCCH;
global PUCCHN_1_cs;
global N_RB_sc;
global input_d_10;
global n_2_PUCCH;
global N_2_RB;
global PUCCHn_1;
        
     N_RB_sc = 12;
     N_PUCCH_seq = 12;
     M_RS_sc = N_RB_sc;

%format3
   if (CPflag==0)
	     w_1=[1 1];
         N_PUCCH_RS=2;
         l=[1 5];
   else
        w_1=[1];
        N_PUCCH_RS=1;
        l=3;
   end
    
     for  j=1:2
        n_s = subframe_N*2 + j-1;       
         if j==1
           u=25;
         else
           u=0;
         end
	     for m=1:N_PUCCH_RS
               z=1;            
              %计算TxPUCCHn_cell_cs;
            TxPUCCHn_cell_cs=TxPUCCHCaln_cell_cs(n_s,l(m),CPflag,N_cell_ID);
            PUCCHAlpha2=PUCCHGenAlpha2(n_2_PUCCH,n_s,N_RB_sc,N_2_RB,PUCCHN_1_cs,TxPUCCHn_cell_cs,l(m));
                 
            M_RS_sc = N_RB_sc;
            r_alpha_u_v = rsgenforPUCCH(PUCCHAlpha2,u,M_RS_sc) ;  %生成r_alpha_u_v序列

              for n = 1 : N_PUCCH_seq
                %生成Z序列
                z_index = (j-1) * N_PUCCH_RS * M_RS_sc + (m-1) * N_PUCCH_seq + n - 1;  %序号
                temp = w_1(m) * z * r_alpha_u_v(n);       %元素值
                Z(z_index + 1) = temp;
              end
         end
     end
end


