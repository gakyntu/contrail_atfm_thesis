clear all
close all
clc

z=0:100:55000;
ft_to_km=3281;
h=z./ft_to_km;
nz=length(z);
standards={'ISA','Low-Latitude Annual','Mid-Latitude Summer','Mid-Latitude Winter','High-Latitude Summer','High-Latitude Winter'};
ns=length(standards);

%% Sonntag (1994) vapor saturation profiles

p_liq=@(T) 100*exp(-6096.9385./T + 16.635794 - 0.02711193.*T + 1.673952e-5.*T.^2 + 2.433502*log(T));
p_ice=@(T) 100*exp(-6024.5282./T + 24.7219 + 0.010613868.*T - 1.3198825e-5.*T.^2 - 0.49382577*log(T));

dp_liq=@(T) p_liq(T).*(6096.9385./T.^2 - 0.02711193 + 2*1.673952e-5.*T + 2.433502./T);

%% Standard Atmospheres

T=zeros(nz,ns);
p=zeros(nz,ns);
rho=zeros(nz,ns);
rho0=zeros(nz,ns);

for is=1:ns

    T(:,is)=temperature_standard_atmosphere(h,standards{is});
    p(:,is)=pressure_standard_atmosphere(h,standards{is});
    rho(:,is)=vapour_density_standard_atmosphere(h,standards{is});
    rho0(:,is)=rho(:,1);

end

e=rho.*T./216.7;
U=100*e./p_liq(T);
RHi=100*e./p_ice(T);

standard_plot={'k-','r-','m-','m--','b-','b--'};

%% Find the indexes of the virtual tropopause

FL=[36089.2;55774.3;42651.9;32808.4;32808.4;27887.1]/100;
i_trop=zeros(1,ns);

for is=1:ns

    iFL=find(z./100==floor(FL(is)));
    if isempty(iFL)
        iFL=nz;
    end
    i_trop(is)=iFL;

end

%% Slope of the mixing line

cp=1004;
eps=0.622;

G=dp_liq(T);
Gm=zeros(nz,ns);
tau=zeros(nz,nz,ns);
tauU=zeros(nz,nz,ns);


for iz=1:nz
    for is=1:ns

        tau(:,iz,is)=(T(:,is)>=T(iz,is)).*(p_liq(T(:,is))-U(:,is).*e(:,is))./(T(:,is)-T(iz,is));
        [dG,iG]=min(abs((T(:,is)>=T(iz,is)).*(G(:,is)-tau(:,iz,is))));
        Gm(iz,is)=G(iG,is)*eps/(cp*100*p(iz,is));

    end

end

figure(1)
for is=1:ns
    semilogy(z(:)/100,Gm(:,is),standard_plot{is},'LineWidth',1.5,'DisplayName',standards{is})
    hold on
    grid on
end
title('Numerical thresholds for the reduced slope of the mixing line')
ylabel('$G^*=\frac{EI_{H_2 O}}{Q(1-\eta)}=\frac{\dot{m_F}EI_{H_2 O}}{\dot{m_F}Q-FV}$','Interpreter','latex')
xlabel('Flight Level (FL)')
legend('location','southwest')

%% Curve fitting

i_min=[360;549;425;327;327;278];
i_max=[361;nz;427;329;329;279]+1;

