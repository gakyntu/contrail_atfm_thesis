
close all
clc

bluey=0:0.1:1;
n=length(bluey);
contrail_map=[bluey' ones(n,2)];

% contrail_map=[0 1 1
%     0.1 1 1
%     0.2 1 1
%     0.3 1 1
%     0.4 1 1
%     0.5 1 1
%     0.6 1 1
%     0.7 1 1
%     0.8 1 1
%     0.9 1 1
%     1 1 1];

tau_max=2;

sigma_y=1;
%sigma_x=0.29;

t0=0;
tl=10000;

x0=0;
y0=0;
x1=-10;
x2=10;
y1=-10;
y2=10;

Ny=300;
y=linspace(-10,10,Ny);

x_step=10;
x=-10:x_step:10; % Mach 0.85 converted into km/s yields 0.29
Nx=length(x);
sigma_x=x(2)-x(1);

Nt=400;
t=linspace(0,Nt-1,Nt);

contrail_disp=exp(-(y'-y0).^2/(sigma_y^2))*exp(-(x-0).^2/(1e-2*sigma_y^2));

tau=@(u) tau_max*exp(-1*(u-t0)/(tl-t0))*contrail_disp;

tau_t=tau_max*exp(-5*(t-t0)/(tl-t0));

ultra_grid=cell(1,Nt);

speed=0.2; % km/s

for it=1:Nt

    if it<=Nx

            if it==1

                ultra_grid{it}=@(u) contrail(u,t(it),tl,x,x(it),y,y0,sigma_x,sigma_y,tau_max); %(u>=t(it)).*(u<=tl).*tau_max*(1-(u-t(it))/(tl-t(it)))*exp(-(y'-y0).^2/(sigma_y^2))*exp(-(x-x(it)).^2/(1e-2*sigma_y^2));

            else

                ultra_grid{it}=@(u) ultra_grid{it-1}(u)+contrail(u,t(it),tl,x,x(it),y,y0,sigma_x,sigma_y,tau_max);%(u>=t(it)).*(u<=tl).*tau_max*(1-(u-t(it))/(tl-t(it)))*exp(-(y'-y0).^2/(sigma_y^2))*exp(-(x-x(it)).^2/(1e-2*sigma_y^2));

            end

    else

        ultra_grid{it}=ultra_grid{it-1};

    end

end

pos0=[x;zeros(1,Nx);t(1:Nx)];
sx=0.1;
sy=sigma_y;
[xt,yt,t0,sigma_x,sigma_y]=trajectory(x1,0,1,x2,0,100,sx,sy);

tau_total=single_flight_optical_depth(xt,x1,x2,yt,y1,y2,t0,tl,t,tau_max,sigma_x,sigma_y);

for it=1:Nt

    f=figure(1);
    s=surf(x,y,ultra_grid{it}(t(it)));
    set(s,'LineStyle','none');
    view(2)
    colormap(contrail_map)
    clim([0 tau_max])
    xlim([min(x) max(x)])
    ylim([min(y) max(y)])
    xlabel('x (km)')
    ylabel('y (km)')

end

figure(2)
plot(t,tau_total)
grid on
xlabel('Time (s)')
ylabel('Dynamic Optical Depth')
title('Evolution of the dynamic optical depth for a single flight')

load('discrete0.mat')

figure(3)
plot(t./60,tau100,'Displayname','0.1 km','LineWidth',1.5)
hold on
grid on
plot(t./60,tau500,'Displayname','0.5 km','LineWidth',1.5)
plot(t./60,tau1000,'Displayname','1 km','LineWidth',1.5)
plot(t./60,tau5000,'Displayname','5 km','LineWidth',1.5)
plot(t./60,tau10000,'Displayname','10 km','LineWidth',1.5)
xlabel('Time (min)')
ylabel('Integrated Optical Thickness')
legend('Location','southeast')