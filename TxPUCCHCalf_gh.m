function f_gh=TxPUCCHCalf_gh(n_s,N_cell_ID)    
%Éú³Éf_gh
f_gh=0;       
TxPUCCHn_cell_csvar = 8 * n_s ;
RandomSeqCinite = floor(N_cell_ID/30);
RandomSeqInLen = 8 * n_s +8 ;
 
RandomSeq=GenRandomSeq(RandomSeqInLen, RandomSeqCinite);
for i = 0:7
   temp = TxPUCCHn_cell_csvar + i;
   f_gh = f_gh + RandomSeq(temp+1)*2^i;
end
f_gh=mod(f_gh,30);