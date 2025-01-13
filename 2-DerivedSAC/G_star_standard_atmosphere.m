function [G] = G_star_standard_atmosphere(z,status)

% altitude z is to be expressed in FL (ft/100)

switch status

    case 'ISA'

        G=(z<=360).*exp(-14.22-0.007716*z-6.984e-6*z.^2-1.12e-8*z.^3)+(z>360).*exp(-19.21+0.004808*z);

    case 'High-Latitude Summer'

        G=(z<=330).*exp(-14.28-0.005373*z-5.001e-6*z.^2-3.217e-8*z.^3)+(z>330).*exp(-18.17+0.004267*z);

    case 'High-Latitude Winter'

        G=(z<=280).*exp(-16.27+0.01011*z-0.0001079*z.^2+1.473e-7*z.^3)+(z>280).*exp(-18.91+0.004453*z);

    case 'Mid-Latitude Summer'

        G=(z<=430).*exp(-13.84-0.005372*z-4.085e-6*z.^2-1.958e-8*z.^3)+(z>430).*exp(-19.33+0.00448*z);

    case 'Mid-Latitude Winter'

        G=(z<=330).*exp(-15.15-0.00405*z-4.164e-6*z.^2-3.942e-8*z.^3)+(z>330).*exp(-18.92+0.00448*z);

    case 'Low-Latitude Annual'

        G=(z<=560).*exp(-13.56-0.0068*z-3.083e-6*z.^2-1.223e-8*z.^3);

end


end
