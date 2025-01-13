function [tau] = contrail(t,t0,tl,x,x0,y,y0,sigma_x,sigma_y,tau_max)

tau=tau_max*(t>=t0)*(t<=tl)*(1-(t-t0)/(tl))*exp(-(y'-y0).^2/sigma_y^2)*(x<=x0).*exp(-(x-x0).^2/sigma_x^2);

end
