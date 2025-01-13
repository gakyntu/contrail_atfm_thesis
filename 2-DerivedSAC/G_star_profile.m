function [G_star] = G_star_profile(phi,N,z)

% z in FL (ft/100), phi in deg, N in number of days since Jan-01

delta=tanh(N-78)-tanh(N-265)-1;
t_morph_summer=delta;
t_morph_winter=-delta;

phi_morph_mid=0.5.*tanh(phi+22).*tanh(phi+45)-0.5*tanh(phi-22).*tanh(phi-45);
phi_morph_high=0.5.*tanh((phi+45))+0.5.*tanh((phi-45));
phi_morph_low=0.5-0.5.*tanh(phi+22).*tanh(phi-22);

f1=(ones(length(N),1)*phi_morph_low)';
f2=heaviside((t_morph_summer'*phi_morph_mid)').*(t_morph_summer'*phi_morph_mid)';
f3=heaviside((t_morph_winter'*phi_morph_mid)').*(t_morph_winter'*phi_morph_mid)';
f4=heaviside((t_morph_summer'*phi_morph_high)').*(t_morph_summer'*phi_morph_high)';
f5=heaviside((t_morph_winter'*phi_morph_high)').*(t_morph_winter'*phi_morph_high)';

G_star=f1.*G_star_standard_atmosphere(z,'Low-Latitude Annual')+f2.*G_star_standard_atmosphere(z,'Mid-Latitude Summer')+f3.*G_star_standard_atmosphere(z,'Mid-Latitude Winter')+f4.*G_star_standard_atmosphere(z,'High-Latitude Summer')+f5.*G_star_standard_atmosphere(z,'High-Latitude Winter');


end
