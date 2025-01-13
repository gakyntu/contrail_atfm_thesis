clear all
close all
clc

z=0:500:55000;
ft_to_m=3281;
h=z./ft_to_m;
hm=1000*h;

%% Sonntag (1994) vapor saturation profiles

p_liq=@(T) 100*exp(-6096.9385./T + 16.635794 - 0.02711193.*T + 1.673952e-5.*T.^2 + 2.433502*log(T));
p_ice=@(T) 100*exp(-6024.5282./T + 24.7219 + 0.010613868.*T - 1.3198825e-5.*T.^2 - 0.49382577*log(T));

dp_liq=@(T) p_liq(T).*(6096.9385./T.^2 - 0.02711193 + 2*1.673952e-5.*T + 2.433502./T);

%% International Standard Atmosphere

T0=288.15;
p0=1013.25;
h11=11000;
p11=226.32;
T11=216.65;
rho0=7.5;
h0=2000;

T_ISA=(hm<=h11).*(T0-6.5*hm/1000)+T11.*(hm>h11);
p_ISA=(hm<=h11).*(p0*(1-0.0065*hm/T0).^(5.2561))+(hm>h11).*(p11*exp(-9.81*(hm-h11)/(287.04*T11)));
rho_ISA=rho0*exp(-hm/h0);
e_ISA=rho_ISA.*T_ISA/216.7;
U_ISA=100*e_ISA./p_liq(T_ISA);
RHi_ISA=100*e_ISA./p_ice(T_ISA);

%% International Telecommunications Union 

% Low-latitude (<22 deg) annual reference atmosphere

T_low=(h<=17).*(300.4222-6.3533.*h+0.005886.*h.^2) + (h>17).*(194+(h-17).*2.533);
p_low=(h<=10).*(1012.0306-109.0338.*h+3.6319.*h.^2) + (h>10).*(284.8526*exp(-0.147*(h-10)));
rho_low=(h<=15).*(19.6542*exp(-0.2313.*h-0.1122.*h.^2+0.01351.*h.^3-0.0005923.*h.^4));
e_low=rho_low.*T_low/216.7;
U_low=100*e_low./p_liq(T_low);
RHi_low=100*e_low./p_ice(T_low);

% Mid-latitude (between 22 deg and 45 deg) summer reference atmosphere

T_mid_summer=(h<=13).*(294.9838-5.2159.*h-0.07109.*h.^2) + (h>13).*(h<=17).*(215.15) + (h>17).*(215.15.*exp(0.008128*(h-17)));
p_mid_summer=(h<=10).*(1012.8186-111.5569.*h+3.8646.*h.^2) + (h>10).*(283.7096*exp(-0.147*(h-10)));
rho_mid_summer=(h<=15).*(14.3542*exp(-0.4174.*h-0.02290.*h.^2+0.001007.*h.^3));
e_mid_summer=rho_mid_summer.*T_mid_summer/216.7;
U_mid_summer=100*e_mid_summer./p_liq(T_mid_summer);
RHi_mid_summer=100*e_mid_summer./p_ice(T_mid_summer);

% Mid-latitude (between 22 deg and 45 deg) winter reference atmosphere

T_mid_winter=(h<=10).*(272.7241-3.6217.*h-0.1759.*h.^2) + (h>10).*(218);
p_mid_winter=(h<=10).*(1018.8627-124.2954.*h+4.8307.*h.^2) + (h>10).*(258.9787*exp(-0.147*(h-10)));
rho_mid_winter=(h<=10).*(3.4742*exp(-0.2697.*h-0.03604.*h.^2+0.0004489.*h.^3));
e_mid_winter=rho_mid_winter.*T_mid_winter/216.7;
U_mid_winter=100*e_mid_winter./p_liq(T_mid_winter);
RHi_mid_winter=100*e_mid_winter./p_ice(T_mid_winter);

% High-latitude (> 45 deg) summer reference atmosphere

T_high_summer=(h<=10).*(286.8374-4.7805.*h-0.1402.*h.^2) + (h>10).*(h<=23).*(225);
p_high_summer=(h<=10).*(1008.0278-113.2494.*h+3.9408.*h.^2) + (h>10).*(269.6138*exp(-0.140*(h-10)));
rho_high_summer=(h<=15).*(8.988*exp(-0.3614.*h-0.005402.*h.^2-0.001955.*h.^3));
e_high_summer=rho_high_summer.*T_high_summer/216.7;
U_high_summer=100*e_high_summer./p_liq(T_high_summer);
RHi_high_summer=100*e_high_summer./p_ice(T_high_summer);

% High-latitude (> 45 deg) winter reference atmosphere

