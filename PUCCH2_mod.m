function  z=PUCCH2_mod(input_d_10,pucch_tpye)

 if pucch_tpye==4
    if input_d_10(1)==0
     z=1;
    else
     z=-1;
    end
 end
 if pucch_tpye==5
    if (input_d_10(1)==0&input_d_10(2)==0)
     z=1;
    end
    if (input_d_10(1)==0&input_d_10(2)==1)
      z=-1j;
    end
    if (input_d_10(1)==1&input_d_10(2)==0)
      z=1j;
    end
    if (input_d_10(1)==1&input_d_10(2)==1)
      z=-1;
    end
 end