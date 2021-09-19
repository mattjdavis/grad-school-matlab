%%PROCESS RPM TTL
%
% In December of 2015 the rpm arduino and processing files were updated on
% the scientifica 2P rig. RC and JS modified ND original files. It can
% handle 2 wheels, and records the start trigger TTL. They also removed the
% expontential decay in the RPM calculation.
%
% Purpose:
% (1) Read in all rpm files from a single folder, put into .mat file, and
% distribute that file inside the animal folder. Check if .mat already
% exists.
% (2) Grab the rpm data for 6 seconds before and after the trial start.
% (3) Remove outliers and noise in rpm trace.
% (4) Currenly reads and saves all files in one folder, may distribute the
% processed mat files into subfolder auto or manual.

% Caution:
% (1) If run crashes before trial is over
% (2) If
% (3) Check the number of trials, sampling frequency of everthing.
% (4) I grab 7 (6+1) seconds before eyeblink ttl starts, hopefull I started
%     the run. Fix: I can add a bunch of zero lines
%
% Add:
% - if missing trials, catch those, and track them in info




main_rpm_dir='X:/imaging/AdImg/2P/rpm/';

text_files = dir(fullfile(main_rpm_dir, '*.txt')); text_files={text_files.name};
mat_files = dir(fullfile(main_rpm_dir, '*.mat'));  mat_files={mat_files.name};
    
rr=struct;
for i=1:length(text_files)
 
    %text_file = strcat(main_rpm_dir, '\\',text_files(i).name);
    
    % look for text file name in list of mat_files
    file=text_files{i};
    fn=strsplit(file,'.');
    IndexC = strfind(mat_files, fn{1});
    
    if(any(~cellfun('isempty', IndexC))==0)
        % no match found, process file
        display('Mat file not found. Processing RPM');
        
        [rpm]=import_rpm_ttl(strcat(main_rpm_dir, file), 40);
        
        save(strcat(main_rpm_dir,fn{1},'_rpm.mat'),'rpm','-mat')
    else
        display('Mat file found. Skipping RPM');
    end
    
    % use this code if the index of the match matters
    %Index = find(not(cellfun('isempty', IndexC)));
   
%     if (~strcmp(text_file,mat_file))
%         =[text_files strcat(path,text_files(i).name)];
%     end
%     
    
    
    
end


%% get two list, mat and text. use regexp to just match before period.