%====================================
% Identificacao de sistemas
% Tassiano Neuhaus
% tassianors@gmail.com
% UFRGS
%====================================
close all; clear all;

% Definitions
Ts=10e-3;
Tf=10;
STD=0.1;
tempo = 0:Ts:Tf;
N=size(tempo, 2);

M=300;

% TFs
G=tf([2],[1 -0.8], Ts);
% item 1 e 2
H=tf([1 0.9],[1 -0.5], Ts);
% item 3
%H=tf([1],[1], Ts);

% Replace the default stream with a stream whose seed is based on CLOCK, so
% RAND will return different values in different MATLAB sessions
RandStream.setDefaultStream( RandStream('mt19937ar', 'seed', sum(100*clock)));

% identification using MMQ
% model y(t)=2*u(t-1)+0.8*y(t-1) +u(t) +0.8*y(t-1)
teta=[0.8; 1; 2];
n=size(teta, 1);
% e entrada u saida do controlador
%phy=[y(t-1); u(t); u(t-1)]

% numero de vezes que sera aplicado o metodo.
a=zeros(M,1);
b=zeros(M,1);
for j=1:M
    % make a randon noise with std = 0.1
    ran=rand(N, 1);
    s=std(ran);
    % now ran_s has std=1;
    ran_s=ran/s;
    m=mean(ran_s);
    % make noise be zero mean
    rh=(ran_s-m)*STD;
    
    % make a randon noise with std = 1
    ran=rand(N, 1);
    s=std(ran);
    m=mean(ran);
    % now rr has std=1;
    rr=(ran-m)/s;
    
    yr=lsim(G, rr, tempo);
    ynoise=lsim(H, rh, tempo);
    y=yr+ynoise;
    u=rr;
    
    phy=zeros(N, n);
    for t=2:N
        phy(t, 1)=y(t-1);
        phy(t, 2)=u(t);
        phy(t, 3)=u(t-1);
    end

    % make sure, rank(phy) = n :)
    teta_r=inv(phy'*phy)*phy'*y;
    % to be used in grafic plot
    a(j)=teta_r(1);
    b(j)=teta_r(3);
end
PN=[a, b];
ma=mean(a)
sa=std(a);
mb=mean(b)
sb=std(b);
plot(a, b, 'bo');
hold;
plot(ma, mb, 'rx');
hold;
title('Simulacao para entrada do tipo ruido branco com media zero - ARX')
xlabel('Valor da estimativa para a variavel b')
ylabel('Valor da estimativa para a variavel a')
legend('Estimativas', 'Media')

%valor da tabela chi-quadrado para 95% de confianca
chi = 5.991;
ang = linspace(0,2*pi,360)';
[avetor,SCR,avl] = princomp(PN);
Diagonal= diag(sqrt(chi*avl));
elipse=[cos(ang) sin(ang)] * Diagonal * avetor' + repmat(mean(PN), 360, 1);
line(elipse(:,1), elipse(:,2), 'linestyle', '-', 'color', 'k');


