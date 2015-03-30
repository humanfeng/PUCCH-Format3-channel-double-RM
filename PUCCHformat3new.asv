function z=PUCCHformat3(input_b,N_cell_ID,n_RNTI,subframe_N,pucch_tpye,ackNackSRS_SimuTran)
%生成PUCCH格式3,符号Z
global SYMBOL_L_SEQ_2;
global CPflag;
global Delta_PUCCH_shift;
global n_1_PUCCH;
global PUCCHN_1_cs;
global N_RB_sc;
global n_2_PUCCH;
global N_2_RB;
global PUCCHn_1;
N_PUCCH_seq = 12;

input_b_len=length(input_b);
i=0;
j=0;
k=0;
temp=0;
PUCCH3n_oc=zeros(1,2);

RandomSeqCinite=(floor(subframe_N) + 1) * (2 * N_cell_ID + 1) * 2^16 + n_RNTI;
c=GenRandomSeq(input_b_len, RandomSeqCinite);
for i=1:input_b_len           %直接加扰48个比特
        input_b1(i)=mod((input_b(i)+c(i)),2); % scrambling b(i),resulting in a block of scrambled bits b1(0),...b1(numbits-1)
end

input_d = qpsk_mod(input_b1,input_b_len);   %调制

for j=1:2
 % 求N_PUCCH_SF
 if( j==2&ackNackSRS_SimuTran == 1)
          N_PUCCH_SF= 4;
      else 
          N_PUCCH_SF= 5;
 end
  if(ackNackSRS_SimuTran == 1)
          N_PUCCH_SF1= 4;
  else 
          N_PUCCH_SF1= 5;
  end
  N_PUCCH_SF0= 5;
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
 
    n_s = subframe_N*2 + j-1;
      if j==1
         u=25;
      else
         u=0;
      end
   %计算PUCCH3n_oc(n_s)
       if (j == 1)                                               
	       PUCCH3n_oc(1) = mod(n_3_PUCCH,N_PUCCH_SF1);
       elseif (j == 2)                                                          %扩展CP类型
	       if(N_PUCCH_SF1==5)
	          PUCCH3n_oc(2) =3*mod( PUCCH3n_oc(1),N_PUCCH_SF1);
	       else
	          PUCCH3n_oc(2) =mod(PUCCH3n_oc(1),N_PUCCH_SF1);      
           end
       end

    for k=1:5                 %每个时隙生成5个符号信息
        l=SYMBOL_L_SEQ_2(CPflag+1,k);  
        TxPUCCHn_cell_cs=TxPUCCHCaln_cell_cs(n_s,l,CPflag,N_cell_ID);
        M_RS_sc = N_RB_sc;
        %生成y序列
        n=5*(j-1)+k;
        n_=mod(n,5);
        for ii = 1 : N_RB_sc
            if n<=5
               y_n(ii,n) = w_n_oc(j,n_) * exp(1j*pi*(floor(TxPUCCHn_cell_cs/ 64)/2)*input_b(ii);  %序号
            else
               y_n(ii,n) = w_n_oc(j,n_) * exp(1j*pi*(floor(TxPUCCHn_cell_cs/ 64)/2)*input_b(N_RB_sc+ii);
            end          
        end
        for ii = 1 : N_RB_sc       
            temp=mod(ii+TxPUCCHn_cell_cs,N_RB_sc);
            y_n_(ii,n) =y_n_(temp,n);
        end
           temp=0
        %生成Z序列
        for ii = 1 : N_RB_sc
            z_index = N_RB_sc * ( n - 1) + (ii - 1);  %序号
            for jj=1:N_RB_sc
                temp= y_n_(jj,n)*exp(-1j*2*pi*ii*(n-1)/N_RB_sc);
            end    
            z(z_index + 1) =(1/sqrt(N_port))*(1/sqrt(N_RB_sc))*temp;
        end
    end
end
