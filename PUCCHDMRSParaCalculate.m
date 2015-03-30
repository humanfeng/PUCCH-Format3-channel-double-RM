function [PUCCHN_1 PUCCHn_oc PUCCHn_1]=PUCCHDMRSParaCalculate(n_s,PUCCHN_1_cs,CPflag,Delta_PUCCH_shift,...
                                                          n_1_PUCCH,N_RB_sc)
global PUCCHn_1;
      if (CPflag == 0)      %普通CP类型
	       PUCCHc = 3;
           PUCCHd = 2;
      else                  %扩展CP类型
	       PUCCHc = 2;
           PUCCHd = 0;
      end

	  PUCCHtemp = PUCCHc * PUCCHN_1_cs / Delta_PUCCH_shift;
      PUCCHtemp1 = PUCCHc * N_RB_sc / Delta_PUCCH_shift;
	  
	  %计算PUCCHN_1
	  if (n_1_PUCCH < PUCCHtemp )
	      PUCCHN_1 = PUCCHN_1_cs;
      else
	      PUCCHN_1 = N_RB_sc;
      end

	  %计算PUCCHn_1(n_s)
     
	  if (mod(n_s , 2) == 0)                           %偶时隙
	      if (n_1_PUCCH < PUCCHtemp)
		      PUCCHn_1(n_s+1) = n_1_PUCCH;
          else
		      Num = n_1_PUCCH - PUCCHtemp;
	          Den = PUCCHtemp1;
              PUCCHn_1(n_s+1) = mod(Num,Den);                        %PUCCHn_1[n_s)=Num mod Den
          end
	  else                                        %奇时隙
	      Num = PUCCHn_1(n_s) + PUCCHd;
	      Den = PUCCHc * PUCCHN_1 / Delta_PUCCH_shift;
          PUCCHh = mod(Num,Den);                                      %PUCCHh=Num mod Den
	      if (n_1_PUCCH < PUCCHtemp)
		      %PUCCHn_1[n_s) = floor(PUCCHh / PUCCHc) + (PUCCHh mod PUCCHc) * PUCCHN_1 / Delta_PUCCH_shift         
		      PUCCHtemp2 = mod(PUCCHh,PUCCHc);                          %PUCCHtemp2=PUCCHh mod PUCCHc
		      
		      PUCCHn_1(n_s+1) = floor(PUCCHh / PUCCHc) + PUCCHtemp2 * PUCCHN_1 / Delta_PUCCH_shift;   
          else
		      %PUCCHn_1(n_s) = (PUCCHc*(PUCCHn_1(n_s -1)+1) mod (PUCCHtemp1 + 1)) -1
		      Num = PUCCHc*(PUCCHn_1((n_s+1)-1) + 1);
	          Den = PUCCHtemp1 + 1;
              PUCCHn_1(n_s+1) = mod(Num,Den) - 1;                   %PUCCHn_1(n_s)=(Num mod Den) -1 
          end
      end
      %计算PUCCHn_oc(n_s)

	  PUCCHn_oc = floor(PUCCHn_1(n_s+1) * Delta_PUCCH_shift / PUCCHN_1);
                                                     
      