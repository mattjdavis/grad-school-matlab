function [ R] = processRPM( rpmPath,dataset_flag, imgPath,startTime,trialDuration )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%'X:\imaging\wheel_rna_1\rpm\md178_d01_wheel_2016_09_08_12_56_22_949.txt'
%These vars are only used when imgFlag=0;
% startTime='08-Sep-2016 12:59:00'\
% trialDuration, seconds 1800 seconds in 30 mins

% Have not tried with imaging data.

% STICK WITH CELL ARRAY FOR R RIGTH NOW, SHOULD BE STRUCT

% CONSTANT
RPM_SR=20; %hz

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

% Different behavior if start time is coming from 
switch dataset_flag
    case 2
        R{4,1}=[]; %blank start time, use whole trial
        
        ds_read=downsample(read',2);
        
   
    case 1
        IMG_SR=10.088781; % hz
        nFrames=6000;
        realImgTime=nFrames*1/IMG_SR; % sec
        R=scientifica_get_rpm(imgPath);
        maxRunTime=round(RPM_SR*realImgTime)+200; % total amount of time the   
    case 0        
        R{4,1}=posixtime(datetime(startTime)); %start time, unix epoch
        maxRunTime=RPM_SR*trialDuration; 
    end
    


for j=1:size(R,2)
    % ---FIND---
    RPM=read(:,2);
    
    
    if (dataset_flag == 2)
        % rpm lick case
        subRPM=RPM;
    else
        % For CDT, minus 5 hours
        timeRPM=read(:,1)'-repmat(18e6,1,size(read,1)); 

        % % For CST, minus 6 hours
        % timeRPM=read(:,1)'-repmat(216e5,1,size(read,1));

        [~, idx] = min(abs(timeRPM-R{4,j}));
        % Get the full chunck of relvant RPM 
        % Max possible RPM, since RPM_SR is usually higher than 
        subRPM=RPM(idx:idx+(maxRunTime)-1); 
    end

    

    % ---FILTER---
    % median filter, Also: min = 0, max = 60 
    run=medfilt(subRPM,3); % median filter
    run( run > 60 )=mean(run); % max = 60
    ind = find(run < 0);run(ind) = 0; % min =  0
    % moving avg filter
    k = ones(1, 30) / 30;
    filtRPM = conv(run, k, 'same');

    % ---DOWNSAMPLE---
    % caculates which img frame is closest to which running frame, better than dumb downsampling
    if (dataset_flag == 1)
        z=linspace(1/IMG_SR,realImgTime,nFrames);
        zz=linspace(1/RPM_SR,nFrames/10,nFrames*2);
        for i=1:length(z)
            [~, idx] = min(abs(zz-z(i)));
            TT(i)=idx;
            dsRPM=filtRPM(TT);
        end
    elseif (dataset_flag ~= 1)
        % simple downsample when only running is available.
        dsRPM= downsample(filtRPM,2);
    end
    
    % ---COLLECT VARS--  
    R{5,j}=subRPM;
    R{6,j}=filtRPM;
    R{7,j}=dsRPM;
    R{8,j}=findRunEpochs(dsRPM, RPM_SR/2,3);
end

%save(strcat(directory,'RPM.mat'),'R');





end

