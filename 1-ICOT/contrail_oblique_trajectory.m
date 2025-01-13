
close all
clc

bluey=0:0.1:1;
n=length(bluey);
contrail_map=[bluey' ones(n,2)];

tau_max=2;

sy=1;
sx=0.1;

t0=0;
tl=10000;

x_min=-10;
x_max=10;
y_min=-10;
y_max=10;

x1=-10;
y1=-6;
t1=10;
x2=10;
y2=2;
t2=90;

[x,y,t0,sigma_x,sigma_y]=trajectory(x1,y1,t1,x2,y2,t2,sx,sy);

N=length(x);

t=0:1:400;
Nt=length(t);

xd=linspace(x_min,x_max,N);
yd=linspace(y_min,y_max,N);

[Xd,Yd]=meshgrid(xd,yd);
[Xt,Yt]=meshgrid(x,y);

ultra_grid=cell(1,Nt);

Xall = [Xd; Xt];
Yall = [Yd; Yt];

speed=0.2; % km/s
step=0;

for it=1:Nt

    if t(it)<t1

        ultra_grid{it}=@(u,v,w) u.*v.*w.*zeros(size(Xt));

    elseif t(it)>=t1 && t(it)<=t2

        if t(it)==t1
            step=it;
        end
        ultra_grid{it}=@(u,v,w) ultra_grid{it-1}(u,v,w)+contrail(u,t0(it-step+1),tl,v,x(it-step+1),w,y(it-step+1),sigma_x,sigma_y,tau_max);%(u>=t(it)).*(u<=tl).*tau_max*(1-(u-t(it))/(tl-t(it)))*exp(-(y'-y0).^2/(sigma_y^2))*exp(-(x-x(it)).^2/(1e-2*sigma_y^2));

    elseif t(it)>t2

        ultra_grid{it}=ultra_grid{it-1};

    end

end

pos0=[x;y;t0];

If=@(u) sum(0.25*tau_max*pi*sigma_x*sigma_y*(u>=pos0(3,:)).*(1-(u-pos0(3,:))/tl).*(erf((x2-pos0(1,:))/sigma_x)-erf((x1-pos0(1,:))/sigma_x)).*(erf((y2-pos0(2,:))/sigma_y)-erf((y1-pos0(2,:))/sigma_y)));

tau_total=zeros(1,Nt);
for it=1:Nt
    tau_total(it)=If(t(it));
end

tau_total=single_flight_optical_depth(x,x1,x2,y,y1,y2,t0,tl,t,tau_max,sigma_x,sigma_y);

for it=1:Nt

    f=figure(1);
    s=surf(Xd,Yd,ultra_grid{it}(t(it),xd,yd));
    hold on 
    surf(Xd,Yd,zeros(size(Xd)),'EdgeColor','none')
    hold off
    set(s,'LineStyle','none');
    %     hold on
    %     plot3(xf(it),y0,tau_max,'ob','MarkerSize',15)
    %     hold off
    view(2)
    colormap(contrail_map)
    %colormap(f, flipud(colormap(f)))
    clim([0 tau_max])
    xlim([x_min x_max])
    ylim([y_min y_max])
    xlabel('x (km)')
    ylabel('y (km)')

    % frame = getframe(gcf);
    % img =  frame2im(frame);
    % [img,cmap] = rgb2ind(img,256);
    % if it == 1
    %     imwrite(img,cmap,'contrail.gif','gif','LoopCount',Inf,'DelayTime',0.01);
    % else
    %     imwrite(img,cmap,'contrail.gif','gif','WriteMode','append','DelayTime',0.01);
    % end

end

figure(2)
plot(t./60,tau_total)
grid on
xlabel('Time (min)')
ylabel('Dynamic Optical Depth')
title('Evolution of the dynamic optical depth for a single flight')

