%% 

% check for already existing .mat file before processing rpm.
path='X:\\imaging\\cyclops\\md075\\rpm\\';
text_files = dir(fullfile(path, '*.txt'));
mat_files = dir(fullfile(path, '*.mat'));

files=cell(0,0);
for i=1:length(text_files)
    [~,text_name,~]=fileparts(text_files(i).name);
    
    %take care of the case where there is non .mat files
    if (~isempty(mat_files))
        [~,mat_name,~]=fileparts(mat_files(i).name);
    else
        mat_name ='none';
    end
    
    % compare the .mat and .txt files, no matches indicates that the rpm
    % file will be processed in the next step.
    if (~strcmp(text_name,mat_name))
        files=[files strcat(path,text_files(i).name)];
    end
end

%% create rpm.mat files, by day and animal
% days={'acc01','acc02','acc03',...
%     'td01','td02','td03','td04', 'td05',...
%     'td06', 'td07', 'td08', 'td09', 'td10', 'td11'};

days={'td15_pyr'};
%days={'td09', 'td10', 'td11'};
%animals={'md075', 'md076','md078','md079','md081'};
animals={'md076'};


path_name='x:\\imaging\\cyclops';

for j=1:length(animals)
    animal_name=animals{j};
    for i=1:length(days)
        day_name=days{i};
        %raw_folder=sprintf('%sraw\\%s\\',path_name,day_name);
        raw_folder=sprintf('%s\\%s\\%s\\',path_name,animal_name,day_name);
        rpm_file=sprintf('%s\\%s\\rpm\\%s_%s.txt',path_name,animal_name,animal_name,day_name);
        rpm = scientifica_get_rpm(raw_folder);
        rpm = process_rpm(rpm,rpm_file);
        
        save(sprintf('%s\\%s\\rpm\\%s_%s.mat',path_name,animal_name,animal_name,day_name),'rpm');
    end
    close all;
end


%% load a collection of rpm.mat files

%animals={'md061','md062','md063','md064','md065','md067'};
animals={'md075','md076','md078','md079','md081'};

trial_num=80;

for j=1:length(animals)
    path=sprintf('x:\\imaging\\cyclops\\%s\\rpm\\td',animals{j});
    files = dir(fullfile(path, '*.mat'));
    run=cell(1,length(files));

    for i=1:length(files)
        file = strcat(path, '\\',files(i).name);
        run{i}=load(file); % worried about the order of the load, and a cell array of structs, gross
    end


    for i=1:length(run)
        run_trials(i,:)=cell2mat(run{i}.rpm(9,:));
        %cum_run(i,:)=cumsum(run_trials(i,:)); %heheh
        percent_run(j,i)=length(find(run_trials(i,:)))/trial_num; %hack for trials number
    end

%figure;imagesc(run_trials);
%figure; plot(cum_run')

%length(find(run_trials))/80;

end



%% run plot




