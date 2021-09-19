%% multi sima import

%% Load directory containing signals files

%directory='Y:\GsImaging\data\md138_R3\';
%directory='Y:\GqImg\data\md148_R1\'
%directory='Y:\GqImg\data\md148_R2\'
%directory='Y:\GqImg\data\md148_R3\'
%directory='Y:\GqImg\data\md147_R1\'
%directory='Y:\GqImg\data\md147_R2\'
%directory='Y:\GqImg\data\md147_R3\'


directory='Y:\AdImg\data\';

%%
dir1='Y:\GqImg\data\md147_R1\' 
dir3='Y:\GqImg\data\md147_R3\'


directories={dir1,dir2,dir3};

%%

dir1='Y:\GqImg\data\md147_D2_R1\'
dir2='Y:\GqImg\data\md147_D2_R5\'
dir3='Y:\GqImg\data\md147_D2_R6\'

directories={dir1,dir2,dir3};

%% Multiple Directories with Signals Files

dataset=multiSimaImport(directories,8,[3 .5 3],2);
%% Single directory with signals files

dataset=multiSimaImport(directory,8,[3 .5 3],2);

%% Single directory with signals files - Discrete Trials (EB)


% last var should be 2 (df/f method)
directory='Y:\AdImg\data\';
dataset=multiSimaImport(directory,5,[3 .5 3],3);
%% get all spikes from loaded set

% C = [ dataset{:} ]; % all datasets 
C = [ dataset{1:3} ]; 


% rois should match across datasets
numRois=dataset{1}.num_rois; % this could break code if not the same across datasets
numDatasets=size(dataset,2);

% select vars from each loaded struct 
allSpikes = [ C(:).N ];
fns = { C(:).fn }; 
nhatAll=[ C(:).Nhat ];

% reshape for plot
allSpikes=reshape(allSpikes,,numRois,numDatasets);

% sort by tag, may generalize for other vars

toSort=1;
if(toSort)
    allIdx=1:numRois;
    
    % careful, tags must me same across dataset
    T=lower(dataset{1}.tags); 
    
    
    %idx1=[103,104,105,106,108,127];
    idx1=find(ismember(T,'tdtomato'));
    idx2=setdiff(allIdx,idx1);
    
    tomatoPosSpikes=allSpikes(:,idx1,:);
    tomatoNegSpikes=allSpikes(:,idx2,:);
end



% Spikes by Day
spikesPerDay=permute(sum(allSpikes),[2 3 1]);
figure;imagesc(spikesPerDay);
colormap hot;

figure;
SS=sum(sum(allSpikes,2));
SS=reshape(SS,1,[]);
%SS=SS(1,[7,8,2,1,4,3,6,5]);

bar(SS);
set(gca,'XTickLabels',fns,'XTickLabelRotation',45);


%% positive tomato spikes
spikesPerDay=permute(sum(tomatoPosSpikes),[2 3 1]);
figure;imagesc(spikesPerDay);
colormap hot;

figure;
SS=sum(sum(tomatoPosSpikes,2));
SS=reshape(SS,1,[]);
bar(SS);
set(gca,'XTickLabels',fns,'XTickLabelRotation',45);
%% negative tomato spikes 
spikesPerDay=permute(sum(tomatoNegSpikes),[2 3 1]);
figure;imagesc(spikesPerDay);
colormap hot;

figure;
SS=sum(sum(tomatoNegSpikes,2));
SS=reshape(SS,1,[]);
bar(SS);
set(gca,'XTickLabels',fns,'XTickLabelRotation',45);


%% event lengths

C = [ dataset{1:3} ]; 
allEventLengths = [ C(:).eventLengths ];
allEventLengths= reshape(allEventLengths,numRois,numDatasets);
[~,nEvents] = cellfun(@size, allEventLengths);

% number of Ca2+ events
figure;imagesc(nEvents);
figure;bar(sum(nEvents)) 
set(gca,'XTickLabels',fns,'XTickLabelRotation',45);
title('Number of Ca2+ events')


% mean length of Ca2+ events
for i=1:numDatasets
    a=allEventLengths(:,i);
    b=cell2mat(transpose(a));
    
    meanEL(i)=mean(b);
    semEL = std(b)/sqrt(length(b)); 
    allEL{i}=b;
    
    clear a
end

%
figure;
bar(meanEL);
set(gca,'XTickLabels',fns,'XTickLabelRotation',45);
title('Mean length of Ca2+ events')
ylabel('Duration of event (# of frames)')

%% onsets
on = [ C(:).eventOnsets ];
on=reshape(on,numRois,numDatasets);

for i=1:size(on,2)
    for j=1:size(on,1)
        
        idx=on{j,i};
        indices=[idx-10;idx+30] % get 10 before and 20 after onset
        
        traces=[];
        for k=1:size(indices,2)
            trace=dataset{i}.dF(:,j);
            
            
            % prevent grabbing indices from outside the trace vector
            if (indices(1,k) > 0 && indices(2,k) < length(trace))
                traces=[ traces trace(indices(1,k):indices(2,k)-1)];
            end
            
            transients{i,j}=traces;
        end
        
        
    end
    
end

allTransients=[transients{:}];
figure;plot(allTransients);


%% Save the dataset: it will have modified fn information.

dataset{1}.sessionNumber=4;
dataset{1}.sessionLabel='D2-R1-0.5 CNO'
%%
for i=1:8
    strrep(dataset{i}.sessionLabel,'R3')
end

%%

params=[2 .5 1;
        3 .5 1;
        4 .5 1;
        5 .5 1;
        2 .5 2;
        3 .5 2;
        4 .5 2;
        5 .5 2;
        2 .5 3;
        3 .5 3;
        4 .5 3;
        5 .5 3]

for i=1:length(params)
    dataset=multiSimaImport(directory,8,params(i,:));

    C = [ dataset{:} ]; 
    allEventLengths = [ C(:).eventLengths ];
    allEventLengths= reshape(allEventLengths,numRois,numDatasets);
    [~,nEvents] = cellfun(@size, allEventLengths);

    events(i,:) = sum(nEvents);
end

figure;bar(events);


%% get active cells from combined regions

activeCutoff=[0 5 10];

fig1=figure;
title('Number of Calicum Events per ROI')

for i=1:3
    [r,b]=find(ev>=activeCutoff(i))
    active=ev(r,:);

    
    %scatter(log10(active(:,1)),log10(active(:,2)))
    subplot(1,3,i);
    
    
    x=active(:,1); x= x' + 0.3 * rand(1, length(x));
    y=active(:,2); y= y' + 0.3 * rand(1, length(y));
    scatter(x,y);
    ylabel('Vehicle');
    xlabel('CNO');
    corr(active(:,1),active(:,2));

%     %
%     figure; 
%     subplot(2,1,1);
%     hist(active(:,1));
%     subplot(2,1,2);
%     hist(active(:,2));
end




%% multi multi load
C = [ dataset{:} ]; 
i = [ C(:).info];

cnoDatasets=find(strcmp({i.treatment},'cno'));




