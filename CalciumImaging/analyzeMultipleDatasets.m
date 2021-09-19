%% IMPORT DATASETS

directory='Y:\AdImg\data\';
datasets=multiSimaImport(directory,3,[3 .5 3],3,[25 65]);

%% SELECTION ENGINE
% Will obtain the desired datasets from a cell array of datasets

% Choose variables
% These vars depend on dataset.info.treatment or dataset.info.treatment
day='d05'
genotype='tg'

%engine
C = [ datasets{:} ];CC=[C(:).info];indD=strcmp({CC.day},day);indG=strcmp({CC.treatment},genotype);
indDS{1}=intersect(find(indD),find(indG)); 

%% RUN TWICE
day='d05'
genotype='con'

clear C, CC, indD, indG;
%engine
C = [ datasets{:} ];CC=[C(:).info];indD=strcmp({CC.day},day);indG=strcmp({CC.treatment},genotype);
indDS{2}=intersect(find(indD),find(indG)); 

%% SORT DATASETS BY TRIAL TYPE
% The idea is to 

whichDS=1; %switch which run above will be analyzed

% trial types
%trialTypes={puff,tone};
%trialTypes={llight,hlight};
trialTypes={};all=1:40;trialTypes={all};


s_datasets={}; D=struct; rD=struct;
    
for j=1:length(indDS{whichDS})
    
    D=datasets{indDS{whichDS}(j)}; % select 1 dataset
    rD=D; %duplicate for rD (reducedDatset)
    
    %HACK- needed to fix stim for md158
    %if(j==2); trialTypes={llight158,hlight158}; else trialTypes={llight,hlight}; end
    
    for i=1:length(trialTypes);
    
        rD.raw=D.raw(:,trialTypes{i},:);
        rD.dF=D.dF(:,trialTypes{i},:);
        rD.baseline=D.baseline(:,trialTypes{i});
        rD.eventOnsets=D.eventOnsets(trialTypes{i},:);
        rD.eventLengths=D.eventLengths(trialTypes{i},:);
       
        s_datasets{i,j}=rD;
    end
end
 

%% Active Events, Number of Events, Length of events

% blank variables
activeAll=[]; active_dF=[]; D2=struct; onsetsAligned={};numRois=[];

nPreFrames=1; % number of frames to grab before 1st onsets, onyl needed for aligning d/f/

% For loop will....
% s_datasets is a j x k cell, j= stimuli (e.g. puff, tone), k =animals of similar genotype/treatment
for k=1:size(s_datasets,1) 
    for j =1:size(s_datasets,2)
        
        D2=s_datasets{k,j};
        
        %blank out variables
        active_dF=[]; r=[];c=[];activeOnsets={}; onAl={}; activeLengths={};
        
        % Active Events, look in onsets variable for any events, retrieve
        % that from dF/F. Put all the traces in a var (activeAll) as the
        % loop runs.
        [r,c]=find(~cellfun(@isempty,D2.eventOnsets));
        for i=1:length(r) ;
            active_dF(:,i)=D2.dF(:,r(i),c(i)); 
            activeOnsets{i}=D2.eventOnsets{r(i),c(i)};
            activeLengths{i}=D2.eventLengths{r(i),c(i)};
        end
        activeAll=[activeAll active_dF];
        
        
        % Number of events
        numEO(k,j)=length(r);
        perEO(k,j)=((length(r)/(D2.num_rois*size(D2.dF,2)))*100); %denominator should be nRois * nTrials
        
        % Grab all the first active onsets
        firstActiveOnsets{k,j}=cellfun(@(x) x(1), activeOnsets(1,:));
        
        % Grab all 1st lengths
        firstLengths{k,j}=cellfun(@(x) x(1), activeLengths(1,:));
        
        % using 1st onsets, grab that portion of the df/f
        % minus 5 from onset (threshold crossing)
        fao=firstActiveOnsets{k,j};
        for i=1:length(fao);trace=active_dF(:,i); onAl{i}=trace(fao(i)-nPreFrames:end);end;
        onsetsAligned{k,j}=onAl;
        
        %
        numRois(k,j)=D2.num_rois;
        
    end
    
    % Assign active events to different vars (e.g. looking at control vs
    % AD animals.
    if (whichDS==1);AA{k}=activeAll; else BB{k}=activeAll;end;
    activeAll=[];
end

tRois=sum(numRois,2);

% 1st active onsets, used for histogram
pO=cell2mat(firstActiveOnsets(1,:));
tO=cell2mat(firstActiveOnsets(2,:));
figure; hist(pO);
figure; hist(tO);

% 1st active onsets, used for histogram
len1=cell2mat(firstLengths(1,:));
len2=cell2mat(firstLengths(2,:));
figure; hist(len1);
figure; hist(len2);


%ratio of high transients vs low transients
hlen1=length(find(len1>20));
llen1=length(find(len1<20));
hlen2=length(find(len2>20));
llen2=length(find(len2<20));

 %%
 figure;hold on; plot(mean(BB{1},2));plot(mean(BB{2},2))
   
%%
figure; hold on;
plot(BB{1},'Color',[.5 .5 .5]); plot(mean(BB{1},2),'r','LineWidth',2);
    
%%

allStim1=[AA{1} AA{2}];
allStim2=[BB{1} BB{2}];

aaa=mean(allStim1,2);
bbb=mean(allStim2,2);

figure;hold on;;
plot(bbb);plot(aaa);


% auc
auc1=trapz(allStim1(25:end,:));
auc2=trapz(allStim2(25:end,:));
[auc1, indA]=sort(auc1);
[auc2, indB]=sort(auc2);

%% BAR AUC

m1=mean(auc1)
s1=std(auc1)
m2=mean(auc2)
s2=std(auc2)

figure
%bar([m1 m2])
errorbar(1:2, [m1 m2], [s1 s2]);


%% PERCENT ACTIVE (Event onsets)


mPerEO=mean(perEO,2)
semPerEO=std(perEO,[],2)/sqrt(size(perEO,2))

%% percent active



figure;
bar(mPerEO, 'FaceColor', [.5 .5 .5]);hold on

er = errorbar(1:2, mPerEO, semPerEO);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';                         
hold off


%% Plot - Onsets Aligned

xx=zeros(1500,80);

pp=[onsetsAligned{1,:}];
tt=[onsetsAligned{2,:}];

for i=1:length(pp)
    e=length(pp{i})
    xx(i,1:e)=pp{i}';
end

ppp=xx(1:i,:);

xxx=zeros(1500,80);
for i=1:length(tt)
    e=length(tt{i})
    xxx(i,1:e)=tt{i}';
end

ttt=xxx(1:i,:);

figure;hold on; plot(mean(ppp));plot(mean(ttt))


%% ratio

tg=320/435;

control= 386/780;

figure;bar([tg control]);
ylim([0 1])