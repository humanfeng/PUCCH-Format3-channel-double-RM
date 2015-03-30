% /*********************************************************************
% Copyright:    �����ʵ��ѧ                                        
% FileName:     PUCCHGenAlpha2                                      
% Description:  ����Alpha2(ns,l),������������ĸ��ֵ,PUCCHGenAlpha2[0]Ϊ���ӣ�����2*pi����[1]Ϊ��ĸ                      
% Author:       DSP��-����                                         
% Usage:        void                                                 
% Input:        1.PUCCHAlpha2         PUCCHAlpha2�׵�ַ
%               2.PUCCHn_1:
%               3.n_2_PUCCH:
%               4.n_s:                   ʱ϶��
%               5.N_RB_sc:             ��Դ����
%               6.N_2_RB:           
%               7.PUCCHN_1_cs:
%               8.TxPUCCHn_cell_cs:      n_cell_cs(ns,l) 
%               9.l:                     �������                   		                              	              
% Altered Registers:                                                 
% Others:                                                              
% History:                                                                
% <time>      <version>        <desc>                               
% 2009/11/24     0.0.0    build this moudle                            
% *********************************************************************/

function PUCCHAlpha2=PUCCHGenAlpha2(n_2_PUCCH,n_s,N_RB_sc,N_2_RB,PUCCHN_1_cs,TxPUCCHn_cell_cs,l)
global PUCCHn_1;
      PUCCHtemp=N_2_RB * N_RB_sc;
	  if (mod(n_s,2) == 0)
	      if (n_2_PUCCH < PUCCHtemp)
		      %PUCCHn_1(n_s) = n_2_PUCCH mod N_RB_sc;
              PUCCHn_1(n_s+1) = mod(n_2_PUCCH,N_RB_sc);
          else
		      %PUCCHn_1(n_s) = (n_2_PUCCH + PUCCHN_1_cs +1) mod N_RB_sc
		      Num = n_2_PUCCH + PUCCHN_1_cs + 1;
	          Den = N_RB_sc;
              PUCCHn_1(n_s+1) = mod(Num,Den);           %PUCCHn_1(n_s)=Num mod Den
          end
      else
	  	  if (n_2_PUCCH < PUCCHtemp)
		      %PUCCHn_1(n_s) = (N_RB_sc * (PUCCHn_1(ns-1) + 1)) mod (N_RB_sc + 1)) - 1
			  Num = N_RB_sc * (PUCCHn_1(n_s+1 - 1) + 1);
	          Den = N_RB_sc + 1;
              PUCCHn_1(n_s+1) = mod(Num,Den)-1;
          else
		      %PUCCHn_1(n_s) = (N_RB_sc - n_2_PUCCH) mod N_RB_sc
		      Num = N_RB_sc - n_2_PUCCH-2;
	          Den = N_RB_sc;
              PUCCHn_1(n_s+1) = mod(Num,Den);           %PUCCHn_1(n_s)=Num mod Den
          end
      end
	  %PUCCHn_cs(ns,l) = (TxPUCCHn_cell_cs(n_s,l) + n_1(n_s)) mod (N_RB_sc)
      Num = TxPUCCHn_cell_cs + PUCCHn_1(n_s+1);
	  Den = N_RB_sc;
      PUCCHn_cs = mod(Num,Den);           %PUCCHn_cs=Num mod Den
	  
	  %PUCCHAlpha2(n_s + l * 20) = 2 * pi * PUCCHn_cs / N_RB_sc;
%       PUCCHAlpha2(0) = PUCCHn_cs;
%       PUCCHAlpha2(1) = N_RB_sc;
      PUCCHAlpha2=2 * pi * PUCCHn_cs/N_RB_sc;
