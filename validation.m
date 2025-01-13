clear all
close all
clc

%% Extracting data from COLI

Reference=readcell("COLI_Nov_2016.xlsx",'Range','E2:E237');
Date=readmatrix("COLI_Nov_2016.xlsx",'Range','H2:H237');
Location=readcell("COLI_Nov_2016.xlsx",'Range','L2:L237');
Altitude=readmatrix("COLI_Nov_2016.xlsx",'Range','AS2:AS237');

n=length(Altitude);


% Cleaning up measurements with no altitude
TF=isnan(Altitude);
Reference(TF)=[];
Date(TF)=[];
Location(TF)=[];
Altitude(TF)=[];

n=length(Altitude);

TFL=zeros(n,1);
for itf=1:n
    TF2=sum(ismissing(Location{itf}));
    if TF2==1
        TFL(itf)=1;
    end
end
TFL=logical(TFL);
Reference(TFL)=[];
Date(TFL)=[];
Location(TFL)=[];
Altitude(TFL)=[];

Reference(1)=[];
Date(1)=[];
Location(1)=[];
Altitude(1)=[];

Reference(3)=[];
Date(3)=[];
Location(3)=[];
Altitude(3)=[];

n=length(Altitude);

%% Identifying latitudes

Geography=unique(Location);

Latitudes=zeros(n,1);

for itf=1:n

    if strcmp(Location{itf},'47.5N,11E, Garmisch; DE')==1
        Latitudes(itf)=47.5;
    elseif strcmp(Location{itf},'48.3N,10.7E, Margertshausen')==1
        Latitudes(itf)=48.3;
    elseif strcmp(Location{itf},'48.3N,10.7E, Margertshausen near Augsburg; DE')==1
        Latitudes(itf)=48.3;
    elseif strcmp(Location{itf},'48.3°N,10.3°E S.-Germany')==1
        Latitudes(itf)=48.3;
    elseif strcmp(Location{itf},'CONUS')==1
        Latitudes(itf)=39.50;
    elseif strcmp(Location{itf},'Colorado')==1
        Latitudes(itf)=39.11;
    elseif strcmp(Location{itf},'Costa Rica 83°W. equator')==1
        Latitudes(itf)=9.75;
    elseif strcmp(Location{itf},'Florida;25.5°N,81°W')==1
        Latitudes(itf)=25.5;
    elseif strcmp(Location{itf},'German Bay, 6.8E, 53.4N')==1
        Latitudes(itf)=53.4;
    elseif strcmp(Location{itf},'German Bay,7.3E,53.6N')==1
        Latitudes(itf)=53.6;
    elseif strcmp(Location{itf},'Germany')==1
        Latitudes(itf)=51.00;
    elseif strcmp(Location{itf},'Germany:49.2N_11.7E')==1
        Latitudes(itf)=49.2;
    elseif strcmp(Location{itf},'NE_Oklahoma')==1
        Latitudes(itf)=35.74;
    elseif strcmp(Location{itf},'NFC, West of England')==1
        Latitudes(itf)=54.1;
    elseif strcmp(Location{itf},'N_Colorado_S_Wyoming')==1
        Latitudes(itf)=41;
    elseif strcmp(Location{itf},'N_Germany_51.6N,7.7E')==1
        Latitudes(itf)=51.6;
    elseif strcmp(Location{itf},'N_Germany_52.3N,13.2E')==1
        Latitudes(itf)=52.3;
    elseif strcmp(Location{itf},'North Sea, 7.E,56.5N')==1
        Latitudes(itf)=56.5;
    elseif strcmp(Location{itf},'Northern Germany')==1
        Latitudes(itf)=52;
    elseif strcmp(Location{itf},'Northern Germany, 54N,9.5E')==1
        Latitudes(itf)=54;
    elseif strcmp(Location{itf},'Northsea, 50 km SSW of Helgoland')==1
        Latitudes(itf)=54.18;
    elseif strcmp(Location{itf},'Northsea_UA7')==1
        Latitudes(itf)=54.4;
    elseif strcmp(Location{itf},'S. Germany, 12E, 49 N')==1
        Latitudes(itf)=49;
    elseif strcmp(Location{itf},'Southern Germany')==1
        Latitudes(itf)=51;
    elseif strcmp(Location{itf},'Tiwi Islands, Australia')==1
        Latitudes(itf)=-11.60;
    elseif strcmp(Location{itf},'about 38.5N, 124.5W, Pacific Ocean, off the Northern California Coast')==1
        Latitudes(itf)=38.5;
    elseif strcmp(Location{itf},'near NASA Goddard,US, 39°N, 76.9°W')==1
        Latitudes(itf)=39;
    elseif strcmp(Location{itf},'over San Francisco')==1
        Latitudes(itf)=37.77;
    end

