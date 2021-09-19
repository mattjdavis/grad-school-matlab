
%variables
rpmHz=5;
imgHz=10;
trialLength=5; %seconds
rpmSampling=trialLength*rpmHz;



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

for i=1:size(startTime,2)
    
    
[~, idx] = min(abs(timeRPM-startTime{4,i}));
startTime{5,i}=timeRPM(1,idx:idx+(rpmSampling-1)); %grabs the times for the file

currRPM = read(idx:idx+(rpmSampling-1),2);
startTime{6,i}= currRPM; %get RPM values for the img window time



%%Upsample the running data%%
upRPM = zeros(1,2*numel(currRPM));
upRPM(1:2:end) = currRPM;

for j=1:(size(currRPM,1)-1)
    upRPM(j*2)=(currRPM(j,1)+currRPM(j+1,1))/2;   
end
upRPM(1,50)=upRPM(49); %hacky
startTime{7,i} = upRPM;

end




% 
% %Check sampling
% %x=matrix of values
% %int= interval matrix
% 
% x=timeRPM(1:10000); %or what ever range you want
% for i=1:size(x,2)-1; int(i)=x(i+1)-x(i); end
%     
