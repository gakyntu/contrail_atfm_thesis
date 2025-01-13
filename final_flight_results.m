clear all
close all
clc

t_min=0;
t_max=20000;

t=t_min:1:t_max;
Nt=length(t);

load flights.mat

figure(1)
plot(t./3600,tau2,'Displayname','2 Flights','LineWidth',1.5)
hold on
grid on
plot(t./3600,tau5,'Displayname','5 Flights','LineWidth',1.5)
plot(t./3600,tau10,'Displayname','10 Flights','LineWidth',1.5)
plot(t./3600,tau50,'Displayname','50 Flights','LineWidth',1.5)
xlabel('Time (h)')
ylabel('ICOT')
legend

load('discrete.mat')

figure(2)
plot(t./60,tau100,'Displayname','0.1 km','LineWidth',1.5)
hold on
grid on
plot(t./60,tau500,'Displayname','0.5 km','LineWidth',1.5)
plot(t./60,tau1000,'Displayname','1 km','LineWidth',1.5)
plot(t./60,tau5000,'Displayname','5 km','LineWidth',1.5)
plot(t./60,tau10000,'Displayname','10 km','LineWidth',1.5)
xlabel('Time (min)')
ylabel('Integarted Optical Thickness')
legend