end

%% Identifying dates

dateStr = num2str(Date);
dateObj = datetime(dateStr, 'InputFormat', 'yyyyMMdd');

% Get the day of the year (N) for each date
N_days = day(dateObj, 'dayofyear');

N_spring=78;
N_fall=265;

%% ISA Accuracy

z_low_ISA=260;
z_high_ISA=470;

truth_ISA=(z_low_ISA<=Altitude).*(Altitude<=z_high_ISA);
total_truth_ISA=mean(truth_ISA)*100;

z_low_pers=290;
z_high_pers=400;

truth_pers=(z_low_pers<=Altitude).*(Altitude<=z_high_pers);
total_truth_pers=mean(truth_pers)*100;

M_ISA=sum(truth_ISA);

%% Identifying date and latitude for ITU application

z_low_ITU=zeros(n,1);
z_high_ITU=zeros(n,1);
category=cell(n,1);

id_low=zeros(n,1);
id_mid=zeros(n,1);
id_high=zeros(n,1);
id_summer=zeros(n,1);
id_winter=zeros(n,1);
id_mid_summer=zeros(n,1);
id_mid_winter=zeros(n,1);
id_high_summer=zeros(n,1);
id_high_winter=zeros(n,1);


for itf=1:n

    if abs(Latitudes(itf))<=22

        lat='Low-latitude';
        season='Annual';
        z_low_ITU(itf)=360;
        z_high_ITU(itf)=Inf;
        category{itf}=strcat(lat,{' '},season);
        id_low(itf)=1;

    elseif abs(Latitudes(itf))>22 && abs(Latitudes(itf))<=45

        lat='Mid-latitude';
        if N_days(itf)>=N_spring && N_days(itf)<N_fall

            season='Summer';
            z_low_ITU(itf)=345;
            z_high_ITU(itf)=530;
            category{itf}=strcat(lat,{' '},season);
            id_summer(itf)=1;
            id_mid_summer(itf)=1;

        elseif N_days(itf)<N_spring || N_days(itf)>=N_fall

            season='Winter';
            z_low_ITU(itf)=240;
            z_high_ITU(itf)=440;
            category{itf}=strcat(lat,{' '},season);
            id_winter(itf)=1;
            id_mid_winter(itf)=1;

        end

        id_mid(itf)=1;

    elseif abs(Latitudes(itf))>45

        lat='High-latitude';
        if N_days(itf)>=N_spring && N_days(itf)<N_fall

            season='Summer';
            z_low_ITU(itf)=280;
            z_high_ITU(itf)=340;
            category{itf}=strcat(lat,{' '},season);
            id_summer(itf)=1;
            id_high_summer(itf)=1;

        elseif N_days(itf)<N_spring || N_days(itf)>=N_fall

            season='Winter';
            z_low_ITU(itf)=170;
            z_high_ITU(itf)=440;
            category{itf}=strcat(lat,{' '},season);
            id_winter(itf)=1;
            id_high_winter(itf)=1;


        end

        id_high(itf)=1;

    end

end

%% ITU Accuracy

truth_ITU=(z_low_ITU<=Altitude).*(Altitude<=z_high_ITU);
total_truth_ITU=mean(truth_ITU)*100;

disp(['ISA: ',num2str(total_truth_ISA),'%']);
disp(['ISSR: ',num2str(total_truth_pers),'%']);
disp(['ITU: ',num2str(total_truth_ITU),'%']);

M_ITU=sum(truth_ITU);

%% Histogram
%
M_low=sum(id_low);
M_mid=sum(id_mid);
M_high=sum(id_high);
M_summer=sum(id_summer);
M_winter=sum(id_winter);
M_mid_summer=sum(id_mid_summer);
M_mid_winter=sum(id_mid_winter);
M_high_summer=sum(id_high_summer);
M_high_winter=sum(id_high_winter);

truth_low=id_low.*truth_ITU;
M_truth_low=sum(truth_low);
acc_low=M_truth_low/M_low*100;
disp(['Low-latitudes: ',num2str(acc_low),'%']);

truth_mid=id_mid.*truth_ITU;
M_truth_mid=sum(truth_mid);
acc_mid=M_truth_mid/M_mid*100;
disp(['Mid-latitudes: ',num2str(acc_mid),'%']);

truth_high=id_high.*truth_ITU;
M_truth_high=sum(truth_high);
acc_high=M_truth_high/M_high*100;
disp(['High-latitudes: ',num2str(acc_high),'%']);

