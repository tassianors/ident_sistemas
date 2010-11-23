%====================================
% Identificacao de sistemas
% Tassiano Neuhaus
% tassianors@gmail.com
% UFRGS
%====================================
close all; clear all;

% Definitions
Ts=1e-3;
% frequency used when u(t) is a sinusoidal signal.
freq=pi/20;

Tf=1*2*pi/freq;

STD=0.1;
tempo = 0:Ts:Tf;
N=size(tempo, 2);

M=100;

% TFs
G=tf([2],[1 -0.8], Ts);
% item 1 e 2
%H=tf([1 0],[1 -0.8], Ts);
H=tf([1 0.9],[1 -0.5], Ts);

% Replace the default stream with a stream whose seed is based on CLOCK, so
% RAND will return different values in different MATLAB sessions
RandStream.setDefaultStream( RandStream('mt19937ar', 'seed', sum(100*clock)));

% identification using MMQ
% model y(t)=2*u(t-1)+0.8*y(t-1) +u(t) +0.8*y(t-1)
teta=[2; 0.8; 0.5; 0.9; 1; 1];
n=size(teta, 1);
% e entrada u saida do controlador
%phy=[ u(t-1); y(t-1)]

% numero de vezes que sera aplicado o metodo.
t1=zeros(M,1);
t2=zeros(M,1);
t3=zeros(M,1);
t4=zeros(M,1);
t5=zeros(M,1);
t6=zeros(M,1);
ychap=zeros(M,1);
a=zeros(M,1);
b=zeros(M,1);
c=zeros(M,1);
d=zeros(M,1);
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
    % now rr has std=1nusoidal input signal
    rr=(ran-m)/s;
    %sim
%     rr=sin(freq*tempo);
    
    yr=lsim(G, rr, tempo);
    ynoise=lsim(H, rh, tempo);
    y=yr+ynoise;
    u=rr;
    
    if j==1 
        phy=zeros(N, n-2);
    else
        phy=zeros(N, n);
    end
 j
    for t=3:N
        phy(t, 1)=u(t-1);
        phy(t, 2)=-u(t-2);
        phy(t, 3)=y(t-1);
        phy(t, 4)=-y(t-2);
        if j~=1
            ychap(t)=t1(j-1)*u(t-1) -t2(j-1)*u(t-2) +t3(j-1)*y(t-1) -t4(j-1)*y(t-2) +t5(j-1)*ychap(t-1) -t6(j-1)*ychap(t-2);
            phy(t, 5)=ychap(t-1);
            phy(t, 6)=-ychap(t-2);
        end
    end

    % make sure, rank(phy) = n :)
    teta_r=inv(phy'*phy)*phy'*y;
    % to be used in grafic plot
    t1(j)=teta_r(1);
    t2(j)=teta_r(2);
    t3(j)=teta_r(3);
    t4(j)=teta_r(4);
    if j~= 1
        t5(j)=teta_r(5);
        t6(j)=teta_r(6);
    end
    a(j)=t1(j);
    d(j)=t2(j)/t1(j);
    c(j)=-t3(j)+d(j);
    b(j)=t4(j)/t3(j);
end
PN=[a, b];
ma=mean(a)
mb=mean(b)
mc=mean(c)
md=mean(d)
me=mean(t5)
mf=mean(t6)

plot(a, b, 'bo');
hold;
plot(ma, mb, 'rx');
hold;
title('Simulacao do sistema - estimativa dos parametros a e b')
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

figure(2);
plot(c, d, 'bo');
hold;
plot(mc, md, 'rx');
hold;
title('Simulacao do sistema - estimativa dos parametros c e d - Ruido')
xlabel('Valor da estimativa para a variavel d')
ylabel('Valor da estimativa para a variavel c')
legend('Estimativas', 'Media')

%valor da tabela chi-quadrado para 95% de confianca
chi = 5.991;
ang = linspace(0,2*pi,360)';
[avetor,SCR,avl] = princomp([c, d]);
Diagonal= diag(sqrt(chi*avl));
elipse=[cos(ang) sin(ang)] * Diagonal * avetor' + repmat(mean([c, d]), 360, 1);
line(elipse(:,1), elipse(:,2), 'linestyle', '-', 'color', 'k');