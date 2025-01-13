function [rho] = vapour_density_standard_atmosphere(h,status)

% altitude h is to be expressed in km

switch status

    case 'ISA'

        rho0=7.5;
        h0=2;
        rho=rho0*exp(-h/h0);

    case 'High-Latitude Summer'

        rho=(h<=15).*(8.988*exp(-0.3614.*h-0.005402.*h.^2-0.001955.*h.^3));

    case 'High-Latitude Winter'

        rho=(h<=10).*(1.2319*exp(0.07481.*h-0.0981.*h.^2+0.00281.*h.^3));

    case 'Mid-Latitude Summer'

        rho=(h<=15).*(14.3542*exp(-0.4174.*h-0.02290.*h.^2+0.001007.*h.^3));

    case 'Mid-Latitude Winter'

        rho=(h<=10).*(3.4742*exp(-0.2697.*h-0.03604.*h.^2+0.0004489.*h.^3));

    case 'Low-Latitude Annual'

        rho=(h<=15).*(19.6542*exp(-0.2313.*h-0.1122.*h.^2+0.01351.*h.^3-0.0005923.*h.^4));

end
        

end