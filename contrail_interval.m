function [z_low,z_high,status] = contrail_interval(lat,N)

N_spring=78;
N_fall=265;

nk=length(lat);

lat_low_mid=22;
lat_mid_high=45;

z_low=zeros(nk,1);
z_high=zeros(nk,1);

status=cell(nk,1);

for ik=1:nk

    if abs(lat(ik))<=lat_low_mid
        status{ik}='Low-latitude Annual';
        z_low(ik)=360;
        z_high(ik)=Inf;
    elseif (abs(lat(ik))>lat_low_mid && abs(lat(ik))<=lat_mid_high) && ( N(ik)>=N_spring && N(ik)<N_fall )
        status{ik}='Mid-latitude Summer';
        z_low(ik)=345;
        z_high(ik)=530;
    elseif (abs(lat(ik))>lat_low_mid && abs(lat(ik))<=lat_mid_high) && ( N(ik)<N_spring || N(ik)>=N_fall )
        status{ik}='Mid-latitude Winter';
        z_low(ik)=240;
        z_high(ik)=440;
    elseif (abs(lat(ik))>lat_mid_high) && ( N(ik)>=N_spring && N(ik)<N_fall )
        status{ik}='High-latitude Summer';
        z_low(ik)=280;
        z_high(ik)=340;
    elseif (abs(lat(ik))>lat_mid_high) && ( N(ik)<N_spring || N(ik)>=N_fall )
        status{ik}='High-latitude Winter';
        z_low(ik)=170;
        z_high(ik)=440;
    end

end

