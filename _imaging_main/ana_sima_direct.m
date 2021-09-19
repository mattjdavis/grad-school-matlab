%% import signals, sima csv
% old, I generally export to .mat


path = 'X:\imaging\cyclops\md125\signals\md125_td01_roi_soma1_G.csv';
[labels,fluor,num_trials,num_frames]=import_sima_data(path);
num_rois = length(labels);

raw=reshape(fluor,num_frames,[],num_rois);

%% import mat


path='Y:\AdImg\data\md158_d05_signals.mat';
[ raw, labels, tags ] = import_sima_mat(path);
%[num_frames, num_trials, num_rois]=size(raw); % this breaks with single
%trial

%%
imgHz=10.088781;
num_frames=80;
num_rois=148;
num_trials=40;


%% TRIALS: d/df
baseline_frames=5:24;

bl=mean(raw(baseline_frames,:,:));
bl=repmat(bl,num_frames,1);
dF=((raw-bl)./bl)*100;



%% TRIALS
w=100;
cell=8;

x=raw(:,cell);

k = ones(1, w) / w
y = conv(x, k, 'full');

figure; plot(x); hold on; plot(y);
 plot(repmat(median(x),1200,1));
 plot(repmat(mean(x),1200,1),'--');
 plot(repmat(median(x),1200,1));
 plot(repmat(prctile(x,10),1200,1),'g');
 hold off;
 
 figure; hold on;
 plot(dF(:,cell));
 t=repmat(std(dF(:,cell))*2,1200,1);
 plot(t,'--');
 axis off
 
 


%% TRIALS: Get onsets
onsetThreshold = 2;
offsetThreshold = .5;
minFramesAbove=2;

%SD estimate here is not good for very active cellls
onsets=std(dF)*onsetThreshold;
offsets=std(dF)*offsetThreshold;

% permute needed to get dF into 1 trial format
[eventOnsets, eventLengths]=findOnset2(permute(dF,[1 3 2]),onsets,offsets,minFramesAbove);



%% TRIALS:find cells with certain tag (e.g. arc)
redCellsIdx=find(~cellfun(@isempty,tags));
unlabeledCellsIdx=setdiff(1:size(raw,2),redCellsIdx);

redCells=struct;
redCells.raw=raw(:,redCellsIdx);
redCells.dF=dF(:,redCellsIdx);
redCells.tags=tags(redCellsIdx);
redCells.lables=labels(1,redCellsIdx);
redCells.eventOnsets=eventOnsets(redCellsIdx);
redCells.eventLengths=eventLengths(redCellsIdx);

unlabeledCells=struct;
unlabeledCells.raw=raw(:,unlabeledCellsIdx);
unlabeledCells.dF=dF(:,unlabeledCellsIdx);
unlabeledCells.tags=tags(unlabeledCellsIdx);
unlabeledCells.lables=labels(1,unlabeledCellsIdx);
unlabeledCells.eventOnsets=eventOnsets(unlabeledCellsIdx);
unlabeledCells.eventLengths=eventLengths(unlabeledCellsIdx);

%% TRIALS: 

bins= 1:round(10*imgHz); %want seconds for bins
%binLabels= bins

figure;


h1=subplot(1,2,1);
hist(cell2mat(redCells.eventLengths),bins);
%xlim(h1,[1 30]);
num1=length(cell2mat(redCells.eventLengths));
axis square;

h2=subplot(1,2,2);
hist(cell2mat(unlabeledCells.eventLengths),bins);
%xlim(h2,[1 30]);
num2=length(cell2mat(unlabeledCells.eventLengths));
axis square;

%%TRIALS: Plot example traces
fig1=figure;

subplot(2,1,1)
plot(redCells.dF(:,6),...
'LineWidth',1);
ylim([-50 250]);
axis off





subplot(2,1,2)
plot(redCells.dF(:,1),...
'LineWidth',1);
ylim([-50 250]);
axis off

hold on 
x1=400; x2=450;
y1=120; y2=60;
plot([x1 x1 x2],[y1 y2 y2],'k-','linewidth',3); 
text(x1+(0.07*x1),y2,'10 s','horiz','center','vert','top'); 
text(x1-5,y2+(0.5*y2),'60 \DeltaF/F','horiz','right','vert','middle'); 
hold off


%toPPT(fig1)

%%
% max, includes all traces (thus does not count as significant events.
[val,ind]=max(dF);
max_ind=reshape(ind,1,[]);
figure; hist(max_ind,1:num_frames)

%% plot roi

figure; plot(dF(:,:,find(labels == 11)));
b=sort(labels);



%% plot all cell, separate plots

for i=1:length(labels)
    figure;
    plot(dF(:,:,i));
    title(sprintf('Roi: %d', labels(i)));
end



%% explore plots

% dF, everything
%figure; plot(reshape(dF,num_frames,num_trials*num_rois))

% raw, everything
%figure; plot(1:num_frames,reshape(O,num_frames,num_trials*num_rois))

% naive iamgesc
%figure; imagesc(reshape(dF,num_frames,num_trials*num_rois),[0 40]);

% sorted
[auc_sort,~]=trace_sort(dF);
figure; imagesc(auc_sort', [0 50]);

%% sort, grouped by roi
for i=1:num_rois
    [auc_sort,max_sort]=trace_sort(dF(:,:,i));
    figure; imagesc(max_sort, [0 50]);
end

%% sort, grouped by trial
for i=1:num_trials
    [auc_sort,max_sort]=trace_sort(dF(:,i,:));
    figure; imagesc(auc_sort, [0 50]);
end
%% sorter for flouro level across the time of the trial
%avg of all trials
[a,b]=trace_sort(mean(dF,3));

sort_vector=zeros(1,80);
start=20; en = 55;
for i=0:en-start
    slice_vector=start+i:start+i+3;
    slice=a(slice_vector,:);
    bb=sum(slice);
    [val,ind]=sort(bb);
    
    % some vars for my loop and if
    counter=0;
    indx= ind(end);
    assigned=0;
    
    while (assigned ==0)
        if (isempty(find(sort_vector==indx)))
            sort_vector(i+1)=indx;
            assigned=1;
        else
            display(sprintf('Index already assigned: %d', indx));
            counter=counter+1;
            indx=ind(end-counter);
        end
    end
    
    
end


%l=mean(dF,3)
ll=a(:,sort_vector(1:en-start))
figure;imagesc(a);
figure;imagesc(ll,[0 5]);