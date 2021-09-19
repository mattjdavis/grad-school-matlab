function [ R] = process_rpm_lick( rpmPath, imgPath,startTime,trialDuration )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%'X:\imaging\wheel_rna_1\rpm\md178_d01_wheel_2016_09_08_12_56_22_949.txt'
%These vars are only used when imgFlag=0;
% startTime='08-Sep-2016 12:59:00'\
% trialDuration, seconds 1800 seconds in 30 mins

% CONSTANT
RPM_SR=20; %hz
nFrames=6000;
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
    RPM=read(:,2);
    subRPM=RPM;

    % ---FILTER---
    % median filter, Also: min = 0, max = 60 
    run=medfilt(subRPM,3); % median filter
    run( run > 60 )=mean(run); % max = 60
    ind = find(run < 0);run(ind) = 0; % min =  0
    % moving avg filter
    k = ones(1, 30) / 30;
    filtRPM = conv(run, k, 'same');

    % ---DOWNSAMPLE---
    % caculates which img frame is closest to which running frame
    % rpm_lick apply to all variables 
    z=linspace(1/IMG_SR,realImgTime,nFrames);
    zz=linspace(1/RPM_SR,nFrames/10,nFrames*2);
    for i=1:length(z)
        [~, idx] = min(abs(zz-z(i)));
        TT(i)=idx;
        dsRPM=filtRPM(TT);
    end

    % ---COLLECT RUN VARS---  
    R{5,j}=subRPM;
    R{6,j}=filtRPM;
    R{7,j}=dsRPM;
    R{8,j}=findRunEpochs(dsRPM, RPM_SR/2,3);
    
    % ---CALCULATE OTHER BEHAVIOR VARIABLES---
end

%save(strcat(directory,'RPM.mat'),'R');





end

