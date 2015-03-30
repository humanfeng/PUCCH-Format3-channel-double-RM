%*********************************************************************
% Copyright:    重庆邮电大学                                        
% FileName:     PUCCHParaCalculate                                        
% Description:  计算三个参数：PUCCHN_1，PUCCHn_oc(n_s)，PUCCHn_1(n_s)                        
% Author:       DSP组-陈振东                                         
% Usage:        void                                                 
% Input:       
%               1.PUCCHn_oc:        
%               2.PUCCHn_1:     
%               3.n_s:                   时隙号           
%               4.PUCCHN_1_cs:         
%               5.CPflag:                CP类型
%               6.Delta_PUCCH_shift:    
%               7.n_1_PUCCH:
%               8.N_RB_sc:             资源个数                         		                              	              
% Altered Registers:                                                 
% Others:                                                              
% History:                                                                
% <time>      <version>        <desc>                               
% 2009/11/24     0.0.0    build this moudle
% 2010/04/26     0.0.1    发送端变量与接收端的一样，去掉前缀Tx                            
%*********************************************************************/
function [PUCCHN_1 PUCCHn_oc PUCCHn_1]=PUCCHParaCalculate(n_s,PUCCHN_1_cs,CPflag,Delta_PUCCH_shift,...
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
	  
	  %计算PUCCHN_1(N')
	  if (n_1_PUCCH < PUCCHtemp )
	      PUCCHN_1 = PUCCHN_1_cs;
      else
	      PUCCHN_1 = N_RB_sc;
      end

	  %计算PUCCHn_1(n_s)(n'_n_s)
     
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
      if (CPflag == 0)                                               %普通CP类型
	      PUCCHn_oc = floor(PUCCHn_1(n_s+1) * Delta_PUCCH_shift / PUCCHN_1);
      else                                                           %扩展CP类型
	      PUCCHn_oc = 2 * floor((PUCCHn_1(n_s+1) * Delta_PUCCH_shift / PUCCHN_1));
      end

