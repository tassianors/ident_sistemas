%====================================
% Identificacao de sistemas
% Tassiano Neuhaus
% tassianors@gmail.com
% UFRGS
%====================================
close all; clear all;

% LOAD DATA
data_in_4
data_out_4

% Defines
% Number or unknown variables to be determined by this method
n=3;
step_size=1700;
N=0;
j=1;

% Total number of points collected
Ntot=size(input, 1);

while N+step_size <= Ntot
    % load partial number of points
    y=output(N+1:N+step_size,1);
    u=input(N+1:N+step_size,1);

    phy=zeros(step_size, n);
    z=zeros(step_size, n);
    for t=3:step_size
        phy(t, 1)=u(t-2);
        phy(t, 2)=y(t-1);
        phy(t, 3)=y(t-2);
    end
    for t=4:step_size
        % auxiliary instrument z
        z(t, 3)=u(t-1);
        z(t, 2)=u(t-2);
        z(t, 1)=u(t-3);
    end

    teta=inv(z'*phy)*z'*y;
    % to be used in graphic plotting
    a(j)=teta(1);
    b(j)=-teta(3);
    c(j)=teta(2)-b(j);
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
title('Estimativa usando o metodo das variaveis instrumentais. Ref onda quadrada, N=150')
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
