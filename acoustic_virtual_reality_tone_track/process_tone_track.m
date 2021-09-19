function [BEHAVIOR] = process_tone_track(file,IMG_SR)
% version with header, created 2/1/2017

% %unix_epoch, rpm, position, reward, mreward, lick_detected,
% lap_position,zone,ard_timestamp,lick_voltage,beep_on (2/01/17)
PROBE_FREQ=5;
MAX_RPM=60; % ignore values above this
LONG_LAP_THRESH=1200; %ms cut-off for long lap
RPM_FS=16; %ms, can be derived from data?
RUN_THRESH=3; % lower bound to count run bout
SQUARE_SIZE=.75; %cm
BIN_SIZE=16; % % number squares to bin for rate.
RZ_BIN=23:24; %reward zone in bin position
AZ_BIN=21:22;






BEHAVIOR=struct;

% % read file
% fid = fopen(file);
% format = '%s'; 
% header_names = textscan(fid,format,NUM_VARS,'Delimiter',',');
% format = '%f';
% r = textscan(fid,'','Delimiter',',');
% read=cell2mat(r(1:NUM_VARS)); %eliminate NaN columns 
% %READ=textscan(fid,'','delimiter',',','headerlines',1); % old w/ skip
% %header
% fclose(fid);

% % save  data
% RAW=struct;
% RAW.header_names=header_names;
% RAW.read=read;

% % Parse read table
% T.unix_epoch=read(:,1);
% T.rpm=read(:,2);
% T.position=read(:,3);
% T.reward=read(:,4);
% T.mreward=read(:,5);
% T.lick_detected=read(:,6);
% T.lap_position=read(:,7);
% T.zone=read(:,8);
% T.ard_timestamp=read(:,9);
% lick_voltage=read(:,10);
% T.beep_on=read(:,11);
% T.probe_state=read(:,12);


T=readtable(file);

ind=find(T.lap_position==0); T.lap_position(ind)=1; %should never be 0

%% calcium and position time vector
cdt=1/10.088; % HACK
ct = cdt*ones(6000,1); %HACK
ct = cumsum(ct);
pt = (T.ard_timestamp - min(T.ard_timestamp))/1000 + cdt;

%get position for each ct
cpos = zeros(size(ct));
for t = 1:length(ct)    
   [~,midx] = min((pt-ct(t)).^2);
   ds_ind(t)=midx;
   cpos(t) = T.lap_position(midx);
end

%% LAPS


%SQUARES_TONE_LAP=max(T.lap_position);
SQUARES_TONE_LAP=384; %sometimes max is skipped, 4/24/17
tone_lap =ceil(T.position./SQUARES_TONE_LAP)-1; % HACK for WHEEL RUN 3
lap_trans=[0 ; diff(tone_lap)];


% probe trials
% every 5th lap (usually) n
% tone_lap=floor(T.position/200); % floor or ceil matters
probe_lap=zeros(size(ct,1),1);
reward_lap=zeros(size(ct,1),1);
mod_tl=mod(tone_lap,PROBE_FREQ);
[probe_lap_ind]=find(mod_tl ==0);
reward_lap_ind=find(mod_tl ~=0);
probe_lap(probe_lap_ind)=1;
reward_lap(reward_lap_ind)=1;

lap_end=find(lap_trans);
lap_end=[1; lap_end; size(ct,1)];
lap_length=diff(lap_end);
long_lap=find(lap_length > LONG_LAP_THRESH);
 
% lap length
long_lap_ind=zeros(size(ct,1),1);
 for ii=1:length(long_lap)
    ind=find(tone_lap==long_lap(ii));
    long_lap_ind(ind)=1;
 end
 
 % distance vars
 nlaps=max(tone_lap);
 dist_sq= max(T.position);
 dist_cm= dist_sq*SQUARE_SIZE;
 
 % bin 
 binned_position=ceil(T.lap_position/BIN_SIZE);
 %wheel_binned_position=ceil(T.lap_position/64); probably dont need, was
 %thinking bout getting wheel rhymicity

LAP=v2struct(cpos,probe_lap_ind,probe_lap,reward_lap_ind,reward_lap,tone_lap,lap_length,long_lap_ind, nlaps,dist_sq,dist_cm, binned_position);

%% LICK

LICK=struct;

% get first licks
f_licks=T.lick_detected;
f_licks=diff(f_licks);
ind=find(f_licks==-1);
f_licks(ind)=0;
f_licks=[0;f_licks];% add element to start
f_licks_ind=find(f_licks);
f_licks_num=length(f_licks_ind);

%


% % OBSOLETE FOR ZONES 
% probe_licks=find(f_licks(probe_lap_ind));
% reward_licks=find(f_licks(reward_lap_ind));
% %probe_licks=find(lick_volts(probe_laps)>4.3); % set higher
% zone_probe_licks=T.zone(probe_licks);
% zone_reward_licks=T.zone(reward_licks);
% %Z_flicks_nLL_P=T.zone(find(((long_lap_ind ~=1) & (f_licks==1) & (mod_tl == 0))));
% %Z_flicks_nLL_P=T.zone(find(((f_licks==1) & (mod_tl == 0))));
% % OBSOLETE

% lick_rate, 
flicks_binned=binned_position(f_licks_ind);
fl_bin= histcounts(flicks_binned,SQUARES_TONE_LAP/BIN_SIZE);
pos_bin= histcounts(binned_position,SQUARES_TONE_LAP/BIN_SIZE);
lick_rate=fl_bin./(pos_bin*(RPM_FS/1000));

% rewawd zone
%ffl_rz=sum(fl_bin(RZ_BIN))/sum(fl_bin); % fraction flicks in reward zone 
%nfl_bin=fl_bin./(pos_bin); %normalized fl_bin
%nffl_rz=sum(nfl_bin(RZ_BIN))/sum(nfl_bin); %nommalized fraction flicks in reward zone

% antcipation zone
%nffl_az=sum(nfl_bin(AZ_BIN))/sum(nfl_bin); %nommalized fraction flicks in anticipation zone


%LICK=v2struct(lick_rate,f_licks,f_licks_ind,f_licks_num,fl_bin,nffl_rz,nffl_az,pos_bin,ffl_rz,zone_probe_licks,zone_reward_licks);
LICK=v2struct(lick_rate,f_licks,f_licks_ind,f_licks_num,fl_bin,pos_bin);% remove zone
%% RPM 
RUN=struct;

rpm=T.rpm(ds_ind); % RUN IS DOWNSAMPLED
rpm_med=medfilt(rpm,3); % median filter
rpm_med( rpm_med > MAX_RPM )=mean(rpm_med); % max = 60
ind = find(rpm_med < 0);rpm_med(ind) = 0; % min =  0
k = ones(1, 30) / 30; rpm_filt = conv(rpm_med, k, 'same'); % moving avg filter


%epochs
epoch=findRunEpochs(rpm_filt, 1000/RPM_FS,RUN_THRESH);
v2struct(epoch);
%RUN.run_mask=runMask;
%RUN.run_epochs=runEpochs;
%RUN.run_epochs_len=lengthRunEpochs;
%RUN.run_percent=percentRun;
RUN=v2struct(rpm_med,rpm_filt,runMask,runEpochs,lengthRunEpochs,percentRun);
%figure;plot(rpm_med);

%%
rnum= max(T.reward); %reward num

REWARD=v2struct(rnum);

%% will implement late
%DS=struct

%DS=v2struct(rpm(pt));
%%

 BEHAVIOR=v2struct(LICK,LAP,RUN,REWARD,T);
end

