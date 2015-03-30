# PUCCH-Format3-channel-double-RM
%本次仿真PUCCH 链路信道估计,频域上取1个资源块,子载波间隔deltaf=15kHz %由于传输时以子帧为单位的,所以仿真时时域上取一个子帧,即两个时隙 %对于普通CP,一个时隙中的第一个符号CP=160,其余符号CP=144 %子载波subcarrier之间的导频间隔为0,即频域上导频连续排放,所以只做时域插值,频域不需要 %取14个SC-FDMA符号,一个ofdm符号长度为1/14ms. %采用QPSK和PUCCH格式2b专用QPSK混合调制 %模型：1发2收
