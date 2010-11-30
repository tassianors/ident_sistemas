%====================================
% Identificacao de sistemas
% Tassiano Neuhaus
% tassianors@gmail.com
% UFRGS
%====================================
close all; clear all;

% Definitions
Ts=10e-3;
% frequency used when u(t) is a sinusoidal signal.
freq=pi/20;

Tf=10*2*pi/freq;

STD=0.1;
tempo = 0:Ts:Tf;
N=size(tempo, 2);

M=100;

% TFs
%ARX
G=tf([2],[1 -0.8 0], Ts);
H=tf([1 0 0],[1 -0.8 0], Ts);

% Replace the default stream with a stream whose seed is based on CLOCK, so
% RAND will return different values in different MATLAB sessions
RandStream.setDefaultStream( RandStream('mt19937ar', 'seed', sum(100*clock)));

% identification using MMQ
% model y(t)=a*u(t-2)+(b+c)*y(t-1) +bc*y(t-2)
teta=[2; 0.8; 0];
n=size(teta, 1);
% e entrada u saida do controlador
%phy=[ u(t-2); y(t-1); y(t-2)]

% numero de vezes que sera aplicado o metodo.
a=zeros(M,1);
b=zeros(M,1);
c=zeros(M,1);
for j=1:M
    % make a randon noise with std = 0.1
    ran=rand(N, 1);
    s=std(ran);
    % now ran_s has std=1;
    ran_s=ran/s;
    m=mean(ran_s);
    % make noise be zero mean
    rh=(ran_s-m)*STD;

    %sim
    rr=sin(freq*tempo);
    mean(rr)
    
    yr=lsim(G, rr, tempo);
    ynoise=lsim(H, rh, tempo);
    y=yr+ynoise;
    u=rr;
    
    phy=zeros(N, n);
    z=zeros(N, n);
    for t=3:N
        phy(t, 1)=u(t-2);
        phy(t, 2)=y(t-1);
        phy(t, 3)=y(t-2);
    end
    for t=4:N
        % auxiliary instrument z
        z(t, 3)=u(t-1);
        z(t, 2)=u(t-2);
        z(t, 1)=u(t-3);
    end

    % make sure, rank(phy) = n :)
    teta_r=inv(z'*phy)*z'*y;%inv(phy'*phy)*phy'*y;
    
    % to be used in grafic plot
    a(j)=teta_r(1);
    b(j)=teta_r(2);
    c(j)=teta_r(3);
end
PN=[a, b];
ma=mean(a)
mb=mean(b)
mc=mean(c)

plot(a, b, 'bo');
hold;
plot(ma, mb, 'rx');
hold;
title('Simulacao do sistema para o metodo das variavies instrumentais')
xlabel('Valor da estimativa para a variavel a')
ylabel('Valor da estimativa para a variavel b')
legend('Estimativas', 'Media')

%valor da tabela chi-quadrado para 95% de confianca
chi = 5.991;
ang = linspace(0,2*pi,360)';
[avetor,SCR,avl] = princomp(PN);
Diagonal= diag(sqrt(chi*avl));
elipse=[cos(ang) sin(ang)] * Diagonal * avetor' + repmat(mean(PN), 360, 1);
line(elipse(:,1), elipse(:,2), 'linestyle', '-', 'color', 'k');


