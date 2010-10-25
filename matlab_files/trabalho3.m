% ===================================
% Identificacao de sistemas
% Tassiano Neuhaus
% tassianors@gmail.com
% UFRGS
% ===================================
clear all; close all;
R=zeros(3,3);
% ===================================
% Data

I=[0.94;1.6;2.02;2.3;2.63;3.01;3.42;
    4.09;4.51;4.91;5.49;6;6.6;6.9;3.16];
V=[1.45;2.58;3.08;3.54;4.01;4.57;5.21;
    6.21;7.09;7.71;8.36;9.06;10;10.46;4.8];
I2=[0.81;1.2;1.68;2.28;2.81;3.27;3.9;
    4.22;4.81;5.3;5.78;6.38;6.71;6.94;4.55];
V2=[1.28;2.14;2.71;3.51;4.49;5.05;6.05;
    6.72;7.45;8.13;8.9;9.73;10.17;10.51;7];
I3=[0.82;1.1;1.25;1.94;2.22;2.68;3.12;
    3.42;4;4.55;5.05;5.32;6.1;6.54;6.8];
V3=[1.28;1.71;2.21;3.02;3.64;4.12;4.82;
    5.25;6.11;6.88;7.6;8.32;9.51;10.13;10.52];
% ===================================
% Method 1
Rm1=V./I;
R(1,1)=mean(Rm1);
figure(1);
stem(Rm1);
axis([0 15 1.45 1.65]);
title('Estimativa da Resistencia a cada amostragem - Metodo 1');
xlabel('Medidas efetuadas');
ylabel('Resistência em cada medida');

R2m1=V2./I2;
R(1,2)=mean(R2m1);
figure(2);
stem(R2m1);
axis([0 15 1.45 1.8]);
title('Estimativa da Resistencia a cada amostragem - Metodo 1');
xlabel('Medidas efetuadas');
ylabel('Resistência em cada medida');

R3m1=V3./I3;
R(1,3)=mean(R3m1)
figure(3);
stem(R3m1);
axis([0 15 1.45 1.8]);
title('Estimativa da Resistencia a cada amostragem - Metodo 1');
xlabel('Medidas efetuadas');
ylabel('Resistência em cada medida');
% ===================================
% Method 2
Vm2=mean(V);
Im2=mean(I);
R(2,1)=Vm2/Im2;

V2m2=mean(V2);
I2m2=mean(I2);
R(2,2)=V2m2/I2m2;

V3m2=mean(V3);
I3m2=mean(I3);
R(2,3)=V3m2/I3m2;
% ===================================
% Method 3

Vmq=mean(V.^2);
IVmq=mean(I.*V);
R(3,1)=Vmq/IVmq;

V2mq=mean(V2.^2);
IV2mq=mean(I2.*V2);
R(3,2)=V2mq/IV2mq;

V3mq=mean(V3.^2);
IV3mq=mean(I3.*V3);
R(3,3)=V3mq/IV3mq;
% ===================================
