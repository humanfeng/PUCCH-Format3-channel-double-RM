%**************************************************************************
%Copyright (C), 2012, CQUPT
%FileName:     DeRxQ_ri1
%Description:  Repeat decoding for RI
%Author:       DSP_GROUP
%Input:        1.Rx_afterInterlea_ri: the RI from the interleaver matrix
%              2.RxO_ri:the number of RI
%Output:       RI:RI after dacoded
%History:
%      <time>      <version >
%      2012/5/15      1.0
%**************************************************************************
function RI=UL_DeRI(Rx_afterInterlea_ri,RxO_ri)
global Qm                                                %调制方式
if RxO_ri==1
    lenth=length(Rx_afterInterlea_ri);
    cycle= lenth/Qm;
    sum=0;
    for i=1:cycle
        temp(1,1:Qm)=Rx_afterInterlea_ri(1,(i-1)*Qm+1:i*Qm);
        temp1=temp(1,1);
        temp2=temp(1,2);
        sum=sum+temp1;
    end
    if sum>0
        RI0=1;
    else
        RI0=0;
    end
    RI=RI0;
elseif RxO_ri==2
    lenth=length(Rx_afterInterlea_ri);
    t=3*Qm;
    cycle= lenth/t;
    sum0=0;
    sum1=0;
    sum2=0;
    %为了计算从交织后RI中取值，特定义下面几个临时变量
    a=Qm+1;
    b=Qm+2;
    c=2*Qm+1;
    d=2*(Qm+1);
    
    for i=1:cycle
        temp(1,1:t)=Rx_afterInterlea_ri(1,(i-1)*t+1:i*t);
        temp1=temp(1,1);
        temp2=temp(1,2);
        
        sum0=sum0+temp(1,1)+temp(1,b);
        sum1=sum1+temp(1,2)+temp(1,c);
        sum2=sum2+temp(1,a)+temp(1,d);
    end
    if sum0>0
        RI0=1;
    else
        RI0=0;
    end
    if sum1>0
        RI1=1;
    else
        RI1=0;
    end
    if sum2>0
        RI2=1;
    else
        RI2=0;
    end
    sum01= RI0+ RI1;
    junge=mod(sum01,2);
    if junge==RI2
        RI=[RI0 RI1];
    else
        RI=('Fail');
    end
end
