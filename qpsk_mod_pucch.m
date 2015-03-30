function input_d = qpsk_mod_pucch(input_b,input_b_len)
%PUCCH特殊的调制，根据协议中的表。5.4.1-1
if input_b_len == 1           %1a
    input_d = 1 - 2 * input_b;
else input_b_len == 2         %1b
    if input_b = [0 0]
        input_d = 1;
    elseif input_b = [0 1]
        input_d = -i;
    elseif input_b = [1 0]
        input_d = i;
    else
        input_d = -1;
    end
end
