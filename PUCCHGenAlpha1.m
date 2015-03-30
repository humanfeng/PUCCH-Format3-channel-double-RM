% /*********************************************************************
% Copyright:    �����ʵ��ѧ                                        
% FileName:     PUCCHGenAlpha1                                     
% Description:  ����Alpha1(ns,l),������������ĸ��ֵ,PUCCHGenAlpha1[0]Ϊ���ӣ�����2*pi����[1]Ϊ��ĸ                     
% Author:       DSP��-����                                         
% Usage:        void                                                 
% Input:        1.TxPUCCHn_cell_cs:      n_cell_cs(ns,l)
%               2.PUCCHn_oc:
%               3.PUCCHn_1:
%               4.n_s:                   ʱ϶��
%               5.CPflag:                CP����
%               6.Delta_PUCCH_shift:           
%               7.PUCCHN_1:            
%               8.l:                     �������
%               9.N_RB_sc:             ��Դ����  
%               10.PUCCHAlpha1:        PUCCHAlpha1�׵�ַ                       		                              	              
% Altered Registers:                                                 
% Others:                                                              
% History:                                                                
% <time>      <version>        <desc>                               
% 2009/11/24     0.0.0    build this moudle                            
% *********************************************************************/

function PUCCHAlpha1=PUCCHGenAlpha1(TxPUCCHn_cell_cs,PUCCHn_oc,PUCCHn_1,n_s,CPflag,...
                                    Delta_PUCCH_shift,PUCCHN_1,l,...
                                    N_RB_sc)

      PUCCHtemp = PUCCHn_1(n_s+1) * Delta_PUCCH_shift;
	  if (CPflag == 0)        %��ͨCP����
          %PUCCHtemp1 =PUCCHn_oc[n_s] mod Delta_PUCCH_shift;
          PUCCHtemp1 = mod(PUCCHn_oc,Delta_PUCCH_shift); 

		  %PUCCHtemp2 = TxPUCCHn_cell_cs(n_s,l)+(PUCCHtemp + PUCCHtemp1) mod PUCCHN_1
	      Num = (PUCCHtemp + PUCCHtemp1);
	      Den = PUCCHN_1;
          PUCCHtemp2 = TxPUCCHn_cell_cs + mod(Num,Den);                            %PUCCHtemp2=TxPUCCHn_cell_cs + Num mod Den

		  %PUCCHn_cs[n_s,l] = PUCCHtemp2 mod N_RB_sc;
          PUCCHn_cs = mod(PUCCHtemp2,N_RB_sc); 
	  else                   %��չCP����
	      %PUCCHtemp1=(PUCCHtemp + PUCCHn_oc[n_s] / 2) mod PUCCHN_1;
          Num = PUCCHtemp + PUCCHn_oc / 2;
	      Den = PUCCHN_1;
          PUCCHtemp1 = mod(Num,Den);                            %PUCCHtemp1=Num mod Den

		  %PUCCHn_cs = (TxPUCCHn_cell_cs[n_s,l] + PUCCHtemp1) mod N_RB_sc;
		  Num = TxPUCCHn_cell_cs + PUCCHtemp1;
	      Den = N_RB_sc;
          PUCCHn_cs = mod(Num,Den);              %PUCCHn_cs[n_s + l * 20]=Num mod Den
      end
	  %PUCCHAlpha1[n_s + l * 20] = 2 * pi * PUCCHn_cs / N_RB_sc;
% 	  PUCCHAlpha1[0] = PUCCHn_cs;
%       PUCCHAlpha1[1] = N_RB_sc;
      PUCCHAlpha1=2 * pi * PUCCHn_cs/N_RB_sc;

