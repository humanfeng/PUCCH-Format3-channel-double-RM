function Z =PUCCHDMRSformat1(pucch_tpye,N_cell_ID,n_RNTI,subframe_N)

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

%format1/1a/1b
if(pucch_tpye==0 | pucch_tpye==1 | pucch_tpye==2)
   z=1;
   if (CPflag==0)
	     w_1=[1 1 1;1 exp(1j*2*pi/3) exp(1j*4*pi/3);1 exp(1j*4*pi/3) exp(1j*2*pi/3)];
         N_PUCCH_RS=3;
   else
        w_1=[1 1;1 -1;0 0];
        N_PUCCH_RS=2;
   end
 
     for  j=1:2
        n_s = subframe_N*2 + j-1;
       [PUCCHN_1 PUCCHn_oc PUCCHn_1] = PUCCHDMRSParaCalculate(n_s,PUCCHN_1_cs,CPflag,...
                                                                    Delta_PUCCH_shift,n_1_PUCCH,N_RB_sc);
         if j==1
           u=25;
         else
           u=0;
         end
	     for m=1:N_PUCCH_RS            
              l=m+1; 
              %计算TxPUCCHn_cell_cs;
              TxPUCCHn_cell_cs=TxPUCCHCaln_cell_cs(n_s,l,CPflag,N_cell_ID);
              PUCCHAlpha1=PUCCHDMRSGenAlpha1(TxPUCCHn_cell_cs,PUCCHn_oc,PUCCHn_1,n_s,...
                                   CPflag,Delta_PUCCH_shift,PUCCHN_1,l,N_RB_sc);
              r_alpha_u_v = rsgenforPUCCH(PUCCHAlpha1,u,M_RS_sc) ;  %生成r_alpha_u_v序列

              for n = 1 : N_PUCCH_seq
                %生成Z序列
                z_index = (j-1) * N_PUCCH_RS * M_RS_sc + (m-1) * N_PUCCH_seq + n - 1;  %序号
                temp = w_1(PUCCHn_oc+1,m) * z * r_alpha_u_v(n);       %元素值
                Z(z_index + 1) = temp;
              end
         end
     end
end