truth_summer=id_summer.*truth_ITU;
M_truth_summer=sum(truth_summer);
acc_summer=M_truth_summer/M_summer*100;
disp(['Summer: ',num2str(acc_summer),'%']);

truth_winter=id_winter.*truth_ITU;
M_truth_winter=sum(truth_winter);
acc_winter=M_truth_winter/M_winter*100;
disp(['Winter: ',num2str(acc_winter),'%']);

truth_mid_summer=id_mid_summer.*truth_ITU;
M_truth_mid_summer=sum(truth_mid_summer);
acc_mid_summer=M_truth_mid_summer/M_mid_summer*100;
disp(['Mid-latitudes Summer: ',num2str(acc_mid_summer),'%']);

truth_mid_winter=id_mid_winter.*truth_ITU;
M_truth_mid_winter=sum(truth_mid_winter);
acc_mid_winter=M_truth_mid_winter/M_mid_winter*100;
disp(['Mid-latitudes Winter: ',num2str(acc_mid_winter),'%']);

truth_high_summer=id_high_summer.*truth_ITU;
M_truth_high_summer=sum(truth_high_summer);
acc_high_summer=M_truth_high_summer/M_high_summer*100;
disp(['High-latitudes Summer: ',num2str(acc_high_summer),'%']);

truth_high_winter=id_high_winter.*truth_ITU;
M_truth_high_winter=sum(truth_high_winter);
acc_high_winter=M_truth_high_winter/M_high_winter*100;
disp(['High-latitudes Winter: ',num2str(acc_high_winter),'%']);

Cite=unique(Reference);

figure(1)
tiledlayout(3,1)

nexttile
pie_season=[M_winter M_summer M_low]./n;
labels_season={'Winter','Summer','N.A.'};
piechart(pie_season,labels_season)
title('(a) Seasons')

nexttile
pie_lat=[M_low M_mid M_high]./n;
labels_lat={'Low-latitudes','Mid-latitudes','High-latitudes'};
piechart(pie_lat,labels_lat)
title('(b) Latitudes')

nexttile
pie_ITU=[M_low M_mid_summer M_mid_winter M_high_summer M_high_winter]./n;
labels_ITU={'Low-latitudes','Mid-latitudes Summer','Mid-latitudes Winter','High-latitudes Summer','High-latitudes Winter'};
piechart(pie_ITU,labels_ITU)
title('(c) ITU cases')

truth_low=id_low.*truth_ISA;
M_truth_low=sum(truth_low);
acc_low=M_truth_low/M_low*100;
disp(['Low-latitudes: ',num2str(acc_low),'%']);

truth_mid=id_mid.*truth_ISA;
M_truth_mid=sum(truth_mid);
acc_mid=M_truth_mid/M_mid*100;
disp(['Mid-latitudes: ',num2str(acc_mid),'%']);

truth_high=id_high.*truth_ISA;
M_truth_high=sum(truth_high);
acc_high=M_truth_high/M_high*100;
disp(['High-latitudes: ',num2str(acc_high),'%']);

truth_summer=id_summer.*truth_ISA;
M_truth_summer=sum(truth_summer);
acc_summer=M_truth_summer/M_summer*100;
disp(['Summer: ',num2str(acc_summer),'%']);

truth_winter=id_winter.*truth_ISA;
M_truth_winter=sum(truth_winter);
acc_winter=M_truth_winter/M_winter*100;
disp(['Winter: ',num2str(acc_winter),'%']);

truth_mid_summer=id_mid_summer.*truth_ISA;
M_truth_mid_summer=sum(truth_mid_summer);
acc_mid_summer=M_truth_mid_summer/M_mid_summer*100;
disp(['Mid-latitudes Summer: ',num2str(acc_mid_summer),'%']);

truth_mid_winter=id_mid_winter.*truth_ISA;
M_truth_mid_winter=sum(truth_mid_winter);
acc_mid_winter=M_truth_mid_winter/M_mid_winter*100;
disp(['Mid-latitudes Winter: ',num2str(acc_mid_winter),'%']);

truth_high_summer=id_high_summer.*truth_ISA;
M_truth_high_summer=sum(truth_high_summer);
acc_high_summer=M_truth_high_summer/M_high_summer*100;
disp(['High-latitudes Summer: ',num2str(acc_high_summer),'%']);

truth_high_winter=id_high_winter.*truth_ISA;
M_truth_high_winter=sum(truth_high_winter);
acc_high_winter=M_truth_high_winter/M_high_winter*100;
disp(['High-latitudes Winter: ',num2str(acc_high_winter),'%']);
