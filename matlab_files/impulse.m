%====================================
% Identificacao de sistemas
% Tassiano Neuhaus
% tassianors@gmail.com
% UFRGS
%====================================

close all; clear all;
syms s;
s=0;
TS=0.01;
TF=6;

G=tf([10],[1 2 20]);
% u
t = 0:TS:TF;
%u = sin(t);
u = randn(size(t));
ynr=lsim(G, u, t);
y=ynr+u'*0.2*0.2;
%figure(1);plot(t, y);

%agora temos  entrada e saída.
% é possível calcular ru
N=size(y, 1)

% init ru
ru = zeros(N, 1);
for tal=1: N 
    for t=1: N-tal
        s=s+u(t+tal)*u(t);
    end
    ru(tal)=s;
    s=0;
end
%figure(2);plot(ru/N);
ru=ru/N;

M=100;
RM=zeros(M);
for i=1:M
    for j=1:M
        RM(i,j)=ru(sqrt((j-i)^2)+1);
    end
end

ryu = zeros(N, 1);
for tal=1: N 
    for t=1: N-tal
        s=s+y(t+tal)*u(t);
    end
    ryu(tal)=s;
    s=0;
end
ryu=ryu/N;
figure(3); plot(ryu);

for i=1:M
    RYU(i)=ryu(i);
end

h=ryu/(sqrt(ru(1)^2));

figure(4); plot(h);
figure(5); impulse(G);
