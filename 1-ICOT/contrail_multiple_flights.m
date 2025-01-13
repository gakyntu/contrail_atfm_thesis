clear all
close all
clc

bluey=0:0.1:1;
n=length(bluey);
contrail_map=[bluey' ones(n,2)];

tau_max=2;

x_min=-10;
x_max=10;
y_min=-10;
y_max=10;

t_min=0;
t_max=20000;

t=t_min:1:t_max;
Nt=length(t);

direction='WE';
speed=0.29;

Nf=40;

flp=zeros(2,3,Nf);

sy=1;
sx=10;

tl=10000;

x=cell(1,Nf);
y=cell(1,Nf);
t0=cell(1,Nf);
sigma_x=zeros(1,Nf);
sigma_y=zeros(1,Nf);

for ifl=1:Nf
    flp(:,:,ifl)=randomize_trajectory(x_min,x_max,y_min,y_max,t_min,t_max,direction,speed);
    [x{ifl},y{ifl},t0{ifl},sigma_x(ifl),sigma_y(ifl)]=trajectory(flp(1,1,ifl),flp(1,2,ifl),flp(1,3,ifl),flp(2,1,ifl),flp(2,2,ifl),flp(2,3,ifl),sx,sy);
end

xd=linspace(x_min,x_max);
yd=linspace(y_min,y_max);

speed=0.2; % km/s
step=zeros(1,Nf);
tau_total=zeros(1,Nt);

for ifl=1:Nf

    tau_total=tau_total+single_flight_optical_depth(x{ifl},flp(1,1,ifl),flp(2,1,ifl),y{ifl},flp(1,2,ifl),flp(2,2,ifl),t0{ifl},tl,t,tau_max,sigma_x(ifl),sigma_y(ifl));

end

figure(1)
plot(t./3600,tau_total)
grid minor
xlabel('Time (h)')
ylabel('ICOT')
title(['Evolution of the ICOT for ',num2str(Nf), ' flights'])
