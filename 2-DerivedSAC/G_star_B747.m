clear all
close all
clc

z=0:100:55000;
ft_to_km=3281;
h=z./ft_to_km;
z_FL=z./100;
nz=length(z);
standards={'ISA','Low-Latitude Annual','Mid-Latitude Summer','Mid-Latitude Winter','High-Latitude Summer','High-Latitude Winter'};
ns=length(standards);

%% Sonntag (1994) vapor saturation profiles

p_liq=@(T) 100*exp(-6096.9385./T + 16.635794 - 0.02711193.*T + 1.673952e-5.*T.^2 + 2.433502*log(T));
p_ice=@(T) 100*exp(-6024.5282./T + 24.7219 + 0.010613868.*T - 1.3198825e-5.*T.^2 - 0.49382577*log(T));

dp_liq=@(T) p_liq(T).*(6096.9385./T.^2 - 0.02711193 + 2*1.673952e-5.*T + 2.433502./T);

%% Standard Atmospheres

N_in='13-11';
N_in=datenum(N_in,'dd-mm');
phi=+51;
DateString = '01-Jan-2023';
formatIn = 'dd-mmm-yyyy';
N_date=datenum(DateString,formatIn);
N=N_in-N_date;
N_str=datetime(N_date+N, 'ConvertFrom', 'datenum', 'Format', 'dd-MMM');

if phi>=0
    phi_str=[num2str(phi),'N'];
else
    phi_str=[num2str(-phi),'S'];
end

G=G_star_profile(phi,N,z_FL);
G_ISA=G_star_standard_atmosphere(z_FL,'ISA');
G_title=append('Contrail formation altitudes for a B747 located at ',phi_str,', dated ',string(N_str));

EI_H2O=[1.25 2.24 8.94];
Q=[43 50 120]*1e6;
eta=0.308;

G_B747=EI_H2O./(Q*(1-eta));

G_plot=ones(nz,1)*G_B747;


figure(1)
plot(G,z_FL,'r-','LineWidth',1.5,'DisplayName','G profile ITU')
grid on
hold on
plot(G_ISA,z_FL,'k-','LineWidth',1.5,'DisplayName','G profile ISA')
plot(G_plot(:,1),z_FL,'k--','LineWidth',1.5,'DisplayName','Kerosene')
plot(G_plot(:,2),z_FL,'b--','LineWidth',1.5,'DisplayName','Methane')
plot(G_plot(:,3),z_FL,'m--','LineWidth',1.5,'DisplayName','Hydrogen')
title(G_title)
xlabel('$G^*=\frac{EI_{H_2 O}}{Q(1-\eta)}=\frac{\dot{m_F}EI_{H_2 O}}{\dot{m_F}Q-FV}$','Interpreter','latex')
ylabel('Flight Level (FL)')
legend('Location','northeast')
xlim([0 1.4e-7])
ylim([0 550])

a=-1.223e-8;
b=-3.083e-6;
c=-0.0068;
d=-13.56-log(G_B747);

[z1,z2,z3]=roots_poly3(a,b,c,d);
