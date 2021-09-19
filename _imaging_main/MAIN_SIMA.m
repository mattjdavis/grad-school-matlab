% Framework to associate imaging data (from sima), eyeblink data, and
% running data

% Authorship:
%   Matthew J. Davis - University of Texas at Austin
%   mattdavis@utexas.edu
% 
% Changes
% 08/26/2015 - reworked from imagej import frame work, changes how
% variables are put into the final struct, changed some variable names (df,
% baseline_frames, mean_baseline, num_trials).


clear all;

% BATCH OR SINGLE MODE
choice = questdlg('Intiate multiday mode?', ...
	'Choose processing mode', ...
	'Batch','Single','Single');

switch choice
    case 'Batch'
        disp([choice ': Launching multiday mode in 3...2...1...']);
        PathName = uigetdir(cd,'Select the folder containing mat files');
        %RoiFiles = dir(PathName,'*.xlsx');
        Files = dir(fullfile(PathName, '*.mat'));
        Files = {Files.name}';
        addpath(PathName); 
    case 'Single'
        disp([choice ': Launching single day mode in 3...2...1...']);
        [FileName,PathName] = uigetfile('.mat', 'Select the mat file');
        Files={FileName};
        addpath(PathName); %search path
end

% NEW OR OLD STRUCT
% cancel this prompt makes a new animal struct
[file2, path2] = uigetfile('.mat', 'Select the struct');
if path2 == 0
    S=struct;
    baseline_frames=1:20; % HACK
    num_frames=60; % HACK
    animal=strsplit(Files{1},'_'); animal=animal{1}; S.(animal)=struct;
else
    addpath(path2);S=load(file2);
    animal=cell2mat(fieldnames(S));
    baseline_frames=1:20;
    num_frames=60;
end

for k = 1:length(Files)
    
    % parse file name
    fn=Files{k};
    fn_split=strsplit(fn,'_');
    animal_name=fn_split{1};
    day_name=fn_split{2};
    roi_name=strsplit(fn_split{3},'.'); roi_name=sprintf('roi_%s',roi_name{1}); 
    
    % track processing
    display(sprintf('FILE %d of %d: %s',k,length(Files),fn));
    
    % day struct
    if isfield(S.(animal_name), day_name); 
        %do nothing
    else  
       S=new_day_struct(S,animal_name,day_name);
    end
    
    % roi struct
    if isfield(S.(animal_name).(day_name), roi_name)
        error('Roi already processed. Try again');
    else
        S.(animal_name).(day_name).(roi_name)=struct;
    end
   
    % read excel file
    [ raw_fluor, roi_labels, roi_tags ] = import_sima_mat(fn);
    [num_frames, num_trials, num_rois] = size(raw_fluor);
    total_frames=num_trials*num_frames;
    
    % sort raw fluor by labels, 09.10.2015
    [roi_labels,idx]=sort(roi_labels);
    raw_fluor=raw_fluor(:,:,idx);
    
    % df/f
    bl=mean(raw_fluor(baseline_frames,:,:));
    bl=repmat(bl,num_frames,1);
    dF=((raw_fluor-bl)./bl)*100;
    mean_baseline= reshape(bl(1,:,:),num_trials,num_rois); % for output struct
      
    % RPM
%     if isempty(S.(animal_name).(day_name).rpm)     
%         rpm_path =strcat('X:\\imaging\\',animal_name,'\\rpm\\');
%         rpm_file=strcat(animal_name,'_',day_name,'.txt');
%         image_folder=strcat('X:\\imaging\\',animal_name,'\\raw\\',day_name);
%         %[rpm_file,rpm_path]= uigetfile('.txt', 'Select RPM text file');
%         %image_folder = uigetdir(cd,'Select raw imaging folder');
%         rpm = create_rpm_mat(strcat(rpm_path,rpm_file),image_folder);
%         S.(animal_name).(day_name).rpm = rpm;
%     end

    % RPM 2 - Jan 2015 Rpm code changed (when ttl implemented)
    if isempty(S.(animal_name).(day_name).rpm)
        rpm_path =strcat('X:\\imaging\\cyclops\\',animal_name,'\\rpm\\');
        %fn=uigetfile('.mat', 'Select the mat file');
        rpm_files = dir(fullfile(rpm_path, '*.mat')); 
        rpm_files2 = {rpm_files.name}';
        match = cellfun(@(x) ~isempty(strfind(x,strcat(animal_name,'_',day_name))), rpm_files2);
        
        load(strcat(rpm_path,rpm_files2{match}));
        
        S.(animal_name).(day_name).rpm = rpm;
    end

    % EYEBLINK
    % (1) if there is more than cr day on a day, there is a vulnerability so watch
    % out.
    % (2) Need rpm loaded to get the date string. Could also come from tif.
    % eventually, if rpm is too difficult to manage.
    % (3) Need to get the waterfalls into the right place.
    
%     if isempty(fields(S.(animal_name).(day_name).eb))
%         if ~(isempty(S.(animal_name).(day_name).rpm))
%             
%             % get date is proper format
%             date = S.(animal_name).(day_name).rpm{2,1};
%             date = strsplit(date,' '); date=date{1};
%             out_format = 'yymmdd';
%             eb_date = datestr(date,out_format);
%             
%             %eb_path = uigetdir(cd,'Select eyeblink folder');
%             eb_data = prep_eb_import(animal_name,eb_date,day_name);
%             
%             S.(animal_name).(day_name).eb = eb_data;
%         else
%             display('No RPM, CR NOT LOADED');
%         end
%     else
%         display('Eyeblink already in struct');
%     end


    if isempty(fields(S.(animal_name).(day_name).eb))
        if ~(isempty(S.(animal_name).(day_name).rpm))
            
            path_info=strcat('X:\\imaging\\cyclops\\',animal_name,'\\raw\\', day_name,'\\info\\');
            Files2 = dir(fullfile(path_info, '*.txt'));
            info = importdata(strcat(path_info,Files2(1).name));
            match = cellfun(@(x) ~isempty(strfind(x,'triggerTimeString')), info);
            str=info{match}; date=str(35:43); % 35:43 should be the right positions
            out_format = 'yymmdd';
            eb_date = datestr(date,out_format);
            
            %eb_path = uigetdir(cd,'Select eyeblink folder');
            eb_data = prep_eb_import(animal_name,eb_date,day_name);
            
            S.(animal_name).(day_name).eb = eb_data;
        else
            display('No RPM, CR NOT LOADED');
        end
    else
        display('Eyeblink already in struct');
    end

    % TRIAL TYPE
    % (1) Best to fill after CR is already loaded
%     method = questdlg('Trial type fill method:', ...
% 	'Trial Type Question', ...
% 	'acc','standard','auto','auto');

    if(strfind(day_name,'acc'))
        method='acc'
    elseif (strfind(day_name,'td'))
        method='standard';
    end
    
    tt=fill_trial_type(S.(animal_name).(day_name), num_trials,method)
    S.(animal_name).(day_name).trial_type=tt;
    
        

    % final data/report
    D= v2struct(raw_fluor, dF, num_frames, num_trials, num_rois,...
        total_frames,mean_baseline, baseline_frames, roi_labels, roi_tags)
    S.(animal_name).(day_name).(roi_name)=D; %save all the processed data
    display(sprintf('File processed: %s',fn));
end

