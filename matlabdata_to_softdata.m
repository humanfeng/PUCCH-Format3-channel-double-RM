function y=matlabdata_to_softdata(inputdata,len)      
      max_data=0;                  %记录最大值，用以归一化操作
      x=1;                         %最大值索引标记
      for ii=1:len     
          if max_data<abs(real(inputdata(ii)))
              max_data=real(inputdata(ii));    %记录实部最大值
              x=ii;
          end
          if max_data<abs(imag(inputdata(ii)))
              max_data=imag(inputdata(ii));     %记录虚部最大值
              x=ii;
          end
      end
      t=max_data;           %最大值暂存
      m=0;
      while floor(t)~=0
          t=t/2;
          m=m+1;            %归一化位数
      end
       for ii=1:len
           data_real(ii)=(real(inputdata(ii)))*2^(15-m);%实部归一化
           data_imag(ii)=(imag(inputdata(ii)))*2^(15-m);%虚部归一化
       end
       data_real=fix(data_real);
       data_imag=fix(data_imag);
    
       t=fi(0,1,16,0);
       for ii=1:len
           
           t.data=data_real(ii);
           data_real1=t.hex;
           t.data=data_imag(ii);
           data_imag1=t.hex;
           data_after_quan_temp=cat(2,data_real1,data_imag1);
           data_after_quan(ii,:)=cat(2,'0x',data_after_quan_temp);
           
       end
       y=data_after_quan;
       %save('data_and_noise','data_after_quan');