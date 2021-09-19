
%variables
rpmHz=20;
imgHz=10;
trialLength=6; %seconds
rpmSampling=trialLength*rpmHz;
thresh=5;
downSampleFactor=rpmHz/imgHz; %hack
endTrim=6; % changes based on imaging sample rate, 4Hz= 4,10Hz= 8



[fn path] = uigetfile('*.txt');
file=sprintf('%s\%s',path,fn);
read = csvread(file);


%have to subtract 5 hours unix time steps (18000000).RPM program records
%the time step as the time in GMT. We are current Centeral Daylight Savings
%Time (GMT-5). At some point this will need to be adjusted by 1 hour, when we are
%in Central Standard Time (GMT -6). Possibly.

%Unix epoch time is the number of miliseconds  that have elapsed since January 1, 1970 at 00:00:00 GMT (1970-01-01 00:00:00 GMT).


for i=1:size(read,1)
%timeRPM(1,i)=unixtime2mat(read(i,1));
timeRPM(1,i)=read(i,1)-18000000; 
end

for i=1:size(rpm,2)
    
    [~, idx] = min(abs(timeRPM-rpm{4,i}));
    rpm{5,i}=timeRPM(1,idx:idx+(rpmSampling-1)); %grabs the times for the file

    %currRPM = read(idx:idx+(rpmSampling-1),2);
    rpm{6,i}= read(idx:idx+(rpmSampling-1),2); %get RPM values for the img window time
    rpm{7,i}=medfilt(abs(rpm{6,i}),15); % median filter
    rpm{8,i}=rpm{7,i}(1:downSampleFactor:length(rpm{7,i})); %downsample

    if max(abs(rpm{8,i}(endTrim:end-endTrim)))>thresh
        rpm{9,i}=1;
    else
        rpm{9,i}=0;
    end

    % Run time before the trial starts
    pre=read(idx-(rpmSampling-1):idx,2);
    preFilt=medfilt(abs(pre),15);
    rpm{10,i}= preFilt(1:downSampleFactor:length(preFilt));

    % imgHz*2-1 should give two seconds in the standarized rpm an img
    % timescale
    if max(abs(rpm{10,i}(end-(imgHz*2-1):end)))>thresh
        rpm{11,i}=1;
    else
        rpm{11,i}=0;
    end

end

%plotting
allRun=cell2mat(rpm(8,:));

%no Run
sigRunInd=find(cell2mat(rpm(9,:)));
noRun=allRun; noRun(:,sigRunInd)=[];

%Run
runInd=find(~cell2mat(rpm(9,:)));
onlyRun=allRun; onlyRun(:,runInd)=[];
%%
%hmax1=max(max(onlyRun))/2; min1=min(min(onlyRun));

%plotting
%figure; imagesc(onlyRun',[min1 hmax1]); % half max plot
figure; imagesc(onlyRun'); title('Running Trials')
figure; imagesc(noRun');  title('Stationary Trials')
figure; hist(trapz(onlyRun)); title('AUC - Running Trials');
figure; hist(trapz(noRun)); title('AUC - Stationary Trials')

% additional plots
figure; plot(cell2mat(rpm(8,:))) % trace running
figure; plot(cell2mat(rpm(10,:))); % pre-trace running
% num_pre_run = length(find(cell2mat(rpm(11,:))))
% num_run = length(find(cell2mat(rpm(9,:))))


% 
% %Check sampling
% %x=matrix of values
% %int= interval matrix
% 
% x=timeRPM(1:10000); %or what ever range you want
% for i=1:size(x,2)-1; int(i)=x(i+1)-x(i); end
%     
