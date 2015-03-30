%**************************************************************************
%Copyright (C), 2012, CQUPT
%FileName:     pusch_deprecoding
%Description:  deprecoding
%Author:       DSP_GROUP
%Input:        before_precode:data for deprecoding
%Output:       dsymb:data after deprecoding
%History:
%      <time>      <version >
%      2012/5/15      1.0
%**************************************************************************

function dsymb=UL_deprecoding(before_precode)
global N_UL_symb;
global N_SRS;
global M_PUSCH_sc;
global L_CRBs;

for i=1:(2*(N_UL_symb-1)-N_SRS)
    precode_out_temp(:,i)=sqrt(M_PUSCH_sc)*ifft(before_precode(:,i));
end
dsymb=reshape(precode_out_temp,1,(2*(N_UL_symb-1)-N_SRS)*(12*L_CRBs));