for is=1:ns
    [curve1{is},gof1{is}]=fit(z(1:i_min(is))'./100,log(Gm(1:i_min(is),is)),'poly3');
    if i_max(is)<nz
        [curve2{is},gof2{is}]=fit(z(i_max(is):nz)'./100,log(Gm(i_max(is):nz,is)),'poly1');
    end
end

% G* profiles below virtual tropopause
figure(2)
f4=tiledlayout(2,3);
for is=1:ns
    nexttile(is)
    plot(z(1:i_min(is))./100,log(Gm(1:i_min(is),is)),'r-','LineWidth',1.5)
    title(standards{is})
    hold on
    grid on
    plot(curve1{is},'b--')
    text(min(z(1:i_min(is)))./100,min(log(Gm(1:i_min(is),is))),['R^2 = ',num2str(gof1{is}.rsquare)])
    xlabel('z (FL)')
    ylabel('log G')

end

% G* profiles above virtual tropopause
figure(3)
f5=tiledlayout(2,3);
for is=1:ns
    nexttile(is)
    plot(z(i_max(is):nz)./100,log(Gm(i_max(is):nz,is)),'r-','LineWidth',1.5)
    title(standards{is})
    hold on
    grid on
    if i_max(is)<nz
        plot(curve2{is},'b--')
        text(min(z(i_max(is):nz)./100)+50,min(log(Gm(i_max(is):nz,is)))+0.2,['R^2 = ',num2str(gof2{is}.rsquare)])
    end
        
    xlabel('z (FL)')
    ylabel('log G')

end

G_fit=zeros(nz,is);

for is=1:ns
    G_fit(:,is)=G_star_standard_atmosphere(z./100,standards{is});
end

mGm=mean(Gm);
mG_fit=mean(G_fit);

R=sum((Gm-mGm).*(G_fit-mG_fit))./sqrt(sum((Gm-mGm).^2).*sum((G_fit-mG_fit).^2));

%% Shape Morphing Functions

N=0:364;
delta=tanh(N-78)-tanh(N-265)-1;
t_morph_summer=delta;
t_morph_winter=-delta;

day=calendarDuration(0,0,1);
zero_date='01-01';
zero_date=datetime(zero_date,'InputFormat','dd-MM');
timeline=zero_date+N*day;


figure(4)
plot(timeline,t_morph_summer,'DisplayName','Summer','LineWidth',2)
grid on
hold on
plot(timeline,t_morph_winter,'DisplayName','Winter','LineWidth',2)
legend
ylim([-1.1 1.1])
title('Time Morphing Functions')

phi=linspace(-90,90,1000);
phi_morph_mid=0.5.*tanh(phi+22).*tanh(phi+45)-0.5*tanh(phi-22).*tanh(phi-45);
phi_morph_high=0.5.*tanh((phi+45))+0.5.*tanh((phi-45));
phi_morph_low=0.5-0.5.*tanh(phi+22).*tanh(phi-22);

figure(5)
plot(phi,phi_morph_mid,'b','DisplayName','Mid-Latitudes','LineWidth',2)
grid on
hold on
plot(phi,phi_morph_high,'r','DisplayName','High-Latitudes','LineWidth',2)
plot(phi,phi_morph_low,'m','DisplayName','Low-Latitudes','LineWidth',2)
legend('Location','southeast')
ylim([-1.1 1.1])
xlim([-90 90])
xlabel('Latitude \phi')
title('Latitude Morphing Functions')

f1=(ones(length(N),1)*phi_morph_low)';
f2=heaviside((t_morph_summer'*phi_morph_mid)').*(t_morph_summer'*phi_morph_mid)';
f3=heaviside((t_morph_winter'*phi_morph_mid)').*(t_morph_winter'*phi_morph_mid)';
f4=heaviside((t_morph_summer'*phi_morph_high)').*(t_morph_summer'*phi_morph_high)';
f5=heaviside((t_morph_winter'*phi_morph_high)').*(t_morph_winter'*phi_morph_high)';

% Global Heatmap of the Shape Morphing Functions
figure(6)
tiledlayout(2,3)

nexttile
surf(timeline',phi,f1,'EdgeColor','none')
view(2)
ylabel('Latitude \phi')
title('f_1 low-latitude annual ')
clim([0 1])
ylim([-90 90])


nexttile
surf(timeline',phi,f2,'EdgeColor','none')
view(2)
ylabel('Latitude \phi')
title('f_2 mid-latitude summer')
clim([0 1])
ylim([-90 90])

nexttile
surf(timeline',phi,f3,'EdgeColor','none')
view(2)
ylabel('Latitude \phi')
title('f_3 mid-latitude winter')
clim([0 1])
ylim([-90 90])

nexttile
surf(timeline',phi,f4,'EdgeColor','none')
view(2)
ylabel('Latitude \phi')
title('f_4 high-latitude summer')
clim([0 1])
ylim([-90 90])

nexttile
surf(timeline',phi,f5,'EdgeColor','none')
view(2)
ylabel('Latitude \phi')
title('f_5 high-latitude winter')
clim([0 1])
ylim([-90 90])

cb = colorbar(); 
cb.Layout.Tile = 'east';
colormap sky

