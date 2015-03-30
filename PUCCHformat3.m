function B_z=PUCCHformat3(input_b,N_cell_ID,n_RNTI,subframe_N,pucch_type,ackNackSRS_SimuTran)
%生成PUCCH格式3,符号Z
global SYMBOL_L_SEQ_2;
global CPflag;
global N_RB_sc;
global n_3_PUCCH;
global N_port;
input_b_len=length(input_b);
PUCCH3n_oc=zeros(1,2);
 z=zeros(1,120);
 Data_c=zeros(1,48);
if(pucch_type==6)
   RandomSeqCinite=(floor(subframe_N) + 1) * (2 * N_cell_ID + 1) * 2^16 + n_RNTI;
end 
   c= GenRandomSeq(input_b_len, RandomSeqCinite);
  for i=1:input_b_len           %直接加扰48个比特
      Data_c(i)=mod((input_b(i)+c(i)),2); % scrambling b(i),resulting in a block of scrambled bits b1(0),...b1(numbits-1)
  end

 Data_mod= qpsk_mod(Data_c,input_b_len);   %调制

for jj=1:2
 % 求N_PUCCH_SF
  if( jj==2&&ackNackSRS_SimuTran == 1)
          N_PUCCH_SF= 4;
  else 
          N_PUCCH_SF= 5;
  end
  if(ackNackSRS_SimuTran == 1)
          N_PUCCH_SF1= 4;
  else 
          N_PUCCH_SF1= 5;
  end
   % 根据N_PUCCH_SF求 w_n_oc
      if N_PUCCH_SF == 4
        w_n_oc = [1 1 1 1 ;1 -1 1 -1 ;1 1 -1 -1;1 -1 -1 1];
      else
        w_n_oc =[1 1 1 1 1
                 1 exp(1j*2*pi / 5) exp(1j*4*pi / 5)  exp(1j*6*pi / 5) exp(1j*8*pi / 5)
                 1 exp(1j*4*pi / 5) exp(1j*8*pi / 5)  exp(1j*2*pi / 5) exp(1j*6*pi / 5)
                 1 exp(1j*6*pi / 5) exp(1j*2*pi / 5)  exp(1j*8*pi / 5) exp(1j*4*pi / 5)
                 1 exp(1j*8*pi / 5) exp(1j*6*pi / 5)  exp(1j*4*pi / 5) exp(1j*2*pi / 5)];
      end
 
    n_s = subframe_N*2 + jj-1;
%    if Group_hopping_enabled==0
%         f_gh=0;
%     else
%         f_gh=TxPUCCHCalf_gh(n_s,N_cell_ID);
%     end
%     u=mod(f_gh+mod(N_cell_ID,30),30);
%     
     if jj==1
        u=25;
     else
        u=0;
     end
   %计算PUCCH3n_oc(n_s)
       if (jj == 1)                                               
	       PUCCH3n_oc(1) = mod(n_3_PUCCH,N_PUCCH_SF1);
       elseif (jj == 2)                                                          %扩展CP类型
	       if(N_PUCCH_SF1==5)
	          PUCCH3n_oc(2) =mod(3*PUCCH3n_oc(1),N_PUCCH_SF1);
	       else
	          PUCCH3n_oc(2) =mod(PUCCH3n_oc(1),N_PUCCH_SF1);      
           end
       end
    if N_PUCCH_SF == 5
        n_oc=PUCCH3n_oc(1);
    else
        n_oc=PUCCH3n_oc(2);
    end
    for k=1:N_PUCCH_SF                 %每个时隙生成5个符号信息
        l=SYMBOL_L_SEQ_2(CPflag+1,k);  
        TxPUCCHn_cell_cs=TxPUCCHCaln_cell_cs(n_s,l,CPflag,N_cell_ID);
        %生成y序列
        n=5*(jj-1)+k-1;
        n_=mod(n,5);
        for ii = 1 : N_RB_sc
            if n<5
               B_y_n(ii,n+1)= w_n_oc(n_oc,n_+1)* exp(1j*pi*(floor(TxPUCCHn_cell_cs/ 64)/2))*Data_mod(ii);  %序号
            else
               B_y_n(ii,n+1) = w_n_oc(n_oc,n_+1) * exp(1j*pi*(floor(TxPUCCHn_cell_cs/ 64)/2))*Data_mod(N_RB_sc+ii);
            end          
        end
        for ii = 0 : N_RB_sc-1       
            temp=mod(ii+TxPUCCHn_cell_cs,N_RB_sc);
            B_y_n_(ii+1,n+1) =B_y_n(temp+1,n+1);
        end
            B_z(N_RB_sc*n+1:N_RB_sc*n+N_RB_sc) =(1/sqrt(N_port))*(1/sqrt(N_RB_sc))*N_RB_sc*fft(B_y_n_(:,n+1),N_RB_sc).';

    end
end
end
