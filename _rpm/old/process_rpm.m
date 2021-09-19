function [ rpm ] = process_rpm(rpm,file,trial_duration)


%variables
rpmHz=20;
imgHz=10;
if nargin <3
    trial_duration=6; %seconds
end
rpmSampling=trial_duration*rpmHz;
thresh=3;
downSampleFactor=rpmHz/imgHz; %hack
endTrim=8; % changes based on imaging sample rate, 4Hz= 4,10Hz= 8



%[fn path] = uigetfile('*.txt');
%file=sprintf('%s\%s',path,fn);
read = csvread(file);


%have to subtract 5 hours unix time steps (18000000).RPM program records
%the time step as the time in GMT. We are current Centeral Daylight Savings
%Time (GMT-5). At some point this will need to be adjusted by 1 hour, when we are
%in Central Standard Time (GMT -6). Possibly.

%Unix epoch time is the number of miliseconds  that have elapsed since January 1, 1970 at 00:00:00 GMT (1970-01-01 00:00:00 GMT).

% For CDT, minus 5 hours
timeRPM=read(:,1)'-repmat(18e6,1,size(read,1)); 

% For CST, minus 6 hours
% timeRPM=read(:,1)'-repmat(216e5,1,size(read,1)); 

% had to change to 7 hours difference for an unexplained reason?
%timeRPM=read(:,1)'-repmat(25200000,1,size(read,1)); 


% Pre artifact filter:
% rpm value of 75> is a lurch artifact, while allows a
%double check. This may make some of my other lurch checkers uneccesary 
% Note: derivative may help 
while max(abs(read(:,2))>75)   
    aa=find(abs(read(:,2))>75);
    if (~isempty(find(aa==1))); aa(aa==1)=25;read(1,2)=read(25,2);end % take care of a pesky 1 index problem. 25 is random.
    bb=aa-1;
    read(aa,2)=read(bb,2);
end
    

for i=1:size(rpm,2)
    
    % Connects values from the rpm program and scanimage
    [~, idx] = min(abs(timeRPM-rpm{4,i}));
    
    % Sometimes the run data and scanimage time can never be aligned (e.g.
    % the run data was not turned on until the middle of the trial). This
    % prevents the function from throwing an error.
     if idx ==1 || idx == size(read,1)
        display(sprintf('Missing running data for trial %d',i));
        rpm{5,i}=zeros(1,rpmSampling); rpm{6,i}=zeros(rpmSampling,1);
        rpm{7,i}=zeros(rpmSampling,1); rpm{8,i}=zeros(rpmSampling/downSampleFactor,1);
        rpm{9,i}=0; % may change to zero, or good way of tracking missing data.
        rpm{10,i}=rpm{8,i};
        rpm{11,i}=0;
     else
        rpm{5,i}=timeRPM(1,idx:idx+(rpmSampling-1)); %grabs the times for the file

        %currRPM = read(idx:idx+(rpmSampling-1),2);
        rpm{6,i}= read(idx:idx+(rpmSampling-1),2); %get RPM values for the img window time
        rpm{7,i}=medfilt(abs(rpm{6,i}),15); % median filter
        rpm{8,i}=rpm{7,i}(1:downSampleFactor:length(rpm{7,i})); %downsample

        %end trim helps ignore the first and last few frames where lurch
        %artifiacts are common
        current_run=abs(rpm{8,i}(endTrim:end-endTrim));
        if length(find(current_run>thresh))> 3
            rpm{9,i}=1;
        else
            rpm{9,i}=0;
        end

        % Run time before the trial starts
        pre=read(idx-(rpmSampling-1):idx,2);
        preFilt=medfilt(abs(pre),15);
        rpm{10,i}= preFilt(1:downSampleFactor:length(preFilt));

        % this block checks for values that are 5 time the median value of the
        % run trace. These are replaced with the value previous value. This
        % elimiates 'lurch' artifacts.
        % run_artifact=find(rpm{10,i}>5*median(rpm{10,i})); %took this out,
        % does make sense when the median is too low (less than 1)
         run_artifact=find(rpm{10,i}>50);
        if any(run_artifact)
            for j=1:length(run_artifact)
                if(run_artifact(j)==1); run_artifact(j)=3;end % 1st element will throw error; this fixes
                rpm{10,i}(run_artifact(j))=rpm{10,i}(run_artifact(j)-1);
            end
        end

        % imgHz*2-1 should give two seconds in the standarized rpm an img
        % timescale; 3 in the if means the threshold must stay up from 3 frames
        last_pre_vector= abs(rpm{10,i}(end-(imgHz*1-1):end));
        if length(find(last_pre_vector>thresh))>3
            rpm{11,i}=1;
        else
            rpm{11,i}=0;
        end
        
     end

end


%% PLOTS

% % half max
% %hmax1=max(max(onlyRun))/2; min1=min(min(onlyRun));
% 
% % var
% allRun=cell2mat(rpm(8,:));
% 
% %no Run
% sigRunInd=find(cell2mat(rpm(9,:)));
% noRun=allRun; noRun(:,sigRunInd)=[];
% 
% %Run
% runInd=find(~cell2mat(rpm(9,:)));
% onlyRun=allRun; onlyRun(:,runInd)=[];
% 
% 
% % image plots
% %figure; imagesc(onlyRun',[min1 hmax1]); % half max plot
% figure; h1=imagesc(onlyRun'); title('Running Trials')
% figure; imagesc(noRun');  title('Stationary Trials')
% figure; hist(trapz(onlyRun)); title('AUC - Running Trials');
% figure; hist(trapz(noRun)); title('AUC - Stationary Trials')
% 
% 
% % line plots
% figure; plot(noRun) % trace running
% figure; plot(onlyRun); % pre-trace running
% num_pre_run = length(find(cell2mat(rpm(11,:))));
% num_run = length(find(cell2mat(rpm(9,:))));
% 
% % save
% %[rpm_folder,name] = fileparts(file);
% %saveas(h1,sprintf('%s%s_run_trials.png',rpm_folder(1:end-1),name)); % rpm folder has extra backslash to remove
% 
% 
% % %Check sampling
% % %x=matrix of values
% % %int= interval matrix
% % 
% x=timeRPM(1:10000); %or what ever range you want
% for i=1:size(x,2)-1; int(i)=x(i+1)-x(i); end
%     



end

