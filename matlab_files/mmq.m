%====================================
% Identificacao de sistemas
% Tassiano Neuhaus
% tassianors@gmail.com
% UFRGS
%====================================
close all; clear all;

% Escolhido ao acaso.
a=1;
b=0.9;
Ts=1/100;
Tf=1;
% sistema em estudo
G=tf([a],[1 b],Ts);
% u
tempo = 0:Ts:Tf;
%u = randn(size(tempo));
[u1,T] = gensig('sin',1/10,Tf,Ts);
[u2,T] = gensig('sin',2/10,Tf,Ts);
[u3,T] = gensig('sin',4/10,Tf,Ts);
u=u1+u2+u3;
ynr=lsim(G, u, tempo);

% faz com que o ruido seja alterado cada vez que o randn for executado
RandStream.setDefaultStream( RandStream('mt19937ar', 'seed', sum(100*clock)));

% identificacao por MMQ
% modelo y(t)=a*u(t-1)-b*y(t-1)
teta=[a; b];
% e entrada u saida do controlador
%phy=[u(t-1); -y(t-1)]
N=size(tempo,2);
n=size(teta, 1);
% numero de vezes que sera aplicado o metodo.
M=10;
tetaM=zeros(M, n);

for j=1:M
    noise=randn(size(tempo));
    % 5% of noise into the signal
    y=ynr+noise'*0.55*0.1; 
    figure(j);stem(y);

    phy=zeros(N, n);
    for t=2:N
        phy(t, 1)=u(t-1);
        phy(t, 2)=-y(t-1);
    end

    % make sure, rank(phy) = n :)
    teta_r=inv(phy'*phy)*phy'*y;
    tetaM(j,1)=teta_r(1);
    tetaM(j,2)=teta_r(2);
 end

tetaM
mean(tetaM)
std(tetaM)
