function [tau] = single_flight_optical_depth(x,x_min,x_max,y,y_min,y_max,t0,tl,t,tau_max,sigma_x,sigma_y)

If=@(u) sum(0.25*tau_max*pi*abs(sigma_x*sigma_y)*(u>=t0).*(u-t0<=tl).*(1-(u-t0)/tl).*abs((erf((x_max-x)/sigma_x)-erf((x_min-x)/sigma_x)).*(erf((y_max-y)/sigma_y)-erf((y_min-y)/sigma_y))));

Nt=length(t);
tau=zeros(1,Nt);
for it=1:Nt
    tau(it)=If(t(it));
end

    

end