T_high_winter=(h<=8.5).*(257.4345+2.3474.*h-1.5479.*h.^2+0.08473.*h.^3) + (h>8.5).*(217.5);
p_high_winter=(h<=10).*(1010.8828-122.2411.*h+4.554.*h.^2) + (h>10).*(243.8718*exp(-0.147*(h-10)));
rho_high_winter=(h<=10).*(1.2319*exp(0.07481.*h-0.0981.*h.^2+0.00281.*h.^3));
e_high_winter=rho_high_winter.*T_high_winter/216.7;
U_high_winter=100*e_high_winter./p_liq(T_high_winter);
RHi_high_winter=100*e_high_winter./p_ice(T_high_winter);


%% Figures

figure(1)
plot(T_ISA-273.15,z/100,'k-','DisplayName','ISA')
hold on
grid on
plot(T_low-273.15,z/100,'b-','DisplayName','Low-latitude Annual')
plot(T_mid_summer-273.15,z/100,'r-','DisplayName','Mid-latitude Summer')
plot(T_mid_winter-273.15,z/100,'r--','DisplayName','Mid-latitude Winter')
plot(T_high_summer-273.15,z/100,'m-','DisplayName','High-latitude Summer')
plot(T_high_winter-273.15,z/100,'m--','DisplayName','High-latitude Winter')
title('Temperature profiles')
xlabel('Temperature (C)')
ylabel('Flight Level (FL)')
legend('location','northeast')

figure(2)
plot(p_ISA,z/100,'k-','DisplayName','ISA')
hold on
grid on
plot(p_low,z/100,'b-','DisplayName','Low-latitude Annual')
plot(p_mid_summer,z/100,'r-','DisplayName','Mid-latitude Summer')
plot(p_mid_winter,z/100,'r--','DisplayName','Mid-latitude Winter')
plot(p_high_summer,z/100,'m-','DisplayName','High-latitude Summer')
plot(p_high_winter,z/100,'m--','DisplayName','High-latitude Winter')
title('Pressure profiles')
xlabel('Pressure (hPa)')
ylabel('Flight Level (FL)')
legend('location','northeast')

figure(3)
plot(U_ISA*100,z/100,'k-','DisplayName','ISA')
hold on
grid on
plot(U_low*100,z/100,'b-','DisplayName','Low-latitude Annual')
plot(U_mid_summer*100,z/100,'r-','DisplayName','Mid-latitude Summer')
plot(U_mid_winter*100,z/100,'r--','DisplayName','Mid-latitude Winter')
plot(U_high_summer*100,z/100,'m-','DisplayName','High-latitude Summer')
plot(U_high_winter*100,z/100,'m--','DisplayName','High-latitude Winter')
title('Relative Humidity profiles')
xlabel('Relative Humidity (%)')
ylabel('Flight Level (FL)')
legend('location','northeast')

figure(4)
plot(RHi_ISA*100,z/100,'k-','DisplayName','ISA')
hold on
grid on
plot(RHi_low*100,z/100,'b-','DisplayName','Low-latitude Annual')
plot(RHi_mid_summer*100,z/100,'r-','DisplayName','Mid-latitude Summer')
plot(RHi_mid_winter*100,z/100,'r--','DisplayName','Mid-latitude Winter')
plot(RHi_high_summer*100,z/100,'m-','DisplayName','High-latitude Summer')
plot(RHi_high_winter*100,z/100,'m--','DisplayName','High-latitude Winter')
title('Relative Humidity over ice profiles')
xlabel('Relative Humidity (%)')
ylabel('Flight Level (FL)')
legend('location','northeast')

figure(5)
plot(e_ISA,z/100,'k-','DisplayName','ISA')
hold on
grid on
plot(e_low,z/100,'b-','DisplayName','Low-latitude Annual')
plot(e_mid_summer,z/100,'r-','DisplayName','Mid-latitude Summer')
plot(e_mid_winter,z/100,'r--','DisplayName','Mid-latitude Winter')
plot(e_high_summer,z/100,'m-','DisplayName','High-latitude Summer')
plot(e_high_winter,z/100,'m--','DisplayName','High-latitude Winter')
title('Water Vapour Pressure profiles')
xlabel('Pressure (hPa)')
ylabel('Flight Level (FL)')
legend('location','northeast')

figure(6)
plot(T_ISA-273.15,p_liq(T_ISA),'b-','DisplayName','Liquid Saturation')
hold on
grid minor
plot(T_ISA-273.15,p_ice(T_ISA),'b--','DisplayName','Ice Saturation')
plot(T_ISA-273.15,100*e_ISA,'k','DisplayName','ISA')
xlabel('Temperature (C)')
ylabel('Pressure (Pa)')

figure(7)
plot(p_liq(T_ISA),z/100,'b-','DisplayName','Liquid Saturation')
hold on
grid minor
plot(p_ice(T_ISA),z/100,'b--','DisplayName','Ice Saturation')
plot(100*e_ISA,z/100,'k','DisplayName','ISA')
ylabel('Flight Level (FL)')
%xlim([-60 0])
%ylim([0 1000])
xlabel('Pressure (Pa)')

