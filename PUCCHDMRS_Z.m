function PUCCHDMRS_Z=PUCCHDMRS_Z(pucch_tpye,N_cell_ID,n_RNTI,subframe_N)

%format1/1a/1b
if(pucch_tpye==0|pucch_tpye==1|pucch_tpye==2)
   z=1;
   if (CPflag==0)
	     w_1=[1 1 1;1 exp(j2*pi/3) exp(j4*pi/3);1 exp(j4*pi/3) exp(j2*pi/3)];
         N_PUCCH_RS=3;
   else
        w_1=[1 1;1 -1;0 0];
        N_PUCCH_RS=2;
   end
         
     N_RB_sc = 12;
     N_PUCCH_seq = 12;
     M_RS_sc = 12;
     for  j=1:2
        n_s = subframe_N*2 + j-1;
       [PUCCHN_1 PUCCHn_oc PUCCHn_1]=PUCCHDMRSParaCalculate(n_s,PUCCHN_1_cs,CPflag,Delta_PUCCH_shift,...
                                                     n_1_PUCCH,N_RB_sc);
	     for m=1:N_PUCCH_RS

		  l=m+2; 
          %����TxPUCCHn_cell_cs;
		  TxPUCCHn_cell_cs=TxPUCCHCaln_cell_cs(n_s,l,CPflag,N_cell_ID);
          PUCCHAlpha1=PUCCHDMRSGenAlpha1(n_2_PUCCH,n_s,N_RB_sc,N_2_RB,PUCCHN_1_cs,TxPUCCHn_cell_cs,l);
          
          u = 25;    
          M_RS_sc = N_RB_sc;
          r_alpha_u_v = rsgenforPUCCH(PUCCHAlpha1,u,M_RS_sc) ;  %����r_alpha_u_v����
          
          for n = 1 : N_PUCCH_seq
            %����Z����
            z_index = (j-1) * N_PUCCH_RS * M_RS_sc + (i-1) * N_PUCCH_seq + n - 1;  %���
            temp = w_1(PUCCHn_oc+1,m)*z*r_alpha_u_v(n);       %Ԫ��ֵ
            PUCCHDMRS_Z(z_index + 1) = temp;
          end
		  

		  

         end
     end
end