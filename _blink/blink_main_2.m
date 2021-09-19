% v2
% -want to make the cr data into stucts.
% THIS CODE WAS PUT INTO  'prep_eb_import' function

%clear all;
%path= uigetdir;
path = 'X:\\eyeblink\\+processed\\md081';
%path = 'C:\Users\Matt\Desktop\t\zero';
files = dir(fullfile(path, '*.txt'));


exp1='CR';
exp2='latency2max';
exp3='latency2crit';
exp4='maxAmp';

expressions={'CR','latency2max','latency2crit','maxAmp'};
unique_files=size(files,1)/4;
%file_index= reshape(1:size(files,1),unique_files,[]);

file_struct=struct2cell(files);
file_names=file_struct(1,:);
eb_data= cell(1,unique_files,4);

for i=1:length(expressions)
    bbb= regexp(file_names,expressions{i});
    [~,c]=find(~cellfun(@isempty,bbb));
    eb_data(1,:,i)=file_names(c);
    
    for j=1:size(eb_data,2)
        file=sprintf('%s\\%s',path,eb_data{1,j,i});
        eb_data{2,j,i} = import_eb_data(file,expressions{i});
    end
    
       
end
%%
% throw into eb struct, better organized
days={'acc01' 'acc02' 'acc03' 'td01' 'td02' 'td03' 'td04' 'td05' 'td06' 'td07' 'td08' 'td09' 'td10' 'td11' 'td12' 'td13'};
eb=cell2struct(cell(16,3),days);




% Then, save the eb_data file with the 'animal' as the file name



%% load processed data

path='X:/eyeblink/+processed/sst_eb_1/';
%files = {'md047','md048','md049','md050','md059'};
%files = {'md053','md054','md055','md056','m057','m058'};
files ={'md076','md079', 'md081'};
num_days=13;
blink_vec = 11:70;

% need to include vector to look for blink trials, on the account of having
% blank at the start and finish


cr_data=zeros(length(files),num_days);
for i=1:length(files)
    file=sprintf('%s%s_eb.mat',path,files{i});
    %eb_data=load(file)
    %eb_data=eb_data.eb_data(:,3:15,:);
    [cr_data(i,:), lat_max(1,:,i),lat_crit(1,:,i),max_amp(1,:,i)]=blink_extract_cr(load(file),blink_vec);
end



% CR_141020D, seems to have one less trial, manually fixed..but why!


%% assiging to struct

%days={'td01' 'td02' 'td03' 'td04' 'td05' 'td06' 'td07' 'td08' 'td09' 'td10' 'td11' 'td12' 'td13' 'td14'};
%days={'td01' 'td02' 'td03' 'td04' 'td05' 'td06' 'td07' 'td08' 'td09' 'td10'};
days={'td11' 'td12' 'td13'};

for i=1:length(days)
    day=days{i};
    data.md081.(day).Cr=eb_data{2,i+10}(:,1);
    data.md081.(day).BadBlinkTrials=eb_data{2,i+10}(:,3);
end
    


