%%
rpm_path='X:\\imaging\\wheel_run_3\\t\\';
behavior=process_rpm_lick(rpm_path,6000);


%% multi

%bouts_per_zone:
% zone_int:
% num_zones:
% percent_licks_per_zone:

% MAY ADD THIS TO PROCESS SCRIPT,


S=DATA(1).behavior;

zone_int=unique(S.zone);
num_zones=length(unique(S.zone));

for i=1:num_zones
    bouts_per_zone{i}=find(S.zone==zone_int(i));
    
    liz=intersect(S.lick_times,bouts_per_zone{i});%licks in zone
    
    num_licks_per_zone(i)=length(liz);
    
    
end

percent_licks_per_zone=num_licks_per_zone/sum(num_licks_per_zone);


Z=v2struct(zone_int,num_zones, bouts_per_zone,num_licks_per_zone,percent_licks_per_zone);

%%


lap_diff_threshold=100; % 100 works for lap length 104, diff ~103,104 so 100 is a fine threshold.
reward_zone=58:73;
reward_zone=6:22;
%ant_zone=43:57;  %10 cm before reward zone



% added for loop, j, to go through datasets
clear Z;

% sort array by day for easy indexing later (can change to animal);
[~,ind]=sort({DATA.day});
DATA=DATA(ind);

for j=1:length(DATA)

S=DATA(j).behavior;

zone_int=unique(S.zone);
num_zones=length(unique(S.zone));


for i=1:num_zones
    bpz=find(S.zone==zone_int(i)); %bouts per zone
    bouts_per_zone{i}=bpz;
    
    liz=intersect(S.lick_times,bouts_per_zone{i});%licks in zone
    num_licks_per_zone(i)=length(liz);
    percent_licks_per_zone(i)=length(liz)/S.lick_num;
    
    
    fl=length(bpz)/length(S.zone); % fraction licks
    num_licks_time_adj(i)= length(liz)*fl;% time adjusted licks in zone
    
    frames_in_zone(i)=length(bpz);
    
    
    
    
end

%get licks in reward zone
rew_ind=find(ismember(S.position_in_lap,reward_zone));
lir=intersect(S.lick_times,rew_ind); % licks in reward
percent_licks_in_rew=length(lir)/S.lick_num;

% get licks in anticipation zone
ant_ind=find(ismember(S.position_in_lap,ant_zone));
lia=intersect(S.lick_times,ant_ind); % licks in anticipation zone
percent_licks_in_ant=length(lia)/S.lick_num;

per_licks_time_adj=num_licks_time_adj/sum(num_licks_time_adj);

% get index of end of lap, clever use of diff! the diff must be above 100,
% but depends on lap length !
lap_end_ind=find(diff(S.position_in_lap) < - lap_diff_threshold);
lap_begin_ind=[0; lap_end_ind];
lap_begin_ind(end)=[];
lap_begin_ind=lap_begin_ind +1;
lap_length=lap_end_ind-lap_begin_ind;


licks_across_lap=S.position_in_lap(S.lick_times);

pil=S.position_in_lap;
% put vars in struct
Z(j)=v2struct(zone_int,num_zones, lap_length, bouts_per_zone,frames_in_zone,...
    num_licks_per_zone,percent_licks_per_zone,num_licks_time_adj,per_licks_time_adj,...
    percent_licks_in_ant,percent_licks_in_rew,licks_across_lap,pil);
end


%%
%C={Z.per_licks_time_adj}
C={Z.percent_licks_per_zone};
%C={Z.frames_in_zone};

%make this a stacked bar graph
 
%% mean per zone

pp=plotStruct() %plot params
pp.xT=1:4;
pp.xTL={'Z1','Z2','Z3','Z4'};
pp.xAL='Track zone';
pp.yAL='Percent Licks in Zone';
pp.yLim=[0 .8];

C1=cell2mat(C');
C2=num2cell(C1,[1 4]); % CHANGE 4 to get num zones
barWithData(C2',pp);

%% lap_length
ds=1:5; % datasets
ts=.05; % time, secs
tt=1/ts;

%LL=Z.lap_length; %all animals
LL={Z([ds]).lap_length};
C=cell2mat(LL');

figure; ax1=axes;
h1=scatter(1:length(C),C/tt); % putting tt converts to seconds
%ax1.YLim=[ 0 100];

%
figure;
semilogy(1:length(C),C/tt,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',[0 0 0],...
    'MarkerSize',10,...
    'Marker','.',...
    'Color',[1 1 1]);
%% Plot lick across days
rs=5; % reshape num, 5 for animals

tmp={Z.percent_licks_in_ant};
tmp=cell2mat(reshape(tmp,rs,[]));

mean_lia=mean(tmp);
sem_lia=std(tmp)./sqrt(numel(tmp));

% plot
figure;4
errorbar(mean_lia,sem_lia);
%set(gca,'YLim',[.1 .2]);


%% Plot lick across days 
rs=5; % reshape num, 5 for animals

tmp={Z.percent_licks_in_rew};
tmp=cell2mat(reshape(tmp,rs,[]));

mean_lir=mean(tmp);
sem_lir=std(tmp)./sqrt(numel(tmp));

% plot
figure;
errorbar(mean_lir,sem_lir,'LineWidth',2);
%set(gca,'YLim',[.1 .25]);
set(gca,'XTick',1:rs);
set(gca,'FontSize',16,'FontWeight','bold');
xlabel('Day','FontName','Arial','FontWeight','bold','FontSize',18 );
ylabel('Fraction of Licks','FontName','Arial','FontWeight','bold','FontSize',18 );
box off;


%% licks across lap
lal={Z.licks_across_lap};
lal=reshape(lal,rs,[]);

figure; 
set(gca,'LooseInset',get(gca,'TightInset'));


    xx=cell2mat(lal(:,1));
    

    histogram(xx,26,'Normalization','probability');
    p1=patch(x,y,'r','edgecolor','none','facealpha',0.2);
    set(gca,'YLim',[0 .2]);


%% subplot

lal={Z.licks_across_lap};
lal=reshape(lal,rs,[]);

tip={Z.pil}; %timeinposition
tip=reshape(tip,rs,[]);


ymax=.15;

figure; 
%set(gca,'LooseInset',get(gca,'TightInset'));
%hold on;

ha = tight_subplot(1,5);

y = [ 0 0 ymax ymax];
x = [ reward_zone(1) reward_zone(end) reward_zone(end) reward_zone(1)];

for i=1:5
    xx=cell2mat(lal(:,i));
    axes(ha(i));
    %histogram(xx,26,'Normalization','probability');
    %set(gca,'YLim',[0 ymax]);
    %axis square;
    
    % reward patch
    p1=patch(x,y,'r','edgecolor','none','facealpha',0.2);
    
    % time in position
    yy=cell2mat(tip(:,i));
    a1=histogram(xx,26); a1.Data=a1D; a1.BinEdges=a1BE;
    a2=histogram(yy,26);a2.Data=a2D;
    lick_rate=a1D/a2D;
    histogram(lick_rate,a1BE);
    set(gca,'YLim',[0 ymax]);
    axis square;
    
end

set(ha(2:end),'YTickLabel','')
ylabel(ha(1),'Fraction of Licks','FontName','Arial','FontWeight','bold','FontSize',18 );

    