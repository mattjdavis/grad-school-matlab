%size of numFile should only be .tif dependent

clear all;
path = uigetdir;

files = dir(fullfile(path, '*.tif'));
%f=repmat(files,1,3); files(1:10,1)=f(11:20,1); files(11:60,1)=f(21:70,1); files(61:70,1)=f(1:10,1); %hack sort

numFiles = size(files,1);
rpm=cell(1,numFiles);

for i=1:numFiles
    currFile = strcat(path, '\',files(i).name);
    if (findstr(currFile,'tif')~=0)
        h = scim_openTif(currFile);
        time = h.internal.triggerTimeString;
        
        rpm{1,i} = currFile;
        rpm{2,i} = time;
        rpm{3,i} = datenum(time);
        rpm{4,i} = round(((datenum(time))-datenum(1970,1,1))*86400*1000); %need the 1000 to get ms
    end
end    