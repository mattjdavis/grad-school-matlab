function [ T ] = PraireReadRPM(T,file)

%have to subtract 5 hours unix time steps (18000000).RPM program records
%the time step as the time in GMT. We are current Centeral Daylight Savings
%Time (GMT-5). At some point this will need to be adjusted by 1 hour, when we are
%in Central Standard Time (GMT -6). Possibly.
%Unix epoch time is the number of miliseconds  that have elapsed since January 1, 1970 at 00:00:00 GMT (1970-01-01 00:00:00 GMT).

%To do: catch cases where there is no match between rpm times and img start
%times

%'dd-mmm-yyyy HH:MM:SS:FFF'

%variables
rpmHz=5;
imgHz=10; %may npot be exact
trialLength=5; %seconds
rpmSampling=trialLength*rpmHz;

%read txt file
% [fn, path] = uigetfile('*.txt');
% file=sprintf('%s\%s',path,fn);
% addpath(path); %search path
read = csvread(file);

%includes adjust for GMT -> CDT.
for i=1:size(read,1)  
    timeRPM(1,i)=read(i,2)-18000000; 
end

for i=1:size(T.unix_times,2)
    
    %grab vector of matched running times in File
    [~, idx] = min(abs(timeRPM-T.unix_times(i)));
    T.rpm_times(i,:)=timeRPM(1,idx:idx+(rpmSampling-1));
    
    %get RPM values for the img window time
    currRPM = read(idx:idx+(rpmSampling-1),1);
    T.rpm_value(i,:)= currRPM; 

    %Upsample the running data
    upRPM = zeros(1,2*numel(currRPM));
    upRPM(1:2:end) = currRPM;
    for j=1:(size(currRPM,1)-1)
        upRPM(j*2)=(currRPM(j,1)+currRPM(j+1,1))/2;   
    end
    upRPM(1,50)=upRPM(49); %hacky
    T.rpm_up(i,:)= upRPM;

end


T.rpm_up_long=reshape(T.rpm_up',1,[]);


% %Check sampling
% %x=matrix of values
% %int= interval matrix
% x=timeRPM(1:10000); %or what ever range you want
% for i=1:size(x,2)-1; int(i)=x(i+1)-x(i); end



end

