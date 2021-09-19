% Purpose:
%   Reads an xlsx file generated from the mutimeasure function in imagej.
%   Will accept any number of ROIs. For a new analsis, you may need to change
%   BaselineFrames(usually 20) and the TrialFrames (50 for 5 second, 10Hz
%   scan). 
%
%   NOTE: must adhere to the following file format for reading roi files:
%   'md036_td01_RoiA.xlxs' CASE SENSITIVE!
%
% Input:
%   x : blank.
%
% Output:
%   xx: blank.
%
% Example:
%   Blank.
%
% Authorship:
%   Matthew J. Davis - University of Texas at Austin
%   mattdavis@utexas.edu

% TO D0
% 4) handle of trial_type method is incomplete, need to add automatic, need
% Main is to fix how the trial types are handled and generated, especially
% with random presentation.
% + handle load of CR mat if present, and output that file was found.


clear all;
D=struct;

clear a
% BATCH OR SINGLE MODE
choice = questdlg('Intiate multiday mode?', ...
	'Choose processing mode', ...
	'Batch','Single','Single');

switch choice
    case 'Batch'
        disp([choice ': Launching multiday mode in 3...2...1...']);
        PathName = uigetdir(cd,'Select the folder containing Excel files');
        %RoiFiles = dir(PathName,'*.xlsx');
        Files = dir(fullfile(PathName, '*.xlsx'));
        Files = {Files.name}';
        addpath(PathName); 
    case 'Single'
        disp([choice ': Launching single day mode in 3...2...1...']);
        [FileName,PathName] = uigetfile('.xlsx', 'Select the Excel file');
        Files={FileName};
        addpath(PathName); %search path
end



% NEW OR OLD STRUCT
[file2, path2] = uigetfile('.mat', 'Select the struct');
if path2 == 0
    %code for cancel, make new struct
    S=struct;
    %animal = input('What is the name of this subject?','s');
    %bl_frames = input('Basline frame vector?'); %put at 6:20 due to first frames cut off in some data.
    %num_frames = input('Number of frames per trial?');
    bl_frames=1:20;
    num_frames=60;
    animal=strsplit(Files{1},'_');
    animal=animal{1};
    S.(animal)=struct;
else
    addpath(path2);S=load(file2);
    animal=cell2mat(fieldnames(S));
end

% FILE PREP
% Expects (Area,Mean, Min, Max) from ImageJ file.
Read = xlsread(Files{1}); %only grabs first file
Read(:,1) = []; %Remove the 1st column
[total_frames, num_cells] =size(Read);
num_cells=num_cells/4;
num_traces=total_frames/num_frames;
num_days=length(Files);

% ADD VARS TO STRUCT
D.num_traces=num_traces; 
D.num_cells=num_cells;
D.num_frames=num_frames;
D.total_frames=total_frames;
D.bl_frames=bl_frames;

% INITIALIZE MATRICES
D.raw_data= zeros(num_frames,num_traces,num_cells);
D.data= zeros(num_frames,num_traces,num_cells);
D.avg_bl= zeros(num_traces,num_cells);
read_data= zeros(total_frames,num_cells);

% warning supression
id='MATLAB:oldPfileVersion';
warning('off',id);

% counter
count=1;

for k = 1:num_days
    
    % parse file name
    fn=Files{k};
    fn_split=strsplit(fn,'_');
    animal_name=fn_split{1};
    if (length(fn_split)>4)
        day_name=fn_split{2};
        day_name=sprintf('%s_%s',fn_split{2}, fn_split{3});
        roi_name=strsplit(fn_split{5},'.'); 
        roi_name=sprintf('roi_%s',roi_name{1}); 
    else
        day_name=fn_split{2};
        roi_name=strsplit(fn_split{4},'.'); 
        roi_name=sprintf('roi_%s',roi_name{1}); 
    end
    %data.DayName=fn_split(2); data.AnimalName=fn_split(1); data.RoiName=fn_split(4);
    
    % track processing
    display(sprintf('FILE %d of %d: %s',count,length(Files),fn));
    count = count +1;
    
    % day struct
    if isfield(S.(animal_name), day_name); 
        %do nothing
    else  
       S=new_day_struct(S,animal_name,day_name);
       %[~,path] = uigetfile('.xlsx', 'Excel with Trial Type Index');
       %s.(AnimalName).(DayName).trial_type = import_stim_index('','manual',DayName);
    end
    
    % roi struct
    if isfield(S.(animal_name).(day_name), roi_name)
        error('Roi already processed. Try again');
    else
        S.(animal_name).(day_name).(roi_name)=struct;
    end
   
    % read excel file
    Read = xlsread(Files{k}); %only grabs first file
    Read(:,1) = []; %Remove the 1st column
    
    % extract avg intensity column from import
    for i=0:num_cells-1
        read_data(:,i+1)= Read(:,2+(4*i));
    end
    
    % df/f
    F= reshape(read_data,num_frames,num_traces,num_cells);
    bl_vec=F(bl_frames,:,:);
    bl_avg=mean(bl_vec);
    
    bl=repmat(bl_avg,num_frames,1);
    dF=((F-bl)./bl)*100;
    
    % alternative df/f
%     bl_med=median(read_data);
%     bl=repmat(bl_med,num_frames,num_traces,1);
%     bl=reshape(bl,num_frames,num_traces,num_cells);
%     dF_med=((F-bl)./bl)*100;
    
    
    % read date, for cr
    
    % get rpm
    % TODO: make getting files more automatic.
    if isempty(S.(animal_name).(day_name).rpm)
        
        rpm_path =strcat('X:\\imaging\\',animal_name,'\\rpm\\');
        rpm_file=strcat(animal_name,'_',day_name,'.txt');
        image_folder=strcat('X:\\imaging\\',animal_name,'\\raw\\',day_name);
        %[rpm_file,rpm_path]= uigetfile('.txt', 'Select RPM text file');
        %image_folder = uigetdir(cd,'Select raw imaging folder');
        rpm = create_rpm_mat(strcat(rpm_path,rpm_file),image_folder);
        
        S.(animal_name).(day_name).rpm = rpm;
    end
    
    % Get CR
    % (1) if there is more than cr day on a day, there is a vulnerability so watch
    % out.
    % (2) Need rpm loaded to get the date string. Could also come from tif.
    % eventually, if rpm is too difficult to manage.
    % (3) Need to get the waterfalls into the right place.
    
    if isempty(fields(S.(animal_name).(day_name).eb))
        if ~(isempty(S.(animal_name).(day_name).rpm))
            
            % get date is proper format
            date = S.(animal_name).(day_name).rpm{2,1};
            date = strsplit(date,' '); date=date{1};
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

    % fill trial type
    % (1) Best to fill after CR is already loaded
    % 
    method = questdlg('Trial type fill method:', ...
	'Trial Type Question', ...
	'acc','standard','auto','auto');
    
    tt=fill_trial_type(S.(animal_name).(day_name), num_traces,method)
    S.(animal_name).(day_name).trial_type=tt;
    
    
        

    % roi stuct
    D.raw_data= F;
    D.data= dF;
    D.avg_bl= reshape(bl_avg,num_traces,num_cells);
    
    
    S.(animal_name).(day_name).(roi_name)=D; %save all the processed data
    
    
    display(sprintf('File processed: %s',fn));
end

