% Purpose
%   To directly load the CR data from *.mat files, and generate percent CR
%
% Notes
%   -adjusts for keeper trials
%   -will only load cr, now
%   -ignores acc trial, bug will not let me analyze all blank trials.
%   -everything is put into a struct array so can be used later
%   -very hacky numbers used here, e.g. 11:70, and 60
%
% Author: Matt James Davis, Univerisity of Texas at Austin, 08/27/2015

% initial variables
animals={'md124'}
eb_path='X:\eyeblink\+processed\'
% days={'td01','td02','td03', 'td04', 'td05', 'td06','td07',...,
%     'td08','td09', 'td10', 'td11', 'td12', 'td13'};

% preallocate variables
all_cr=[];
eb_dataset=struct;

for j=1:length(animals);
    animal=animals{j};
    file_path = strcat(eb_path,animal,'\');
    mat_files = dir(fullfile(file_path, '*.mat'));
    

    for i=1:length(mat_files)
        
        current_file=strcat(file_path,mat_files(i).name);
        x=strsplit(mat_files(i).name,'_');day_name=x{1,2};
        eb_dataset(j).(day_name)=load(current_file); 
        
        % prevent acc trials from loading, bug 
        if strfind(day_name,'td')
            cr_raw= eb_dataset(j).(day_name).eb_data.CR.raw_data;
            cr_vector=cr_raw(:,1);
            cr_vector=cr_vector(11:70)';
            keeper_vector=cr_raw(:,3);
            num_bad_blink=length(find(keeper_vector(11:70)));
            num_trials=60-num_bad_blink;

            cr_percent(i,j) = length(find(cr_vector))/num_trials * 100;
        end
    
    end
end
%% Plot CR
% Inputs: animals, cr_percent


ids=animals;
fig1=figure('Color',[1 1 1]);

% axes
plot(cr_percent, 'LineWidth', 2,...
    'MarkerSize',8,'Marker','square')
ylabel('Conditioned Response Rate (%)')
xlabel('Days');
ylim([0 100]);
set(gca, 'XTick',0:13, 'XTickLabel',0:13,...
    'Box','off');

% legend
 legend1 = legend(gca,ids);
 set(legend1,'EdgeColor',[1 1 1],'Location','NorthWest')





