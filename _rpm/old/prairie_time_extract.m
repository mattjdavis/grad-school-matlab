function [T] = PraireTimeExtract(fn)
%Reads XML info file from Priare viewer and outputs start time of each
%sequence in Matlab serial time.
%3/2014, Matt James Davis, University of Texas - Austin

%datestr(x,'dd-mmm-yyyy HH:MM:SS:FFF') %check string format of dates
%sprintf('%.10f', T.unix_times(1)) % for long numbers


xmlstr = fileread(fn); V = xml_parseany(xmlstr);
T.file=fn;

trials=size(V.Sequence,2);
t={};
for i=1:trials
    t{i}=V.Sequence{1,i}.ATTRIBUTE.time;
    
    %slight bug fix; sometimes time is 8 char instead of 16
    if length(t{i}<10); t{i}=[t{i} '.0000000']; end;
end
date=V.ATTRIBUTE.date;
date=date(1:9);

%parse date
% MO=str2num(date(1));
% D=str2num(date(3:4));
% Y=str2num(date(6:9));
[Y,MO,D]=datevec(date);

%parse time add to times vector (in Matlab serial time)
for i=1:trials
    xt=t{i};
    H=str2num(xt(1:2));
    MI=str2num(xt(4:5));
    S=str2num(xt(7:12)); %get rid of last 3 digits in seconds fraction
    mtime=datenum(Y,MO,D,H,MI,S);
    T.mat_times(i)=mtime;
    T.unix_times(i)= round((mtime-datenum(1970,1,1))*86400*1000); %need the 1000 to get ms
end





end

