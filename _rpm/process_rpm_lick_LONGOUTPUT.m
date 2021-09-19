function [ behavior] = process_rpm_lick_LONGOUTPUT( rpmPath, nF)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%LONGOUTPUT refers to data collected before serial output was changed ~
% 11.30.2016. This data primarily applies to Wheel Run 1 and 2

% Read Variables
%1=timestamp
%2=rpm
%3=transitionCounter
%4=lapCounter
%5=rewardCounter
%6=manualRewardCountre
%7=lick
%8=ledState
%9=runState

SQUARES_PER_LAP=64;

% CONSTANT
RPM_SR=20; %hz
nFrames=nF;
IMG_SR=10.088781; % hz
realImgTime=nFrames*1/IMG_SR; % sec

% ---READ RPM TEXT---
if isdir(rpmPath)
    text_files = dir(fullfile(rpmPath, '*.txt'));
    read=[];
    for i=1:length(text_files)
        read = [ read ; csvread(strcat(rpmPath,text_files(i).name))];
    end 
else
    % assume direct file
    read= csvread(rpmPath);
end

 R{4,1}=[]; %blank start time, use whole trial for rpm_lick

for j=1:size(R,2)
    % ---FIND---
    % rpm_lick has the entire run, so subset of RPM is whole RPM 
    rpm=read(:,2);
    %subRPM=RPM;

    % ---FILTER---
    % median filter, Also: min = 0, max = 60 
    rpm1=medfilt(rpm,3); % median filter
    rpm1( rpm1 > 60 )=mean(rpm1); % max = 60
    ind = find(rpm1 < 0);rpm1(ind) = 0; % min =  0
    % moving avg filter
    k = ones(1, 30) / 30;
    filtRPM = conv(rpm1, k, 'same');

    % ---DOWNSAMPLE---
    % caculates which img frame is closest to which running frame
    % rpm_lick apply to all variables 
    %z=linspace(1/IMG_SR,realImgTime,nFrames);
    
%     zz=linspace(1/RPM_SR,nFrames/10,nFrames*2);
%     for i=1:length(z)
%         [~, idx] = min(abs(zz-z(i)));
%         TT(i)=idx;
%         dsRPM=filtRPM(TT);
%     end
    
    % ds2
    timestamp=read(:,1);
    start=repmat(timestamp(1),size(read,1),1);
    rpm_time=timestamp-start;
    img_time=((1:nFrames)*1/IMG_SR)*1000;
    
    for i=1:nFrames
        [~, idx] = min(abs(rpm_time-img_time(i)));
        ds_index(i)=idx;
        dsRPM=filtRPM(ds_index);
    end

    % ---COLLECT RUN VARS---  
    run.rpm_full=rpm;
    run.rpm_filt=filtRPM;
    run.rpm_ds=dsRPM;
    run.rpm_ds_ind=ds_index;
    run.rpm_time=rpm_time;
    run.timestamp=timestamp;
    run.start_time=start;
    
    
    %epochs
    epoch=findRunEpochs(dsRPM, RPM_SR/2,3);
    v2struct(epoch);
    run.run_mask=runMask;
    run.run_epochs=runEpochs;
    run.run_epochs_len=lengthRunEpochs;
    run.run_percent=percentRun;
    
    % ---CALCULATE OTHER BEHAVIOR VARIABLES---
    
    % Get whole read matrix downsampled like rpm
    % Worried about losing information here, licking is the main concern
    read_ds=read(ds_index,:); 
    
    %%
    
    % VARS THAT CHANGE AT TONE TRACK
    run_state=read(:,9);
    %%%%%%%%%%%%%%%%%%
    
    position=read(:,3);
    lap=floor(position./SQUARES_PER_LAP);

    lap_times=find(diff(lap)) + 1;
    lap_num=length(lap_times);

    reward=read(:,5);
    reward_times=find(diff(reward)) + 1;
    reward_num=length(reward_times);

    mreward=read(:,6);
    mreward_times=find(diff(mreward)) + 1;
    mreward_num=length(mreward_times);

    total_reward=mreward_num+reward_num;
    all_reward_times=[ mreward_times;reward_times];

    %lick - remove waterdrop artifacts. if long string of licks occurs when a
    %drop is delivered
    lick=read(:,7);
    

    lick_times=find(diff(lick)) + 1;
    lick_num=length(lick_times);
    
    
    % full
    RAW_FILE=read;
    DS_FILE=read_ds;

    behavior=v2struct(run,lap, lap_times,lap_num,reward, reward_times,...
        reward_num,mreward_times, mreward, mreward_num,total_reward,total_reward,...
        all_reward_times,lick,lick_times,lick_num,run_state,RAW_FILE,DS_FILE);
    
    % collect info
    behavior.info.file=rpmPath;
    
    
end

%save(strcat(directory,'RPM.mat'),'R');





end

