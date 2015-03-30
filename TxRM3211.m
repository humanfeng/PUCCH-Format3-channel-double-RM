function output=TxRM3211(b,output_length)

%matrix in 3GPP LTE，(20,A)编码
m=...
[1	1	0	0	0	0	0	0	0	0	1
1	1	1	0	0	0	0	0	0	1	1
1	0	0	1	0	0	1	0	1	1	1
1	0	1	1	0	0	0	0	1	0	1
1	1	1	1	0	0	0	1	0	0	1
1	1	0	0	1	0	1	1	1	0	1
1	0	1	0	1	0	1	0	1	1	1
1	0	0	1	1	0	0	1	1	0	1
1	1	0	1	1	0	0	1	0	1	1
1	0	1	1	1	0	1	0	0	1	1
1	0	1	0	0	1	1	1	0	1	1
1	1	1	0	0	1	1	0	1	0	1
1	0	0	1	0	1	0	1	1	1	1
1	1	0	1	0	1	0	1	0	1	1
1	0	0	0	1	1	0	1	0	0	1
1	1	0	0	1	1	1	1	0	1	1
1	1	1	0	1	1	1	0	0	1	0
1	0	0	1	1	1	0	0	1	0	0
1	1	0	1	1	1	1	1	0	0	0
1	0	0	0	0	1	1	0	0	0	0
1	0	1	0	0	0	1	0	0	0	1
1	1	0	1	0	0	0	0	0	1	1
1	0	0	0	1	0	0	1	1	0	1
1	1	1	0	1	0	0	0	1	1	1
1	1	1	1	1	0	1	1	1	1	0
1	1	0	0	0	1	1	1	0	0	1
1	0	1	1	0	1	0	0	1	1	0
1	1	1	1	0	1	0	1	1	1	0
1	0	1	0	1	1	1	0	1	0	0
1	0	1	1	1	1	1	1	1	0	0
1	1	1	1	1	1	1	1	1	1	1
1	0	0	0	0	0	0	0	0	0	0];
%encode
% %a=randint(1,13);
% d=[1 1 0 0];
% e=zeros(1,9);
% a=[d e];
%use matrix in 3gpp to encode
L = length(b);
r=mod(b*m(:,1:L)',2);
%*********************************************************
%输出需要的比特长度
       integer_number = floor(output_length/32);
       remainder = rem(output_length,32);
       if (output_length<=32)  %不足32比特
           for i=1:output_length
               output(i)=r(i);
           end
       else                    %超过32比特
           for i=1:integer_number%输出以32为单位的比特
               for j=1:32
               output((i-1)*32+j)=r(j);
               end
           end
           for k=(integer_number*32+1):output_length%输出剩下的比特
               output(k)=r(k-32*integer_number);
           end
       end
           
           