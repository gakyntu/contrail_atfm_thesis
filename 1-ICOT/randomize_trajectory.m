function [traj] = randomize_trajectory(x_min,x_max,y_min,y_max,t_min,t_max,direction,speed)

if ~exist('direction','var')
    direction='WE'; % Default direction is West to East
end
if ~exist('speed','var')
    speed=0.29; % Default speed is 0.29 m/s or Mach 0.85
end

traj=zeros(2,3);

avx=(x_min+x_max)/2;
avy=(y_min+y_max)/2;

if strcmp(direction,'WE')

    choice1=randi(3);
    if choice1==1
        traj(1,1)=x_min;
        u=rand;
        traj(1,2)=u*y_max+(1-u)*y_min;
    elseif choice1==2
        traj(1,2)=y_min;
        u=rand;
        traj(1,1)=u*avx+(1-u)*x_min;
    elseif choice1==3
        traj(1,2)=y_max;
        u=rand;
        traj(1,1)=u*avx+(1-u)*x_min;
    end
    traj(1,3)=t_min+randi(round((t_max+t_min)/2));

    choice2=randi(3);
    if choice2==2 && choice1==2
        v=round(rand);
        choice2=1+2*v;
    elseif choice2==3 && choice1==3
        choice2=randi(2);
    end
    if choice2==1
        traj(2,1)=x_max;
        u=rand;
        traj(2,2)=u*y_max+(1-u)*y_min;
    elseif choice2==2
        traj(2,2)=y_min;
        u=rand;
        traj(2,1)=u*x_max+(1-u)*avx;
    elseif choice2==3
        traj(2,2)=y_max;
        u=rand;
        traj(2,1)=u*x_max+(1-u)*avx;
    end

    dist=norm(traj(2,1:2)-traj(1,1:2));
    traj(2,3)=traj(1,3)+round(dist/speed);

elseif strcmp(direction,'EW')

    choice1=randi(3);
    if choice1==1
        traj(1,1)=x_max;
        u=rand;
        traj(1,2)=u*y_max+(1-u)*y_min;
    elseif choice1==2
        traj(1,2)=y_min;
        u=rand;
        traj(1,1)=u*x_max+(1-u)*avx;
    elseif choice1==3
        traj(1,2)=y_max;
        u=rand;
        traj(1,1)=u*x_max+(1-u)*avx;
    end
    traj(1,3)=t_min+randi(t_max-t_min);

    choice2=randi(3);
    if choice2==2 && choice1==2
        v=round(rand);
        choice2=1+2*v;
    elseif choice2==3 && choice1==3
        choice2=randi(2);
    end
    if choice2==1
        traj(2,1)=x_min;
        u=rand;
        traj(2,2)=u*y_max+(1-u)*y_min;
    elseif choice2==2
        traj(2,2)=y_min;
        u=rand;
        traj(2,1)=u*avx+(1-u)*x_min;
    elseif choice2==3
        traj(2,2)=y_max;
        u=rand;
        traj(2,1)=u*avx+(1-u)*x_min;
    end

    dist=norm(traj(2,1:2)-traj(1,1:2));
    traj(2,3)=traj(1,3)+round(dist/speed);

end



end