n=length(z);

tau_ISA=zeros(n,n);
tau_low=zeros(n,n);
tau_mid_summer=zeros(n,n);
tau_mid_winter=zeros(n,n);
tau_high_summer=zeros(n,n);
tau_high_winter=zeros(n,n);

G_ISA=dp_liq(T_ISA);
G_low=dp_liq(T_low);
G_mid_summer=dp_liq(T_mid_summer);
G_mid_winter=dp_liq(T_mid_winter);
G_high_summer=dp_liq(T_high_summer);
G_high_winter=dp_liq(T_high_winter);

Gm_ISA=zeros(1,n);
Gm_low=zeros(1,n);
Gm_mid_summer=zeros(1,n);
Gm_mid_winter=zeros(1,n);
Gm_high_summer=zeros(1,n);
Gm_high_winter=zeros(1,n);

cp=1004;
eps=0.622;

for ih=1:n
    
    tau_ISA(ih,:)=(T_ISA>T_ISA(ih)).*(p_liq(T_ISA)-e_ISA(ih))./(T_ISA-T_ISA(ih));
    tau_low(ih,:)=(T_low>T_low(ih)).*(p_liq(T_low)-e_low(ih))./(T_low-T_low(ih));
    tau_mid_summer(ih,:)=(T_mid_summer>T_mid_summer(ih)).*(p_liq(T_mid_summer)-e_mid_summer(ih))./(T_mid_summer-T_mid_summer(ih));
    tau_mid_winter(ih,:)=(T_mid_winter>T_mid_winter(ih)).*(p_liq(T_mid_winter)-e_mid_winter(ih))./(T_mid_winter-T_mid_winter(ih));
    tau_high_summer(ih,:)=(T_high_summer>T_high_summer(ih)).*(p_liq(T_high_summer)-e_high_summer(ih))./(T_high_summer-T_high_summer(ih));
    tau_high_winter(ih,:)=(T_high_winter>T_high_winter(ih)).*(p_liq(T_high_winter)-e_high_winter(ih))./(T_high_winter-T_high_winter(ih));
    
    [dG,iG_ISA]=min(abs((T_ISA>T_ISA(ih)).*(G_ISA-tau_ISA(ih,:))));
    [dG,iG_low]=min(abs((T_low>T_low(ih)).*(G_low-tau_low(ih,:))));
    [dG,iG_mid_summer]=min(abs((T_mid_summer>T_mid_summer(ih)).*(G_mid_summer-tau_mid_summer(ih,:))));
    [dG,iG_mid_winter]=min(abs((T_mid_winter>T_mid_winter(ih)).*(G_mid_winter-tau_mid_winter(ih,:))));
    [dG,iG_high_summer]=min(abs((T_high_summer>T_high_summer(ih)).*(G_high_summer-tau_high_summer(ih,:))));
    [dG,iG_high_winter]=min(abs((T_high_winter>T_high_winter(ih)).*(G_high_winter-tau_high_winter(ih,:))));

    Gm_ISA(ih)=G_ISA(iG_ISA)*eps/(cp*100*p_ISA(ih));
    Gm_low(ih)=G_low(iG_low)*eps/(cp*100*p_low(ih));
    Gm_mid_summer(ih)=G_mid_summer(iG_mid_summer)*eps/(cp*100*p_mid_summer(ih));
    Gm_mid_winter(ih)=G_mid_winter(iG_mid_winter)*eps/(cp*100*p_mid_winter(ih));
    Gm_high_summer(ih)=G_high_summer(iG_high_summer)*eps/(cp*100*p_high_summer(ih));
    Gm_high_winter(ih)=G_high_winter(iG_high_winter)*eps/(cp*100*p_high_winter(ih));

end

figure(8)
plot(Gm_ISA,z/100,'k-','DisplayName','ISA')
hold on
grid minor
plot(Gm_low,z/100,'b-','DisplayName','Low-latitude Annual')
plot(Gm_mid_summer,z/100,'r-','DisplayName','Mid-latitude Summer')
plot(Gm_mid_winter,z/100,'r--','DisplayName','Mid-latitude Winter')
plot(Gm_high_summer,z/100,'m-','DisplayName','High-latitude Summer')
plot(Gm_high_winter,z/100,'m--','DisplayName','High-latitude Winter')
title('Thresholds for the reduced slope of the mixing line')
xlabel('$G^*=\frac{EI_{H_2 O}}{Q(1-\eta)}=\frac{\dot{m_F}EI_{H_2 O}}{\dot{m_F}Q-FV}$','Interpreter','latex')
ylabel('Flight Level (FL)')
legend('location','northeast')