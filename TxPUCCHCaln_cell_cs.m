function TxPUCCHn_cell_cs=TxPUCCHCaln_cell_cs(n_s,l,CPflag,N_cell_ID)    
%����TxPUCCHn_cell_cs
TxPUCCHn_cell_cs=0;
if (CPflag ==0)
    N_UL_symb = 7;
else
    N_UL_symb = 6; 
end
        
TxPUCCHn_cell_csvar = 8 * N_UL_symb * n_s + 8 * l;
RandomSeqCinite = N_cell_ID;
RandomSeqInLen = 8 * N_UL_symb * n_s + 8 * l +8 ;
 
RandomSeq=GenRandomSeq(RandomSeqInLen, RandomSeqCinite);
for i = 0:7
   temp = TxPUCCHn_cell_csvar + i;
   TxPUCCHn_cell_cs = TxPUCCHn_cell_cs + RandomSeq(temp+1)*2^i;
end
