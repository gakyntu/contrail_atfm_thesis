function [x,y,t,sigma_x,sigma_y] = trajectory(x1,y1,t1,x2,y2,t2,sx,sy)

dir=[x2-x1 y2-y1];
dist=norm(dir);
dir=dir/dist;

speed=dist/(t2-t1);
theta=acos(dir(1));

% vx=cos(theta)*speed;
% vy=sin(theta)*speed;

if x1>x2
    x=x2:sx:x1;
    x=flip(x);
else
    x=x1:sx:x2;
end
Nx=length(x);
if y1>y2
    y=linspace(y2,y1,Nx);
    y=flip(y);
else
    y=linspace(y1,y2,Nx);
end
t=linspace(t1,t2,Nx);

sigma_x=cos(theta)*sx-sin(theta)*sy;
sigma_y=sin(theta)*sx+cos(theta)*sy;

end
