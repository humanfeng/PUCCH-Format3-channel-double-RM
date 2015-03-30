function s3=rmdecode(r2)
%r2就为经过信道之后收到的序列
%FHT算法译码
m=...
[1	1	0	0	0	0	0	0	0	0	1	1	0
1	1	1	0	0	0	0	0	0	1	1	1	0
1	0	0	1	0	0	1	0	1	1	1	1	1
1	0	1	1	0	0	0	0	1	0	1	1	1
1	1	1	1	0	0	0	1	0	0	1	1	1
1	1	0	0	1	0	1	1	1	0	1	1	1
1	0	1	0	1	0	1	0	1	1	1	1	1
1	0	0	1	1	0	0	1	1	0	1	1	1
1	1	0	1	1	0	0	1	0	1	1	1	1
1	0	1	1	1	0	1	0	0	1	1	1	1
1	0	1	0	0	1	1	1	0	1	1	1	1
1	1	1	0	0	1	1	0	1	0	1	1	1
1	0	0	1	0	1	0	1	1	1	1	1	1
1	1	0	1	0	1	0	1	0	1	1	1	1
1	0	0	0	1	1	0	1	0	0	1	0	1
1	1	0	0	1	1	1	1	0	1	1	0	1
1	1	1	0	1	1	1	0	0	1	0	1	1
1	0	0	1	1	1	0	0	1	0	0	1	1
1	1	0	1	1	1	1	1	0	0	0	0	0
1	0	0	0	0	1	1	0	0	0	0	0	0
1	0	1	0	0	0	1	0	0	0	1	0	1
1	1	0	1	0	0	0	0	0	1	1	1	0
1	0	0	0	1	0	0	1	1	0	1	0	1
1	1	1	0	1	0	0	0	1	1	1	1	0
1	1	1	1	1	0	1	1	1	1	0	0	1
1	1	0	0	0	1	1	1	0	0	1	1	1
1	0	1	1	0	1	0	0	1	1	0	0	0
1	1	1	1	0	1	0	1	1	1	0	1	0
1	0	1	0	1	1	1	0	1	0	0	1	0
1	0	1	1	1	1	1	1	1	0	0	1	1
1	1	1	1	1	1	1	1	1	1	1	0	1
1	0	0	0	0	0	0	0	0	0	0	0	0];
%transform matrix in 3gpp to find mask serial
m1=[m(32,:);m(1,:);m(21,:);m(2:3,:);m(22,:);m(4:5,:);m(23,:);m(6:7,:);m(24,:);m(8:10,:);m(25,:);m(20,:);m(26,:);m(11:14,:);m(27:28,:);m(15:16,:);m(29,:);m(17:19,:);m(30:31,:)];
m2=[m1(:,2:6),m1(:,1)];
m3=flipud(m2');
m4=[m3;m1(:,7:13)'];

%FHT算法译码
r5=zeros(1,8);
%将接收到的20比特添加到32比特
r4=[r2(:,1:24),r5(:,1:8)];
r=[r4(1,32) r4(1,1) r4(1,21) r4(1,2:3) r4(1,22) r4(1,4:5) r4(1,23) r4(1,6:7) r4(1,24) r4(1,8:10) r4(1,25) r4(1,20) r4(1,26) r4(1,11:14) r4(1,27:28) r4(1,15:16) r4(1,29) r4(1,17:19) r4(1,30:31)]; 
%arrange mask serials according to binary order
M0=zeros(1,32);% 0
M1=m4(7,:);  % 1
M2=m4(8,:);  % 2
M3=m4(9,:);  % 4
M4=m4(10,:);  % 8
M5=m4(11,:);  % 16
M6=m4(12,:);  % 32 
M7=m4(13,:);  % 64
M8=mod((M1+M2),2);  % 3
M9=mod((M1+M3),2);  % 5
M10=mod((M1+M4),2); % 9
M11=mod((M1+M5),2); % 17
M12=mod((M1+M6),2); % 33
M13=mod((M1+M7),2); % 65
M14=mod((M2+M3),2);  % 6
M15=mod((M2+M4),2);  % 10
M16=mod((M2+M5),2);  % 18
M17=mod((M2+M6),2);  % 34
M18=mod((M2+M7),2);  % 66
M19=mod((M3+M4),2);  % 12
M20=mod((M3+M5),2);  % 20
M21=mod((M3+M6),2);  % 36
M22=mod((M3+M7),2);  % 68
M23=mod((M4+M5),2);  % 24
M24=mod((M4+M6),2);  % 40
M25=mod((M4+M7),2);  % 72
M26=mod((M5+M6),2);  % 48
M27=mod((M5+M7),2);  % 80
M28=mod((M6+M7),2);  % 96
M29=mod((M1+M2+M3),2); % 7  
M30=mod((M1+M2+M4),2); % 11
M31=mod((M1+M2+M5),2); % 19
M32=mod((M1+M2+M6),2); % 35
M33=mod((M1+M2+M7),2); % 67
M34=mod((M1+M3+M4),2); % 13 
M35=mod((M1+M3+M5),2); % 21
M36=mod((M1+M3+M6),2); % 37
M37=mod((M1+M3+M7),2); % 69
M38=mod((M1+M4+M5),2); % 25
M39=mod((M1+M4+M6),2); % 41
M40=mod((M1+M4+M7),2); % 73
M41=mod((M1+M5+M6),2); % 49
M42=mod((M1+M5+M7),2); % 81
M43=mod((M1+M6+M7),2); % 97
M44=mod((M2+M3+M4),2); % 14
M45=mod((M2+M3+M5),2); % 22
M46=mod((M2+M3+M6),2); % 38
M47=mod((M2+M3+M7),2); % 70
M48=mod((M2+M4+M5),2); % 26
M49=mod((M2+M4+M6),2); % 42
M50=mod((M2+M4+M7),2); % 74
M51=mod((M2+M5+M6),2); % 50
M52=mod((M2+M5+M7),2); % 82
M53=mod((M2+M6+M7),2); % 98
M54=mod((M3+M4+M5),2); % 28
M55=mod((M3+M4+M6),2); % 44
M56=mod((M3+M4+M7),2); % 76
M57=mod((M3+M5+M6),2); % 52
M58=mod((M3+M5+M7),2); % 84
M59=mod((M3+M6+M7),2); % 100
M60=mod((M4+M5+M6),2); % 56
M61=mod((M4+M5+M7),2); % 88
M62=mod((M4+M6+M7),2); % 104
M63=mod((M5+M6+M7),2); % 112
M64=mod((M1+M2+M3+M4),2);  % 15
M65=mod((M1+M2+M3+M5),2);  % 23
M66=mod((M1+M2+M3+M6),2);  % 39
M67=mod((M1+M2+M3+M7),2);  % 71
M68=mod((M1+M2+M4+M5),2);  % 27
M69=mod((M1+M2+M4+M6),2);  % 43
M70=mod((M1+M2+M4+M7),2);  % 75
M71=mod((M1+M2+M5+M6),2);  % 51
M72=mod((M1+M2+M5+M7),2);  % 83
M73=mod((M1+M2+M6+M7),2);  % 99
M74=mod((M1+M3+M4+M5),2);  % 29
M75=mod((M1+M3+M4+M6),2);  % 45
M76=mod((M1+M3+M4+M7),2);  % 77
M77=mod((M1+M3+M5+M6),2);  % 53
M78=mod((M1+M3+M5+M7),2);  % 85
M79=mod((M1+M3+M6+M7),2);  % 101
M80=mod((M1+M4+M5+M6),2);  % 57
M81=mod((M1+M4+M5+M7),2);  % 89
M82=mod((M1+M4+M6+M7),2);  % 105
M83=mod((M1+M5+M6+M7),2);  % 113
M84=mod((M2+M3+M4+M5),2);  % 30
M85=mod((M2+M3+M4+M6),2);  % 46
M86=mod((M2+M3+M4+M7),2);  % 78
M87=mod((M2+M3+M5+M6),2);  % 54
M88=mod((M2+M3+M5+M7),2);  % 86
M89=mod((M2+M3+M6+M7),2);  % 102
M90=mod((M2+M4+M5+M6),2);  % 58
M91=mod((M2+M4+M5+M7),2);  % 90
M92=mod((M2+M4+M6+M7),2);  % 106
M93=mod((M2+M5+M6+M7),2);  % 114
M94=mod((M3+M4+M5+M6),2);  % 60
M95=mod((M3+M4+M5+M7),2);  % 92
M96=mod((M3+M4+M6+M7),2);  % 108
M97=mod((M3+M5+M6+M7),2);  % 116
M98=mod((M4+M5+M6+M7),2);  % 120
M99=mod((M1+M2+M3+M4+M5),2);  % 31
M100=mod((M1+M2+M3+M4+M6),2); % 47
M101=mod((M1+M2+M3+M4+M7),2); % 79
M102=mod((M1+M2+M3+M5+M6),2); % 55
M103=mod((M1+M2+M3+M5+M7),2); % 87
M104=mod((M1+M2+M3+M6+M7),2); % 103
M105=mod((M1+M2+M4+M5+M6),2); % 59
M106=mod((M1+M2+M4+M5+M7),2); % 91
M107=mod((M1+M2+M4+M6+M7),2); % 107
M108=mod((M1+M2+M5+M6+M7),2); % 115
M109=mod((M1+M3+M4+M5+M6),2); % 61
M110=mod((M1+M3+M4+M5+M7),2); % 93
M111=mod((M1+M3+M4+M6+M7),2); % 109
M112=mod((M1+M3+M5+M6+M7),2); % 117
M113=mod((M1+M4+M5+M6+M7),2); % 121
M114=mod((M2+M3+M4+M5+M6),2); % 62
M115=mod((M2+M3+M4+M5+M7),2); % 94
M116=mod((M2+M3+M4+M6+M7),2); % 110
M117=mod((M2+M3+M5+M6+M7),2); % 118
M118=mod((M2+M4+M5+M6+M7),2); % 122
M119=mod((M3+M4+M5+M6+M7),2); % 124
M120=mod((M1+M2+M3+M4+M5+M6),2); % 63
M121=mod((M1+M2+M3+M4+M5+M7),2); % 95
M122=mod((M1+M2+M3+M4+M6+M7),2); % 111
M123=mod((M1+M2+M3+M5+M6+M7),2); % 119
M124=mod((M1+M2+M4+M5+M6+M7),2); % 123
M125=mod((M1+M3+M4+M5+M6+M7),2); % 125
M126=mod((M2+M3+M4+M5+M6+M7),2); % 126
M127=mod((M1+M2+M3+M4+M5+M6+M7),2); %127
M=[M0;M1;M2;M8;M3;M9;M14;M29;M4;M10;M15;M30;M19;M34;M44;M64;M5;M11;M16;M31;M20;M35;M45;M65;M23;M38;M48;M68;M54;M74;M84;M99;M6;M12;M17;M32;M21;M36;M46;M66;M24;M39;M49;M69;M55;M75;M85;M100;M26;M41;M51;M71;M57;M77;M87;M102;M60;M80;M90;M105;M94;M109;M114;M120;M7;M13;M18;M33;M22;M37;M47;M67;M25;M40;M50;M70;M56;M76;M86;M101;M27;M42;M52;M72;M58;M78;M88;M103;M61;M81;M91;M106;M95;M110;M115;M121;M28;M43;M53;M73;M59;M79;M89;M104;M62;M82;M92;M107;M96;M111;M116;M122;M63;M83;M93;M108;M97;M112;M117;M123;M98;M113;M118;M124;M119;M125;M126;M127];
M=1-2*M;
b=zeros(128,32);
%soft decode                        
%make real part of input data added mask serials    
for k=1:128                         
    for j=1:32 
        b(k,j)=r(1,j)*M(k,j);  
    end
end
%make hadamard translation
n=b*(-hadamard(32));
c=abs(n);
%find max value in matrix c
e=zeros(1,32);
for i=1:128
    for j=1:32
        e(1,j)=c(i,j);
    end
      [y,ind]=max(e);
      t(i)=y;                %max value of each row
      s(i)=ind;              %column number of each row's max value 
end
  [y,ind]=max(t);            %max value in matrix
  p=ind;                     %row number of max value
  q=s(ind);                  %column number of max value
%decode  
%judge first information bit according to max value's angle
if(n(p,q)>0)                       
    a0=1;                                
else                
    a0=0;                               
end
%s1----s5
%information bit1 to bit5 is the binary form of max value's column number
a1=zeros(1,5);
q=q-1;
for i=1:5        
    a1(1,i)=mod(q,2);
    q=fix(q/2);
end
%s6----s12
%information bit6 to bit12 is the binary form of max value's row number
b=zeros(1,7);
p=p-1;
for i=1:7
    b(1,i)=mod(p,2);
    p=fix(p/2);
end
%get 13bit information,first 6bit reverse order 
s3=[a0 a1 b];