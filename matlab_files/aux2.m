close all; clear all;
data6
d=value(100:200, 1:2)
plot(d);
xlabel('k[Ts=10ms]')
ylabel('Amplitude do sinal')
title('Entrada e saida do sistema considerando-se o PID na malha')
