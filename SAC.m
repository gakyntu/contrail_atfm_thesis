clear all
close all
clc

clear all
close all
clc

%% Sonntag (1994) vapor saturation profiles

p_liq=@(T) 100*exp(-6096.9385./T + 16.635794 - 0.02711193.*T + 1.673952e-5.*T.^2 + 2.433502*log(T));
p_ice=@(T) 100*exp(-6024.5282./T + 24.7219 + 0.010613868.*T - 1.3198825e-5.*T.^2 - 0.49382577*log(T));

dp_liq=@(T) p_liq(T).*(6096.9385./T.^2 - 0.02711193 + 2*1.673952e-5.*T + 2.433502./T);

T=linspace(150,300,150);

figure(1)
subplot(1,3,1)
plot(T-273,p_liq(T),'-b','DisplayName','Liquid')
hold on
plot(T-273,p_ice(T),'--b','DisplayName','Ice')
grid minor
xlim([-60 -20])
legend('Location','northwest')
xlabel('Temperature (C)')
ylabel('Saturation Water Vapour Pressure (Pa)')

Tp=-20;
Pp=80;

Te=-53;
Pe=0;

T1=linspace(Te,Tp);
P1=linspace(Pe,Pp);

plot(T1,P1,'-r','DisplayName','Mixing Line')
hold on
text(Te+3,5,'(T_e , e_e )','Color','red')
text(-34,Pp,'(T_p , e_p )','Color','red')
plot(Te,Pe,'*r','LineWidth',2,'HandleVisibility','off')
plot(Tp,Pp,'*r','LineWidth',2,'HandleVisibility','off')
title('(a) Contrail forms but will not persist')

subplot(1,3,2)
plot(T-273,p_liq(T),'-b','DisplayName','Liquid')
hold on
plot(T-273,p_ice(T),'--b','DisplayName','Ice')
grid minor
xlim([-60 -20])
legend('Location','northwest')
xlabel('Temperature (C)')
ylabel('Saturation Water Vapour Pressure (Pa)')

Tp=-20;
Pp=90;

Te=-44;
Pe=10;

T2=linspace(Te,Tp);
P2=linspace(Pe,Pp);

plot(T2,P2,'-r','DisplayName','Mixing Line')
hold on
text(Te+1,10,'(T_e , e_e )','Color','red')
text(-34,Pp,'(T_p , e_p )','Color','red')
plot(Te,Pe,'*r','LineWidth',2,'HandleVisibility','off')
plot(Tp,Pp,'*r','LineWidth',2,'HandleVisibility','off')
title('(b) Contrail forms and will persist')

subplot(1,3,3)
plot(T-273,p_liq(T),'-b','DisplayName','Liquid')
hold on
plot(T-273,p_ice(T),'--b','DisplayName','Ice')
grid minor
xlim([-60 -20])
legend('Location','northwest')
xlabel('Temperature (C)')
ylabel('Saturation Water Vapour Pressure (Pa)')

Tp=-20;
Pp=70;

Te=-36;
Pe=5;

T3=linspace(Te,Tp);
P3=linspace(Pe,Pp);

plot(T3,P3,'-r','DisplayName','Mixing Line')
hold on
text(Te+2,5,'(T_e , e_e )','Color','red')
text(-34,Pp,'(T_p , e_p )','Color','red')
plot(Te,Pe,'*r','LineWidth',2,'HandleVisibility','off')
plot(Tp,Pp,'*r','LineWidth',2,'HandleVisibility','off')
title('(c) Contrail will nether form nor persist')


