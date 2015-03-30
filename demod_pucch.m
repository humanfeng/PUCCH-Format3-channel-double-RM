function Rxinput_b = demod_pucch(Rxinput_d,pucch_tpye)
%PUCCH特殊的调制，根据协议中的表。5.4.1-1
if pucch_tpye == 1           %1a
    if Rxinput_d > 0
        Rxinput_b = 0;
    else
        Rxinput_b = 1;
    end
elseif pucch_tpye == 2       %1b
    Rxinput_d_dec = Rxinput_d * (1 + j);           
    %乘上一个旋转因子。分别判断实部与虚部，如果实部大于0，则第1比特为0，否则第1比特为1
                                       %如果虚部小于0，则第2比特为0，否则第2比特为1                  
    if real(Rxinput_d_dec) > 0
        Rxinput_b = 0;
    else
        Rxinput_b = 1;
    end
    
    if imag(Rxinput_d_dec) > 0
        Rxinput_b = [Rxinput_b 0];
    else
        Rxinput_b = [Rxinput_b 1];
    end
end
