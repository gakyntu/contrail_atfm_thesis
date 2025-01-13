close all
clc

exist demand_fra;
if ans==0
    demand_fra=table;
end


if isempty(demand_fra)==1

    clear demand_fra;
    demand_fra=readtable('d_current_FRA.csv');

    rfl=[demand_fra.rfl_RPHI_fra demand_fra.rfl_VDPF_fra demand_fra.rfl_VLVT_fra demand_fra.rfl_VTBB_fra demand_fra.rfl_VYYF_fra demand_fra.rfl_VVHN_fra demand_fra.rfl_VVHM_fra demand_fra.rfl_WMFC_fra demand_fra.rfl_WBFC_fra demand_fra.rfl_WSJC_fra demand_fra.rfl_WIIF_fra demand_fra.rfl_WAAF_fra];
    FIR_entry_time=[demand_fra.time_entry_RPHI_fra_fp demand_fra.time_entry_VDPF_fra_fp demand_fra.time_entry_VLVT_fra_fp demand_fra.time_entry_VTBB_fra_fp demand_fra.time_entry_VYYF_fra_fp demand_fra.time_entry_VVHN_fra_fp demand_fra.time_entry_VVHM_fra_fp demand_fra.time_entry_WMFC_fra_fp demand_fra.time_entry_WBFC_fra_fp demand_fra.time_entry_WSJC_fra_fp demand_fra.time_entry_WIIF_fra_fp demand_fra.time_entry_WAAF_fra_fp];
    FIR_exit_time=[demand_fra.time_exit_RPHI_fra_fp demand_fra.time_exit_VDPF_fra_fp demand_fra.time_exit_VLVT_fra_fp demand_fra.time_exit_VTBB_fra_fp demand_fra.time_exit_VYYF_fra_fp demand_fra.time_exit_VVHN_fra_fp demand_fra.time_exit_VVHM_fra_fp demand_fra.time_exit_WMFC_fra_fp demand_fra.time_exit_WBFC_fra_fp demand_fra.time_exit_WSJC_fra_fp demand_fra.time_exit_WIIF_fra_fp demand_fra.time_exit_WAAF_fra_fp];
    airport_origin=demand_fra.origin;
    airport_destination=demand_fra.destination;

end

asean_entry=min(FIR_entry_time);
asean_exit=max(FIR_exit_time,[],2);

contrail_matrix=(rfl>=360);

ISSR_matrix=(rfl>=290).*(rfl<=400);

contrail_flights=sum(contrail_matrix,2);

flights_with_contrail=(contrail_flights>0);

persistence_matrix=contrail_matrix.*ISSR_matrix;

persistence_flights=sum(persistence_matrix,2);

flights_with_persistence=(persistence_flights>0);

n_flights=length(contrail_flights);
n_flights_with_contrails=sum(flights_with_contrail);
perc_contrail=n_flights_with_contrails/n_flights * 100;
n_flights_with_persistence=sum(flights_with_persistence);
perc_persistence=n_flights_with_persistence/n_flights * 100;

figure(1)
edgesFL=145:10:435;
h=histogram(max(rfl,[],2),edgesFL);
hold on
countsFL=h.Values;
FLs=150:10:430;
ylabel('Number of flights');
xlabel('Flight Levels')
%plot(countsFL,FLs)

total_flights=sum(countsFL);
pers_flights=sum(countsFL(22:26));

disp(['Percentage of flights generating contrails: ',num2str(perc_contrail),' %'])
disp(['Percentage of flights generating persistent contrails: ',num2str(perc_persistence),' %'])

% Define the reference time
referenceTime = datetime(2019, 12, 13, 0, 0, 0, 'TimeZone', 'UTC');

% Convert time intervals to datetime in UTC
dateTime_entry = referenceTime + seconds(FIR_entry_time);
dateTime_exit = referenceTime + seconds(FIR_exit_time);

duration=dateTime_exit-dateTime_entry;

days_id=nanmean(dateTime_entry,2);
date_id=datestr(days_id,'dd-mm-yyyy');

time_units=0:86400:15*86400;
days_unit=datetime(2019,12,12:27);
all_times_start=min(dateTime_entry,[],2);
all_dates=dateshift(all_times_start,'start','day');
cat_dates=categorical(all_dates);
counts=countcats(cat_dates);
categories_total=categories(cat_dates);

dates_with_contrails=all_dates(flights_with_contrail);
cat_dates_contrail=categorical(dates_with_contrails);
countsdates=countcats(cat_dates_contrail);
categories=categories(cat_dates_contrail);
perc_date=countsdates./counts*100;

dates_with_persistence=all_dates(flights_with_persistence);
cat_dates_persistence=categorical(dates_with_persistence);
countsdates=countcats(cat_dates_persistence);
categories=categories(cat_dates_persistence);
perc_date_pers=countsdates./counts*100;


FIR={'RPHI';'VDPF';'VLVT';'VTBB';'VYYF';'VVHN';'VVHM';'WMFC';'WBFC';'WSJC';'WIIF';'WAAF'};
contrail_matrix=(rfl>=360);
FIR_contrail=sum(contrail_matrix,1);
FIR_pers=sum(persistence_matrix,1);

logical_flightset=~isnan(FIR_exit_time);
FIR_total=sum(logical_flightset,1);
perc_FIR=FIR_contrail./FIR_total *100;
perc_FIR_pers=FIR_pers./FIR_total * 100;

n_times=24*15+4;
nFIR=12;
nFL=length(FLs);

feet_to_m=0.3048;
h=60*100*feet_to_m;
vz=3000*0.00508;
v_TAS=0.85*343;

Dt=n_flights_with_contrails*(2*h/vz)*(1-sqrt(1-vz^2/v_TAS^2));
mf=4*0.58;
Dm=mf*Dt;

disp(['Additional time: ',num2str(Dt),' s.'])
disp(['Additional time: ',num2str(Dt/60),' min.'])
disp(['Additional fuel: ',num2str(Dm),' kg.'])
disp(['Additional daily average time: ',num2str(Dt/15),' s.'])
disp(['Additional daily average time: ',num2str(Dt/(15*60)),' min.'])
disp(['Additional daily average fuel: ',num2str(Dm/15),' kg.'])
