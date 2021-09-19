%% check tdTomato #s


for i=1:length(dataset)
    nTomato(i,1)=length(find(ismember(dataset{i}.tags,'tdTomato')));
    paths{i,1}=dataset{i}.fn;
end

[(1:length(dataset))' nTomato]
%% look for certain cells and check tags
% used to look for tdTomato that matches across
D=19; %select the dataset number
b=[40]; % put the known label names from my ROI sheet


path=dataset{D}.path;
fn=dataset{D}.fn;
    
c=ismember(dataset{D}.labels, b);
ind=find(c);

T=dataset{D}.tags;
T(ind)
ind

%% Add the paticular index to the TAGS cell array

INDEX=19;
dataset{D}.tags{INDEX}='tdTomato'; %% load data set


%% check labels between two dataset from simlar signals files
% want the labels subtraction to be 0

for i=1:20
    a=find(dataset{i}.labels- d03{i}.labels);
    b=find(dataset{i}.path- d03{i}.path);
    display(a);
    display(b);
end

%% transer tags from one dataset to another

for i=1:20
    d03{i}.tags=dataset{i}.tags;
end