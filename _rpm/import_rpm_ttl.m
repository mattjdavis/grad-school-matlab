function [rpm] = import_rpm_ttl(text_file, num_trials)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% THIS IS HACKY, acc=60, all else = 80
if (nargin < 2)
    if ~isempty(strfind(text_file,'acc'))
        num_trials = 60;
    else
        num_trials = 80;
    end
end


num_frames=80;
trial_duration = 8; % seconds
rpm_SR = 20; %hz
FILTER_WINDOW=30; % could make relavive to sampling rate.
DS_FACTOR = 2; % could make relative to img and rpm SR
RUN_CEILING = 60;
RPM_THRESH=3.5;
THRESH_LENGTH=4; %frames above thresh (right now not consecutive frames)


% Grab TTL Index
% Note on text file columns, rpm=2, ttl=4
% I have more TTLs than actualy behavior trials (b/c of pre behavior
% testing in eyeblink). The last line here only grabs the presumably
% relevant TTLs, the last ttl = last actual eyeblink trial. There is never
% a case (hopefully) where I run additional eyeblink trials.
read = csvread(text_file);
rpm=read(:,2);
ttl_index=find(read(:,4));
ttl_index=(ttl_index(length(ttl_index)-(num_trials-1):length(ttl_index)));

% Get RPM Trace using TTL index
% rpm_hz usually 20hz. Want to grab 6s before trial start.
% After last ttl, need to grab trial duration, + 5 seconds
start=ttl_index(1)-(rpm_SR*(trial_duration+1));
stop=ttl_index(end)+(trial_duration*rpm_SR);%+(rpm_SR*6);
run=rpm(start:stop,1);

% adjust TTL index to match rpm trace
% Divided by DS_FACTOR can cause non itegerr result, not good for indexes;
% I use these indexes later, so I wonder if there is a better way to
% rectify downsample and these indexes.
ttl_index_full=round((ttl_index-start)/DS_FACTOR);

% CLEAN RUN TRACE %

% med filt gets rid of extreme values, often big positive spikes
run=medfilt(run,3);

% remove high and low
%ind = find(run>60);run( = mean(run;ind)
% This sets a ceiling, no run can be above 60; could make this threshold
% relative to standard deviation of run (so not a hard limit), also could
% do actual interpolation looking at local values.
run( run>RUN_CEILING )=mean(run);
% min value, set to zero to get rid of negative, -25 is ok
ind = find(run<0);run(ind) = 0;

% moving avg filter
k = ones(1, FILTER_WINDOW) / FILTER_WINDOW;
full_run = conv(run, k, 'same');
 
% downsample, 20hz rpm --> 10 hz imaging, factor of 2
ds_run=downsample(full_run,DS_FACTOR);

% butter worth filter for extra smoothing, .02 based on qualitative
% assesment
% [b,a] = butter(2,.02);
% y = filtfilt(b,a,sig);

%% save parameters in info

info=v2struct(trial_duration, rpm_SR ,FILTER_WINDOW,DS_FACTOR, RPM_THRESH, THRESH_LENGTH,RUN_CEILING,num_trials,text_file);


%% Put into run trace into matrix, find events using  a threshold

pt_run_events=zeros(num_trials,1);
run_events=zeros(num_trials,1);

for i=1:num_trials
    ind1=ttl_index_full(i)-trial_duration*(rpm_SR/DS_FACTOR); 
    ind2=ttl_index_full(i)+trial_duration*(rpm_SR/DS_FACTOR); 
    
    pre_trial_run(i,:)= ds_run(ind1:ttl_index_full(i)-1); % don't include start trigger
    trial_run(i,:)=ds_run(ttl_index_full(i):ind2-1); % don't include last element, include start trigger
    
    
    if (length(find(pre_trial_run(i,:)> RPM_THRESH))>THRESH_LENGTH); pt_run_events(i)=1; end
    if (length(find(trial_run(i,:) > RPM_THRESH))>THRESH_LENGTH); run_events(i)=1; end
end



%% Place variables into struct
rpm=v2struct(full_run,...
    ds_run,...
    ttl_index_full,...
    trial_run,...
    pre_trial_run,...
    pt_run_events,...
    run_events,...
    info);


%% PLOT TESTING

% %Title
% [~,T,~]=fileparts(text_file);
% 
% figure; hold on;
% plot(ds_run);
% scatter(ttl_index_full,ones(num_trials,1)*20);
% title(T);
% 
% 
% %
% if (num_trials==80)
%     figure;
%     hold on; 
%     
%     plot(mean(trial_run(1:10,:)),'--');
%     plot(mean(trial_run(71:80,:)),'--');
%     plot(mean(trial_run(11:70,:)));
%     plot(mean(pre_trial_run(71:80,:)));
%     
%     title(T);
% 
%     figure; imagesc(trial_run);
%     
%     title(T);
% end


% 
% % Using a cutoff of y>=0.5
% belowCutoff       = y;
% belowCutoff(y>=0) = NaN;  % Replace points above cutoff with NaNs; 
% figure;
% plot(x,y,'r',x, belowCutoff, 'b');


figure; hold on;

nudge=num_frames+5;
for i=1:num_trials
    if(run_events(i,1)==1)
        plot((1:num_frames)+i*nudge,trial_run(i,:)','r');
    else
        plot((1:num_frames)+i*nudge,trial_run(i,:)','b');
    end
end
       
end

% 12.09.2015
% Testing median filter vs avg filter. Median way more noisy. 20 seems like
% a reasonable window for 20 hz sample (1 second window).

% 12.16.2015
% Hard ceiling at 60 ( extreme high values are turned into the median)
% Hard cloor at 0 (ie negative values = 0 );
% Moving avg filter for smoothing.

