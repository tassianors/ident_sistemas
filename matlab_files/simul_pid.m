%====================================
% Identificacao de sistemas
% Tassiano Neuhaus
% tassianors@gmail.com
% UFRGS
%====================================
close all; clear all;

% LOAD DATA
data7

% Defines
% Number or unknown variables to be determined by this method
n=4;
step_size=150;
N=0;
j=1;

% Total number of points colected
Ntot=size(value, 1);

while N+step_size <= Ntot
    % load partial number of points
    y=value(N+1:N+step_size,1);
    u=value(N+1:N+step_size,2);

    phy=zeros(step_size, n);
    z=zeros(step_size, n);
    for t=3:step_size
        phy(t, 1)=u(t-1);
        phy(t, 2)=u(t-2);
        phy(t, 3)=y(t-1);
        phy(t, 4)=y(t-2);
    end
    
    % make sure, rank(phy) = n :)
    teta=inv(phy'*phy)*phy'*y;
    % to be used in grafic ploting
    a(j)=teta(1)/5;
    b(j)=-teta(4);
    c(j)=teta(3)-b(j);
    j=j+1;
    N=N+step_size;
end

PN=[a', b'];
ma=mean(a)
mb=mean(b)
mc=mean(c)

% from here is only to plot the estimated points
plot(a, b, 'bo');
hold;
plot(ma, mb, 'rx');
hold;
title('Estimativa usando o metodo dos min quadrados. Ref rampa, N=150')
xlabel('Valor da estimativa para a variavel a')
ylabel('Valor da estimativa para a variavel b')
legend('Estimativas', 'Media')

% chi^2 for 95% of confiability
chi = 5.991;
ang = linspace(0,2*pi,360)';
[avetor,SCR,avl] = princomp(PN);
Diagonal= diag(sqrt(chi*avl));
elipse=[cos(ang) sin(ang)] * Diagonal * avetor' + repmat(mean(PN), 360, 1);
line(elipse(:,1), elipse(:,2), 'linestyle', '-', 'color', 'k');
