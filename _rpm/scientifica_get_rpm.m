function [ rpm ] = scientifica_get_rpm(image_data_path,time)

%path = uigetdir;

if nargin < 2
    time=[];
end

files = dir(fullfile(image_data_path, '*.tif'));
%f=repmat(files,1,3); files(1:10,1)=f(11:20,1); files(11:60,1)=f(21:70,1); files(61:70,1)=f(1:10,1); %hack sort

numFiles = size(files,1);
rpm=cell(1,numFiles);

% supress warning:
% w = warning('query','last')
% id = w.identifier
id='MATLAB:imagesci:tiffmexutils:libtiffWarning';
warning('off',id);

for i=1:numFiles
    

    
    % This code is for time that have not been opened in imagej, new
    % workflow developed in 07/2015
    % file = strcat(image_data_path, '\',files(i).name);
    % h = scim_openTif(file);
    % time = h.internal.triggerTimeString;
    
    
    % is allows direct time input
    % modified info gathering code, hacky file location for txt, because
    % base on finding tif file.
    if isempty(time)
        file = strcat(image_data_path, '\', 'info', '\',files(i).name);
        file = strrep(file,'tif','txt');

        image_info=importdata(file);
        image_info(1)=[]; % remove 1st cell contains extra text
        time=image_info(186);
        time=strrep(time,'state.internal.triggerTimeString=','');
        time=time{1}(2:end-1);
        % or find for this variable, in the image_info cell array
        %state.internal.triggerTimeString
        
        rpm{1,i} = file;
    end

    
    rpm{2,i} = time;
    rpm{3,i} = datenum(time);
     rpm{4,i} = round(((datenum(time))-datenum(1970,1,1))*86400*1000);%need the 1000 to get ms
    % 07/31/2015, the 1000 may may now be irrelevant 
     %rpm{4,i} = round(((datenum(time))-datenum(1970,1,1))*86400)/1000;
     
     time=[];
end    

end

