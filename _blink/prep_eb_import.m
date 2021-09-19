function [eb_data] = prep_eb_import(animal_name,eb_date,day_name)
% 
% 7-14-15, added check for matlab file and save for matlab file
% TODO:
% (1) code in if more than one cr found, to manually select files, 
% (2) reconcile save, date is the day name, not my system of naming.
% 

eb_path = strcat('X:\\eyeblink\\+processed\\',animal_name,'\\');
expressions={'CR','latency2max','latency2crit','maxAmp', 'WaterFall'};
eb_data=struct;

% path = strcat(eb_path,animal_name);
files = dir(fullfile(eb_path, '*.txt'));

file_struct=struct2cell(files);
file_names=file_struct(1,:);

matlab_fn=strcat(eb_path,animal_name,'_',day_name,'_eb.mat');

if ~exist(matlab_fn, 'file')
    for i=1:length(expressions)

        %find the matching filename
        match_string=strcat(expressions{i},'_',eb_date);
        match_cell= regexp(file_names,match_string);
        [~,b]=find(~cellfun(@isempty,match_cell));

        if isempty(b)
            display(strcat('File not found:', match_string));
            %display('EB data not found, please process the data is needed');
            
            % how will I handle not found file?  
        elseif length(b) > 1
            % need to select in the case more than one found
            [fn,~] = uigetfile('.txt',strcat('choose :',expressions{i}));
            d = import_eb_data(strcat(eb_path,'\\',fn),expressions{i}); 
            
            % add info to struct
            S = struct('file_name', fn, 'raw_data', d);
            eb_data.(expressions{i})= S;
        elseif length(b)==1
            fn=file_names{b};

            % get raw data file
            d = import_eb_data(strcat(eb_path,'\\',fn),expressions{i}); 

            % add info to struct
            S = struct('file_name', fn, 'raw_data', d);
            eb_data.(expressions{i})= S;
                
        end



    end
    
    save(matlab_fn,'eb_data');
else
    load(matlab_fn,'eb_data');
    
    
end
    
    %save(strcat(eb_path,'\\',animal_name,'_',day_name,'_eb','.mat'),'eb_data');
  
end