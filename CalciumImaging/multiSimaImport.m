function [ dataset] = multiSimaImport(in,rpm_path, SPIKE_THRESH,P,method,frame_window)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here



imgHz=10.088781; % imaging frequency
if nargin < 2; display('rpm_path not provided. skipping behavior'); end
if nargin < 3; SPIKE_THRESH=8; end % std 
if nargin < 4; P=[3 .5 2]; end % 3 element vector for Ca event detection 1) onset 2) offest 3) min frames
if nargin < 5; method=1; end


SPIKE_FLAG=0;
rpm_type='avr';

% Get signal files
% accepts a dir, cell arrary of dirs, or .mat file
if iscell(in)
    % cell array of dirs
    signals_files={};
    for i=1:length(in)
        files = dir(fullfile(in{i}, '*.mat')); 
        fns={files.name}; % put fns in cell array
        signals_files=[signals_files strcat(in{i},fns)]; % add dir name 
    end
    
elseif isdir(in)
    files = dir(fullfile(in, '*.mat')); 
    fns={files.name}; % put fns in cell array
    signals_files=strcat(in,fns); % add dir name 
    
else
    % assume direct file, put in cell    
    signals_files={in};
end
    

% Get rpm files
files2 = dir(fullfile(rpm_path, '*.txt')); 
fns2={files2.name}; % put fns in cell array
rpm_files=strcat(rpm_path,fns2); % add dir name 

% START DATASET LOOP
for j=1:length(signals_files)
     
display(strcat('Starting: ',signals_files{j}));
[ raw, labels, tags ] = import_sima_mat(signals_files{j});

% sort by roi number 
[labels,x]=sort(labels);
tags=tags(x);

if (ndims(raw)>2);
    [num_frames, num_trials,num_rois]=size(raw);
    datasetType='Discrete';
    raw=raw(:,:,x); %sort
else
    [num_frames, num_rois]=size(raw);
    datasetType='Continuous';
    raw=raw(:,x); %sort
end

%% d/df
dF=deltaF(raw,2);
%% edge

% ind=find(~cellfun(@isempty,tags));
% skip_rois=labels(ind);

%% multi trace foopsi

SPIKES=struct;

if (SPIKE_FLAG)
    V.dt =1/imgHz;
    N=false(num_frames,num_rois); %intialize spike matrix
    for i=1:num_rois
        % ignore edge rois
        % note sure if this would break for multiple tags on roi
        if ~strcmp(tags{i},'edge')
            trace=double(dF(:,i));
            
            if (isempty(find(isnan(trace))))
                [Nhat]= fast_oopsi(trace,V);
                N(:,i)=Nhat>std(Nhat) * SPIKE_THRESH;
            else
                display(i);
            end
        end

    end
    
    SPIKES = v2struct(N,Nhat);

end
    %N(1,find(N(1,:)))=0; % delete spikes from 1st row, seems to be artifact 


%% Ca2+ event detection

switch datasetType
    case 'Continuous'
        EVENTS=detect_events(dF,3,.5,3);    

    case 'Discrete'
        onsetThreshold = P(1);
        offsetThreshold = P(2);
        minFramesAbove=P(3);

        onsets= permute(std(dF(baseline_frames,:,:)),[2 3 1]) * onsetThreshold;
        offsets=permute(std(dF(baseline_frames,:,:)),[2 3 1]) * offsetThreshold;

        [eventOnsets, eventLengths]=findOnset2(dF,onsets,offsets,minFramesAbove,frame_window);
        nEvents=cellfun(@numel,eventOnsets);
end


%% get info vars 
INFO=struct;
[path, fn]=fileparts(signals_files{j});
strings=strsplit(fn,'_');
animal=strings{1};
day=strings{2};
treatment=strings{3};
region= strings{4};
INFO=v2struct(path,fn,animal,day,treatment,region);
    
%% get rpm
rpm_file=match_sig_to_rpm_fn(signals_files{j});
switch rpm_type
    case 'rpm_lick'
     % t.Properties.VariableNames{1}(1)=='x' % check for old type
    BEHAVIOR=process_rpm_lick(rpm_file,num_frames);
    case 'avr'
    BEHAVIOR=process_tone_track(rpm_file);
end

%% put vars into struct
dataset{j}=v2struct(raw, dF, labels, tags, num_frames, num_rois, EVENTS,SPIKES, BEHAVIOR,INFO);

% report
display(strcat('Processed : ', animal, '_', day, '_', treatment, '_', region));

end
display(sprintf('***DONE***'));
end

