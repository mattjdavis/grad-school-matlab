

animal_name='md0' %CHANGE

eb_path = strcat('X:\\eyeblink\\+processed\\',animal_name,'\\');
eyeblink=struct;

% get all .mat files in eb_path
files = dir(fullfile(eb_path, '*.mat'));
file_struct=struct2cell(files);
file_names=file_struct(1,:);


for i=1:length(file_names)
    
    file = file_names{i};
    file_split=strsplit(file,'_');
    day_name=file_split{2};
    
    eyeblink.(day_name)= load(strcat(eb_path,file));
    
end



%% 

days=fields(eyeblink);
day_num=length(days);
max_amp=[];

var='maxAmp';
%var='latency2max';
%var='latency2crit';

for i=1:day_num
    day=days{i};
    
    max_amp(i,:)=eyeblink.(day).eb_data.(var).raw_data;
    
    
    
end

max_amp=max_amp(:,11:70); % remove blank trials
%%

max_amp_long=reshape(max_amp',1,numel(max_amp));
x=1:length(max_amp_long);

figure; plot(x,max_amp_long,'o');

% remove zeros
% ma=max_amp_long;
% ma(ma==0)=NaN;
% figure; plot(x,ma,'o');

%% moving avg

N=11

max_amp_ma=ones(1,l)/l;

max_amp_avg=filter(max_amp_ma,1,max_amp_long);

hold on; plot(x,max_amp_avg);






