

%% ************************************************************************
%% LOAD FILES
%% ************************************************************************

file='X:\\imaging\\wheel_run_5\\signals\\';
%file='X:\imaging\eb_arc_5\signals\md192_12202016_VT3-6_r1_001_signals.mat';
rpm_path='X:\\imaging\\wheel_run_5\\rpm\\';
datasets=multiSimaImport(file,rpm_path,8,[3 .5 3],2);

%% ************************************************************************
%% START HERE
%% ************************************************************************

% set the dataset variable
%dataset=d02;
 
% put into struct array
%C = [ dataset{4:6} ]; % put a subset into struct array 
C = [ datasets{:} ];
I = [C.INFO];
EV =[C.EVENTS];
B = [C.BEHAVIOR];



% grab 
alldF=[C.dF]; 
allTags=vertcat(C.tags); 

% extract labels
[exLabels,collLabels]= extractLabels(C);

% Plot, quick dF
figure;imagesc(alldF',[.1 2]); colormap hot;
xlabel('Time','FontName','Arial','FontWeight','bold','FontSize',18 );
ylabel('ROI','FontName','Arial','FontWeight','bold','FontSize',18 );




%% circle
dn=20

for i=1:100
on=EV(dn).on
cell=i;
cpos=B(dn).LAP.cpos;


plot_mvl_circle(on,cpos,cell);
display(B(dn).LAP.nlaps)
pause;
end
%% ************************************************************************
%% AUC
%% ************************************************************************

% AUC stats


animal=categorical({I.animal}');
day=categorical({I.day}');
var1=mean_aucm';

ds=dataset(animal,day,var1);

stats = grpstats(ds,'day',{'mean','max','std'},'DataVars','var1');
stats = sortrows(stats,'day','ascend');

% get names
animal_names=categories(removecats(ds.animal));
day_names=categories(removecats(ds.day));



%% AUC PLOT

% set fig
fig2=figure; 
ax2=gca;
hold on;
box off;
set(gca,'LooseInset',get(gca,'TightInset'));
axis square;
% y
ax2.YLim=[.1 .75];


% individual plots
% plot individual
for i=1:length(animal_names)
    
    ds1=ds(ds.animal==animal_names{i},:);
    plot(ax2,ds1.day,ds1.var1,'LineWidth',1.5,'Color',[.5 .5 .5]);
end


%plot(ax2,stats.day,stats.mean_tdist,'b','LineWidth',3,...
%    'MarkerSize',10,'Marker','square') ;
sem=stats.std_var1/sqrt(length(stats.std_var1));
er=plot(ax2,stats.day,stats.mean_var1,...,
    'MarkerSize',10,'Marker','square');
er.LineWidth=3;
%er.CapSize=10; %2016

% axis
set(ax2,'FontSize',14,'FontWeight','bold');
xlabel(ax2,'Days','FontName','Arial','FontWeight','bold','FontSize',16 );
ylabel(ax2,'Activity rate (AUC/s)','FontName','Arial','FontWeight','bold','FontSize',16 );
set(ax2,'XTick',1:1:length(day_names),'XTickLabel',1:1:length(day_names));
title('Mean activity rate across days');


%% cdf by day

figure; hold on;
c = colormap(cool(length(day_names)));
for i =1:length(day_names)
    %gather aucm by day
    d= ds.day==day_names{i};
    haucm=[aucm{1,d}];
    [h(i),s(i)]=cdfplot(haucm);
    set(h(i),'LineWidth',2,'Color',c(i,:)');
    
   
end

legend(strread(num2str(1:7),'%s'),'Box','off','Location','southeast') %HACK


% axis
set(gca,'XLim',[0 1.1]);
set(gca,'FontSize',16,'FontWeight','bold');
xlabel('Activity rate (AUC/s)','FontName','Arial','FontWeight','bold','FontSize',16 );
ylabel('Fraction of cells','FontName','Arial','FontWeight','bold','FontSize',16 );
title(sprintf('Activity across days'));
axis square; 
grid('off');

%% ************************************************************************
%% EVENT ONSETS
%% ************************************************************************

bin_limits=[ 0, 25];
y_lim= [ 0 350]; % [0 700]

EV=[C.EVENTS];
% event onsets
nEvents=[EV.num];
% events onsets w/ 1s transient cutoff
nEventsR=[EV.numr];
nRois=sum([C.num_rois]);

% Modify the values in the onsets
%nEvents(find(nEvents>30))=30; % erase high values
%nEvents(find(nEvents==0))=[]; % may choose to erase zeros 
nEvents2=nEvents; %reassign for plotting purposes;

% ERASE HIGH VALUES
%nEvents2(find(nEvents2>60))=25; 
%nREO2(find(nREO2>60))=25;


% SUBPLOT - nEvents and nEventsR
figure;
% top
ax1=subplot(211);
histogram(nEvents,'BinLimits', bin_limits); 
ax1.YLim=y_lim;
ylabel('None Excluded');

text1=sprintf('%s%d\n%s%d','ROIs: ',nRois,'Events: ',sum(nEvents));
text(.95,.85, text1, 'Units','normalized', 'HorizontalAlignment','right');

% bottom
ax2=subplot(212);
histogram(nEventsR,'BinLimits', bin_limits);
xlabel('Number of Events','FontName','Arial','FontWeight','bold','FontSize',18 );
ax2.YLim=y_lim;
ylabel('< 1s Excluded');

text1=sprintf('%s%d\n%s%d','ROIs: ',nRois,'Events: ',sum(nEventsR));
text(.95,.85, text1, 'Units','normalized', 'HorizontalAlignment','right');

%
% PLOT - nEventR
figure;
box off;
histogram(nEventsR,'BinLimits', bin_limits);
xlabel('Number of Events per Cell','FontName','Arial','FontWeight','bold','FontSize',18 );
YLim=y_lim;
ylabel('Count','FontName','Arial','FontWeight','bold','FontSize',18 );
set(gca,'FontSize',16,'FontWeight','bold');
text1=sprintf('%s%d\n%s%d','ROIs: ',nRois,'Events: ',sum(nEventsR));
text(.95,.85, text1, 'Units','normalized', 'HorizontalAlignment','right','FontSize',14,'FontWeight','bold');


% PLOT - log nEvents and nEventsR
% figure
% subplot(211);
% histogram(log(nEvents));
% 
% subplot(212);
% histogram(log(nREO));

%

%% ************************************************************************
% RUN % AUC 
%% ************************************************************************

mins=(1/10.088*6000)/60;
secs=(1/10.088*6000);
B=[C.BEHAVIOR];
R=[B.RUN];

for i=1:length(C)
   
    a=EV(i).bin; %events binary
    b=C(i).dF;
    
    % run/no run ind
    rind=find(R(i).runMask);
    nrind=find(~R(i).runMask);
    
    for j=1:size(a,2)
        % onset, intersect with running/norun times
        ee=EV(i).on{j};
        x(j)=length(intersect(rind,ee));
        y(j)=length(intersect(nrind,ee));
        
        % auc per min
        xx=a(:,j); %bin
        yy=b(:,j); %df
        trans=yy(find(xx),:); %just transiets
        %mint=(1/10.088*length(trans))/60 %minute time % for run
        auc(j)=trapz(trans)/secs; %auc per minute (transients only)
        
        
    end
    
runev{i}=x;
nrunev{i}=y;
aucm{i}=auc;
%a(rind,:);
%a(nrind,:);
mean_aucm(i)=mean(auc);

    
    
end
%%

figure;
%subplot(131);
set(gca,'LooseInset',get(gca,'TightInset'));

% plot
arun=[runev{:}];
anrun=[nrunev{:}];
[h1,stats1]=cdfplot([runev{:}]);
hold on;
[h2,stats2]=cdfplot([nrunev{:}]);
grid('off');

% lines
set(h1,'LineWidth',3);
set(h2,'LineWidth',3);

% axis
axis square; 
set(gca,'FontSize',16,'FontWeight','bold');
xlabel('Number of events per cell','FontName','Arial','FontWeight','bold','FontSize',18 );
ylabel('Fraction of cells','FontName','Arial','FontWeight','bold','FontSize',18 );
set(gca,'XLim',[0 25]);
title(sprintf('All cells, pooled\ndays & animals'));

%legend
mLegend{1}='Run';
mLegend{2}='Rest';
legend(mLegend,'Box','off','Location','southeast');



%%    
% bar
%legend
m=[stats1.mean stats2.mean]

sem1=stats1.std/sqrt(length(arun));
sem2=stats2.std/sqrt(length(anrun));
v=[sem1 sem2]+m

stats1.std
stats2.std



figure;
bar(m);
for d = 1:length(m)
   hold on
   plot([d d],[m(d) v(d)],'-k');
   plot(d,m(d),'ok');
end


%xlabel('day')
%ylabel('fraction of positive debiased mean vector lengths')
%xlim([0 numdays+1])
%ylim([0 1])



%% box
figure;
boxplot([arun;anrun], 'plotstyle','compact');

%% ************************************************************************
%% SUPER ACTIVE CELLS
%% ************************************************************************

% vars
nActive_thresh=25;

% get super active and labels
[~,superActive]=find(nEvents>nActive_thresh);
M=alldF(:,superActive); 
L= collLabels(:,superActive);
nE=nEvents(:,superActive);

% plot waterfall
%plotWaterfall( M, L); % with labels
plotWaterfall( M);

% plot heatmap
figure; imagesc(M', [.5 2]); colormap hot;



%% Find specific ROI df/f
s='md186 r1 14';
ind=strmatch(s,collLabels,'exact');
sing_dF=alldF(:,ind);


%% SORT TOMATO, EVENT ONSETS

%legend1= {'Arc-','Arc+'};
legend1= {'PV-','PV+'};

% concatenate tags and dF
allTags=vertcat(C.tags);

% find indexes of tdTomato
indAll=1:size(allTags,1);
tomato_ind=find(ismember(allTags,'tdTomato')); %CHECK THAT THIS NUMBER MATCHES MY NOTES FROM ROI DRAWING
neg_ind=setdiff(indAll,tomato_ind);

% using indexes grab tdTomato postive and negative ROIs
tomatoPosDf=alldF(:,tomato_ind);
tom_nEvents=nEventsR(:,tomato_ind);
tomatoNegDf=alldF(:,neg_ind);
neg_nEvents=nEventsR(:,neg_ind);

% zeros 
perTom0=length(find(tom_nEvents < 1 ))/ length(tom_nEvents);
perNTom0=length(find(neg_nEvents < 1 ))/ length(neg_nEvents);
% active
perTomH=length(find(tom_nEvents >= 10 ))/ length(tom_nEvents);
perNTomH=length(find(neg_nEvents >= 10 ))/ length(neg_nEvents);

% less active
perTomL=length(tom_nEvents(tom_nEvents < 10 & tom_nEvents>=1))/ length(tom_nEvents);
perNTomL=length(neg_nEvents(neg_nEvents < 10 & neg_nEvents>=1))/ length(neg_nEvents);


%% PLOT: 3 plots- (1) cdf, (2) histogram, (3) mean bar
% figure
figure;
set(gca,'LooseInset',get(gca,'TightInset'));

% SUBPLOT 1 - Empirical CDF
subplot(131);

% plot
h1=cdfplot(neg_nEvents);
hold on;
h2=cdfplot(tom_nEvents);
grid('off');

% lines
set(h1,'LineWidth',3);
set(h2,'LineWidth',3);

% axis
axis square; 
set(gca,'FontSize',16,'FontWeight','bold');
xlabel('# Events per Cell','FontName','Arial','FontWeight','bold','FontSize',24 );
ylabel('Fraction of Cells','FontName','Arial','FontWeight','bold','FontSize',24 );
set(gca,'XLim',[0 45]);

%legend
legend(legend1,'Box','off','Location','southeast');


% SUBPLOT 2 - Histogram

ax3=subplot(132);
histogram(neg_nEvents,10,'BinLimits', [0,45],'Normalization', 'probability'); hold on;
histogram(tom_nEvents,10,'BinLimits', [0,45],'Normalization', 'probability');
xlabel('# of Events per Cell','FontName','Arial','FontWeight','bold','FontSize',24 );
ylabel('Fraction of Cells','FontName','Arial','FontWeight','bold','FontSize',24 );
legend(legend1,'Box','off');
set(gca,'FontSize',16,'FontWeight','bold');
ax3.YLim=[0 .50];

hold off;
box off;



% SUBPLOT 3 - bar mean - all
sem1=std(neg_nEvents)/sqrt(length(neg_nEvents));
sem2=std(tom_nEvents)/sqrt(length(tom_nEvents));


ax4=subplot(133);
hold on;
bar([mean(neg_nEvents) mean(tom_nEvents)],...
    'FaceColor',[0 .44 .74],...
    'LineWidth',2);
errorbar([mean(neg_nEvents) mean(tom_nEvents)], [sem1 sem2],'.',...
        'Color',[0 0 0],...
        'LineWidth',4,'MarkerSize',20);
set(gca,'XTick',1:2,'XTickLabel',legend1, 'FontSize',16,'FontWeight','bold');
ylabel('Mean # of Events','FontName','Arial','FontWeight','bold','FontSize',24 );
ax4.YLim=[0 30];
hold off;
%%


% % ---PLOT---
% figure;
% 
% % tomato positive
% ax1=subplot(2,1,1);histogram(tom_nEvents,'BinLimits', [0,25], 'Normalization', 'probability');
% title('Arc +');
% text1=sprintf('%s%d\n%s%d','ROIs: ',length(tom_nEvents),'Events: ',sum(tom_nEvents));
% text(.95,.85, text1, 'Units','normalized', 'HorizontalAlignment','right');
% ax1.YLim=[0 .35];
% 
% % tomato negative
% ax2=subplot(2,1,2);histogram(neg_nEvents,'BinLimits', [0,25],'Normalization', 'probability');
% title('Arc - ');
% text1=sprintf('%s%d\n%s%d','ROIs: ',length(neg_nEvents),'Events: ',sum(neg_nEvents));
% text(.95,.85, text1, 'Units','normalized', 'HorizontalAlignment','right');
% ax2.YLim=[0 .35];
% xlabel('Number of Events','FontName','Arial','FontWeight','bold','FontSize',18 );


%%

x = 0:1:60;
f = evcdf(x, neg_nEvents);
plot(x,f,'m');

%%
figure;

[h1,s1]=cdfplot(neg_nEvents);
[h2,s2]=cdfplot(tom_nEvents);
hold on;
%plot(h2);
%plot(h1);



%% Look at tdTomato postive events by region

tPosLabels=exLabels(tomato_ind,:); 

regionNum=tPosLabels(:,2);
[regionNum2, gL]=grp2idx(regionNum);
XX=[regionNum2 tom_nEvents'];

A = arrayfun(@(x) XX(XX(:,1) == x, :), unique(XX(:,1)), 'uniformoutput', false); % make cell array of unique values
AA=cellfun(@(x) x(:,2),A,'UniformOutput',false); % get only the nEvents, without indexes

A=plotStruct(); A.xAl='Region', A.yAL='# Events per ROI', A.xT=1:6, A.xTL=gL;
barWithData(AA,A); 

%tneg 

tNegLabels=exLabels(neg_ind,:); 

regionNum=tNegLabels(:,2);
[regionNum2, gL]=grp2idx(regionNum);
XX=[regionNum2 neg_nEvents'];

A = arrayfun(@(x) XX(XX(:,1) == x, :), unique(XX(:,1)), 'uniformoutput', false); % make cell array of unique values
AA=cellfun(@(x) x(:,2),A,'UniformOutput',false); % get only the nEvents, without indexes

A=plotStruct(); A.xAl='Region'; A.yAL='# Events per ROI'; A.xT=1:6; A.xTL=gL;
barWithData(AA,A); 



%% Look at tdTomato postive events by animal

animalNum=tPosLabels(:,1);
[animalNum2, gL]=grp2idx(animalNum);
XX=[animalNum2 tom_nEvents'];

A = arrayfun(@(x) XX(XX(:,1) == x, :), unique(XX(:,1)), 'uniformoutput', false); % make cell array of unique values
AA=cellfun(@(x) x(:,2),A,'UniformOutput',false); % get only the nEvents, without indexes

A=plotStruct(); A.xAl='Animal'; A.yAL='# Events per ROI'; A.xT=1:4; A.xTL=gL;
barWithData(AA,A); 


%t neg
animalNum=tNegLabels(:,1);
[animalNum2, gL]=grp2idx(animalNum);
XX=[animalNum2 neg_nEvents'];

A = arrayfun(@(x) XX(XX(:,1) == x, :), unique(XX(:,1)), 'uniformoutput', false); % make cell array of unique values
AA=cellfun(@(x) x(:,2),A,'UniformOutput',false); % get only the nEvents, without indexes

A=plotStruct(); A.xAl='Animal'; A.yAL='# Events per ROI'; A.xT=1:4; A.xTL=gL;
barWithData(AA,A); 




%% PLOT dF - TOMATO
%figure;imagesc(tomatoPosDf',[0 3]); colormap hot;

figure;imagesc(corr(tomatoPosDf(1:6360,:)),[0 .5]); colorbar; colormap hot;
figure;imagesc(tomatoPosDf',[.1 1]); colormap hot;

figure;imagesc(corr(tomatoNegDf(1:6360,:)),[0 .5]); colorbar; colormap hot;
figure;imagesc(tomatoNegDf',[.1 1]); colormap hot;

%% PLOT: dF tdTomato w/ label
%%

L= collLabels(:,tomato_ind);
%plotWaterfall(tomatoPosDf, L); % with labels
plotWaterfall(tomatoPosDf);

L= collLabels(:,neg_ind);
%plotWaterfall(tomatoNegDf, L); % with labels
plotWaterfall(tomatoNegDf);

%% ---PLOT: tdTomato with differ colors representing coactive
v_shift= max(max(tomatoPosDf))/5;

[gI]=grp2idx(cell2mat([ tPosLabels(:,1) tPosLabels(:,2)])); % Get unique group identifier

fig1=figure; hold on;

cmap=colormap(fig1,lines(length(unique(gI)))); 
xvec=1:size(tomatoPosDf,1);

for ii=1:size(tomatoPosDf,2)
    yvec=tomatoPosDf(:,ii)-(ii*v_shift);
    plot(xvec,yvec', 'Color',cmap(gI(ii),:));
end


%% EVENT LENGTHS  - ALL 

allEventLengths=cell2mat([C.eventLengths]);
t=10; %convert data to seconds
eventsSeconds=allEventLengths/t;

figure;
h1=histogram(eventsSeconds,10);
%title(t1,'FontName','Arial','FontSize',24 );
set(gca,'FontName','Arial','FontWeight','bold','FontSize',16 );
xlabel('Length (s)','FontName','Arial','FontWeight','bold','FontSize',18 );
ylabel('Number of Events','FontName','Arial','FontWeight','bold','FontSize',18 );
%h1.FaceColor = [0.5 0.5 0.5];


% EVENT LENGTHS  ALL - LOG

% log10 of the limits, compute linearly spaced bins, and then convert back by raising to the power of 10
logEdges=10.^(linspace(log(.2),log(2),10));

figure;
histogram(log(eventsSeconds), logEdges);
%title(t1,'FontName','Arial','FontSize',24 );
set(gca,'FontName','Arial','FontWeight','bold','FontSize',12 );
xlabel('Length (s)','FontName','Arial','FontWeight','bold','FontSize',18 );
ylabel('Number of Events','FontName','Arial','FontWeight','bold','FontSize',18 );
set(gca,'XScale','log');


%%  EVENT LENGTHS - TDTOMATO

%a(find(a==0))=[];

tomatoPosEL=allEventLengths(:,tomato_ind)/t;
tomatoNegEL=allEventLengths(:,neg_ind)/t;
figure;

subplot(2,1,1);histogram(tomatoPosEL,10,'BinLimits', [0,12],'Normalization', 'probability');
title('tdTomato + ');
ylim([0 .6]);

subplot(2,1,2);histogram(tomatoNegEL,10,'BinLimits',[0,12],'Normalization', 'probability');
ylim([0 .6]);
title('tdTomato - ');


%% EVENT LENGTHS CDF
% figure
figure;
%subplot(131);
set(gca,'LooseInset',get(gca,'TightInset'));

% plot
[h1,stats1]=cdfplot(tomatoPosEL);
hold on;
[h2,stats2]=cdfplot(tomatoNegEL);
grid('off');

% lines
set(h1,'LineWidth',3);
set(h2,'LineWidth',3);

% axis
axis square; 
set(gca,'FontSize',16,'FontWeight','bold');
xlabel('Event Lengths (s)','FontName','Arial','FontWeight','bold','FontSize',24 );
ylabel('Fraction of Cells','FontName','Arial','FontWeight','bold','FontSize',24 );
set(gca,'XLim',[0 10]);

%legend
mLegend{1}=sprintf('%s %s,%s',legend1{1},num2str(stats1.mean),num2str(stats1.std));
mLegend{2}=sprintf('%s %s,%s',legend1{2},num2str(stats2.mean),num2str(stats2.std));
legend(mLegend,'Box','off','Location','southeast');
%legend(legend1,'Box','off','Location','southeast');


%% EVENT LENGTHS REDUCED - TDTOMATO

allReducedLen=cell2mat([C.rLengths]);

tomatoPosReducedLen=allReducedLen(:,tomato_ind)/t;
tomatoNegReducedLen=allReducedLen(:,neg_ind)/t;

figure;

subplot(2,1,1);histogram(tomatoPosReducedLen,10,'BinLimits', [0,10],'Normalization', 'probability');
title('tdTomato + ');

subplot(2,1,2);histogram(tomatoNegReducedLen,10,'BinLimits',[0,10],'Normalization', 'probability');
ylim([0 .6]);
title('tdTomato - ');

% ---PLOT: event lengths (split by tdTomato)
% data
sem1=std(tomatoNegReducedLen)/sqrt(length(tomatoNegReducedLen));
sem2=std(tomatoPosReducedLen)/sqrt(length(tomatoPosReducedLen));

figure;

% Plot 1
subplot(121);hold on;
histogram(tomatoPosReducedLen,10,'BinLimits', [0,10],'Normalization', 'probability'); 
histogram(tomatoNegReducedLen,10,'BinLimits', [0,10],'Normalization', 'probability');
xlabel('Event Length (s)','FontName','Arial','FontWeight','bold','FontSize',24 );
set(gca,'FontSize',16,'FontWeight','bold'); 
hold off;

% plot 2
subplot(122);hold on;
bar([mean(tomatoNegReducedLen) mean(tomatoPosReducedLen)],...
    'FaceColor',[0 .44 .74]); 
errorbar([mean(tomatoNegReducedLen) mean(tomatoPosReducedLen)], [sem1 sem2], '.',  'Color',[0 0 0],...
        'LineWidth',2,'MarkerSize',8);
set(gca,'XTick',1:2,'XTickLabel',{'Arc-','Arc+'},  'FontSize',16,'FontWeight','bold'); 
ylabel('Mean Event Length (s)','FontName','Arial','FontWeight','bold','FontSize',24 );
hold off;

%% SELECT RUNNING EPOCHS

%display(vertcat(R{1,17:end}))
run=R(:,:); %CAREFUL TO SELECT THE RIGHT ANOUNT HERE 
C = [d02{:}]; 
I=[C.info];

 

clear M J
for i=1:length(run)

    
    % get filename info from run 
    file=run{1,i};
    [pa,fn]=fileparts(file);
    fn=strsplit(fn,'_');
    animal=fn{1}; region=fn{2}; %region=fn{3};

    
    
    % match run and imaging dataset
    a=cellfun( @(x) strcmp(x,animal), {I.animal} )
    %b=cellfun( @(x) strcmp(x,day), {I.day} )
    c=cellfun( @(x) strcmp(x,region), {I.region} )
    X=a+c;
    ind=find(X==2);
    
    
    % run mask is a vector that holds every frame where there was running
    % eo pools all events onsets across all rois. 
    % interest these variables should reveal the events that occured during
    % the running epochs.
    
    if ~isempty(ind)
        D=d02{ind};
        rm=find(run{8,i}.runMask);

        eo=cell2mat(D.eventOnsets);

        nRunEvents=length(intersect(eo,rm)); % can actually get which events by removing length.
        nNoRunEvents=length(eo)-nRunEvents;

        pr=run{8,i}.percentRun;

        fRunEvents=nRunEvents/pr;
        fNoRunEvents=nNoRunEvents/(1-pr);

        M(i)=v2struct(nRunEvents,nNoRunEvents,fRunEvents,fNoRunEvents);
        
        
        %sort tomato
        tomato_ind=find(ismember(D.tags,'tdTomato'));
        neg_ind=setdiff(1:D.num_rois,tomato_ind);
        
        eoT=cell2mat(D.eventOnsets(tomato_ind));
        eoN=cell2mat(D.eventOnsets(neg_ind));
        nRunEventsTom=length(intersect(eoT,rm));
        nNonRunEventsTom=length(eoT)-nRunEventsTom;
        nRunEventsNTom=length(intersect(eoN,rm));
        nNoRunEventsNTom=length(eoN)-nRunEventsNTom;
        
        
        fRunEventsTom=nRunEventsTom/pr;
        fRunEventsNTom=nRunEventsNTom/(1-pr);
        
        J(i)=v2struct(nRunEventsTom, nNonRunEventsTom, nRunEventsNTom,nNoRunEventsNTom, fRunEventsTom, fRunEventsNTom);
    end
end
%% NEW 12/05 - SELECT RUNNING EPOCHS

%display(vertcat(R{1,17:end}))
run=R(:,:); %CAREFUL TO SELECT THE RIGHT ANOUNT HERE 
C = [d02{:}]; 
I=[C.info];

 

clear M J
for i=1:length(run)

    
    % get filename info from run 
    file=run{1,i};
    [pa,fn]=fileparts(file);
    fn=strsplit(fn,'_');
    animal=fn{1}; region=fn{2}; %region=fn{3};

    
    
    % match run and imaging dataset
    a=cellfun( @(x) strcmp(x,animal), {I.animal} )
    %b=cellfun( @(x) strcmp(x,day), {I.day} )
    c=cellfun( @(x) strcmp(x,region), {I.region} )
    X=a+c;
    ind=find(X==2);
    
    
    % run mask is a vector that holds every frame where there was running
    % eo pools all events onsets across all rois. 
    % interest these variables should reveal the events that occured during
    % the running epochs.
    
    if ~isempty(ind)
        D=d02{ind};
        rm=find(run{8,i}.runMask);

        eo=cell2mat(D.eventOnsets);

        nRunEvents=length(intersect(eo,rm)); % can actually get which events by removing length.
        nNoRunEvents=length(eo)-nRunEvents;

        pr=run{8,i}.percentRun;

        fRunEvents=nRunEvents/pr;
        fNoRunEvents=nNoRunEvents/(1-pr);

        M(i)=v2struct(nRunEvents,nNoRunEvents,fRunEvents,fNoRunEvents);
        
        
        %sort tomato
        tomato_ind=find(ismember(D.tags,'tdTomato'));
        neg_ind=setdiff(1:D.num_rois,tomato_ind);
        
        eoT=cell2mat(D.eventOnsets(tomato_ind));
        eoN=cell2mat(D.eventOnsets(neg_ind));
        nRunEventsTom=length(intersect(eoT,rm));
        nNonRunEventsTom=length(eoT)-nRunEventsTom;
        nRunEventsNTom=length(intersect(eoN,rm));
        nNoRunEventsNTom=length(eoN)-nRunEventsNTom;
        
        
        fRunEventsTom=nRunEventsTom/pr;
        fRunEventsNTom=nRunEventsNTom/(1-pr);
        
        J(i)=v2struct(nRunEventsTom, nNonRunEventsTom, nRunEventsNTom,nNoRunEventsNTom, fRunEventsTom, fRunEventsNTom);
    end
end




%% OLDDD


%% Get region number to look at effects of recording time and tomato expression 

tPosLabels=exLabels(tomato_ind,:); 
regNum=regexp(tPosLabels(:,2),'\d','match');
regionNum2=str2num(cell2mat(vertcat(regNum{:})));
x = tom_nEvents+(rand(size(tom_nEvents))-0.5)*0.8;


figure;
scatter(regionNum2, x);
set(gca,'XTick',0:7);
xlabel('FOV number','FontName','Arial','FontWeight','bold','FontSize',18 );
ylabel('Number of Events (tdTomato+)','FontName','Arial','FontWeight','bold','FontSize',18 );

figure;
histogram(regionNum2);
xlabel('FOV number','FontName','Arial','FontWeight','bold','FontSize',18 );
ylabel('Count of ROIs (tdTomato+)','FontName','Arial','FontWeight','bold','FontSize',18 );


%% Scatter events - same ROIs two days
% delete low firing cells

figure;scatter(a,b)

% S=sum([a;b],1);
% 
% ind=find(S < 15);
% 
% a(ind)=[];
% b(ind)=[];


figure;scatter(a,b); hold on;
set(gca,'XLim', [ 0 60], 'YLim', [ 0 60]);
 line([0,60],[0,60],'linewidth',1,'color',[1,0,0]);
ylabel('Wheel - D01');
xlabel('Wheel - D04');
axis square;

%% PLot - mean nEvents, 3 datasets

M=cellfun(@mean,{a,b,c})
S=cellfun(@std,{a,b,c})./sqrt(cellfun(@length,{a,b,c}))


figure;
hold on;
bar(M,'FaceColor',[0 .44 .74]); 
errorbar(M, S, '.',  'Color',[0 0 0],...
        'LineWidth',2,'MarkerSize',8);
set(gca,'XTick',1:3,'XTickLabel',{'Wheel - D1','Wheel - D2','Homecage - D3'}); 
ylabel('Mean Number of Events','FontName','Arial','FontWeight','bold','FontSize',18 );
hold off;



%% run plot matched with waterfall


figure; plot(R{7,2},'Color','r');

axis off;
set(gca, 'LooseInset', [0,0,0,0]);
set(gcf, 'Units', 'Inches', 'Position', [0, 0, 10.0, 1.0], 'PaperUnits', 'Inches', 'PaperSize', [10.0, 1.0])


%% FOR EB ARC 4 STYLE DATA
%% nEvents across the same FOVs

n=reshape(nEvents,226,3);

figure; imagesc(n,[0 40]); colormap hot; 


%% sum 3

a=sum(n(:,1:3),2)
b=sum(n(:,4:6),2)

figure; plot(a); hold on; plot(b);

%% scatter with jitter
scatter(con(:,1),con(:,2), 'o', 'jitter','on', 'jitterAmount', 0.5);


%%
% lines

figure;
hold on;
for ii=13:18
    x=datasets{ii}.nEvents;
    [h,stats]=cdfplot(x);
    %ev(ii)=sum();
    set(h,'LineWidth',3);
end

grid('off')
