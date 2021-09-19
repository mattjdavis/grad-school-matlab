%% single process
% *************************************************************************


B=process_tone_track('X:\imaging\wheel_run_3\probe\day3\md214_02012017_gamma1_2017_02_01_03_38_08_373.txt');

%% batch process
% *************************************************************************

path='X:\imaging\wheel_run_6\r\';
DATA=batch_tone_track(path);

%% print data
% *************************************************************************for

% grab distance
clear dist
for i=1:length(DATA)
dist(i)=DATA(i).behavior.LAP.dist_cm;
end

%% first licks
clear dist
for i=1:length(DATA)
dist(i)=DATA(i).behavior.LICK.f_licks_num;
end

%% first licks
clear dist
for i=1:length(DATA)
dist(i)=DATA(i).behavior.LICK.nffl_az;
end

%% first licks
clear dist
for i=1:length(DATA)
dist(i)=DATA(i).behavior.REWARD.rnum;
end



%% DATASET
animal=categorical({DATA.animal}');
day=categorical({DATA.day}');
tdist=dist';


ds=dataset(animal,day,tdist);

% remove animals, days
% toDelete= ds.animal=='md228';
% ds=ds(~toDelete,:);

% get stats
stats = grpstats(ds,'day',{'mean','max','std'},'DataVars','tdist');
stats = sortrows(stats,'day','ascend');

% get names
animal_names=categories(removecats(ds.animal));
day_names=categories(removecats(ds.day));

%% PLOT TOTAL DISTANCE OR FLICKS

%flags
type='licks';
plot_mean=1;
plot_legend=0;
reward_patch=1;

% set fig
fig1=figure; 
ax1=gca;
hold on;
box off;
set(gca,'LooseInset',get(gca,'TightInset'));

% axis properties, type dependent
if (strcmp(type,'laps'))
    sc=192;
    %ylabel('Total distance (cm)','FontName','Arial','FontWeight','bold','FontSize',16 );
    ylabel(ax1,'Number of laps','FontName','Arial','FontWeight','bold','FontSize',16 );
    
    ymax=40;
    set(gca,'YLim',[0 ymax]);
    
elseif (strcmp(type,'licks'))
    sc=1;
    ymax=4000;
    set(gca,'YLim',[0 ymax]);
    ylabel(ax1,'Total licks','FontName','Arial','FontWeight','bold','FontSize',16 );
    
end
    

%;
%ds=d

% plot mean
if (plot_mean)
plot(ax1,stats.day,stats.mean_tdist/sc,'b','LineWidth',3,...
    'MarkerSize',10,'Marker','square') ;
end

% remove certain animal/day
%ind=strfind(animal_names,'md228');
%ind=find(~cellfun(@isempty,ind));
%animal_names(ind)=[];

% plot individual
for i=1:length(animal_names)
    
    ds1=ds(ds.animal==animal_names{i},:);
    plot(ax1,ds1.day,ds1.tdist/sc,'LineWidth',1.5,...
        'MarkerSize',8,'Marker','square',...
        'LineStyle','--');
end


% legend
if( plot_legend)
    if (plot_mean)
        legend(ax1,[{'mean'}; animal_names],'Box','off','Location','northwest');
    else 
        legend(ax1,[animal_names],'Box','off','Location','northwest');
    end
end

% x-axis
axis square;
%set(gca,'XTick',1:4,'XTickLabel',day_names);
set(ax1,'XTick',1:2:length(day_names),'XTickLabel',1:2:length(day_names));
set(ax1,'FontSize',14,'FontWeight','bold');
xlabel(ax1,'Days','FontName','Arial','FontWeight','bold','FontSize',16 );

% laps
if (strcmp(type,'laps'))
    
    % criteria line
    hline = refline(ax1,[0 3840/sc]);
    hline.Color = [.5 .5 .5]; hline.LineWidth=2; hline.LineStyle=':';

    % reward patch
    if (reward_patch)
        y = [ 0 0 ymax ymax];
        x = [ 10 15 15 10];
        p1=patch(x,y,'b','edgecolor','none','facealpha',0.1);  
    end

end

% *************************************************************************
%% PLOT - ffl_rz
% *************************************************************************

% set fig
fig2=figure; 
ax2=gca;
hold on;
box off;
set(gca,'LooseInset',get(gca,'TightInset'));

% y
%ax2.YLim=[0 .14];

if (plot_mean)
%plot(ax2,stats.day,stats.mean_tdist,'b','LineWidth',3,...
%    'MarkerSize',10,'Marker','square') ;
sem=stats.std_tdist/sqrt(length(stats.std_tdist));
er=errorbar(ax2,stats.day,stats.mean_tdist,sem);
er.LineWidth=2;
%er.CapSize=10; %2016




end
ylabel(ax2,'Number of Rewards','FontName','Arial','FontWeight','bold','FontSize',16 );
%ylabel(ax2,'Fraction of licks','FontName','Arial','FontWeight','bold','FontSize',16 );
%title('Fraction of Licks in Anticipation Zone');

yl=ylim
if (reward_patch)
    y = [ 0 0 yl(2) yl(2)];
    x = [ 10 15 15 10];
    p1=patch(x,y,'b','edgecolor','none','facealpha',0.1);  
end



% x-axis
axis xy;
%set(gca,'XTick',1:4,'XTickLabel',day_names);
set(ax2,'XTick',1:2:length(day_names),'XTickLabel',1:2:length(day_names));
set(ax2,'FontSize',14,'FontWeight','bold');
xlabel(ax2,'Days','FontName','Arial','FontWeight','bold','FontSize',16 );

% *************************************************************************
%% plot lick rate
% *************************************************************************



% select day
rbin=[23 24];
d= ds.day=='04262017';
d=find(d);
lr=[];
lrsn=[];
lrf=[];


% got filt-filt to work, zero phase lag, but exagerrates licking
for i=1:length(d)
    lr(i,:)=DATA(d(i)).behavior.LICK.lick_rate;

    % gaussian
    %w = gausswin(10);
    %lrs(i,:) = filter(w,1,lr(i,:));
    
    % moving average, single firection
    %k = ones(1, 5) / 5; lrs(i,:) = filter(k, 1,lr(i,:));
    
    % normalize
    x=lr(i,:);
    x = (x-min(x))/(max(x)-min(x));
    
    % moving average filter
    xfilt=zeros(size(x));
    w=1;
    h = ones(w,1)/w; 
    xfilt=filtfilt(h,1,x);
    
    xfilt2=filtfilt(h,1,lr(i,:));
    
    lrn(i,:)=x; % normalized
    lrnf(i,:)=xfilt; % filtered
    lrf(i,:)=xfilt2;
    %
end

figure;plot(lrf');
hold on;  plot(mean(lrf),'b','LineWidth',3);
ylabel(gca,'Lick rate (hz)','FontName','Arial','FontWeight','bold','FontSize',16 );
set(gca,'FontSize',14,'FontWeight','bold');
xlabel(gca,'Track bin (1 bin=16 sq)','FontName','Arial','FontWeight','bold','FontSize',16 );

%% add vmk
hold on;  plot(vmkd,'r','LineWidth',3,'LineStyle','-.');
set(gca,'YLim',[-.01 7]);

%%

% dif

dlrf=diff(mean(lrf)); %diff lick rate filt
% *************************************************************************
%% Smooth lick rate
% *************************************************************************
%figure;imagesc(lrsn); colormap hot

%fig
fig1=figure; 
ax1=gca;

% plot
plot(lrsn','Color',[.5 .5 .5]);
hold on;  plot(mean(lrf),'b','LineWidth',3);



% axis
ymax=6;
ax1.YLim=[0 ymax];
ax1.XLim=[0 32];
axis square;
%set(gca,'XTick',8:8:24,'XTickLabel',);
set(ax1,'FontSize',14,'FontWeight','bold');
%ylabel(ax1,'Mean lick rate (A.U.)','FontName','Arial','FontWeight','bold','FontSize',16 );
xlabel(ax1,'Tone frequency (kHz)','FontName','Arial','FontWeight','bold','FontSize',16 );
box off;
% xaxis
set(ax1,'XTick',[ 10 20 30],'XTickLabel',{'4.4','5.4','6.4'});


% reward
reward_zone=23:25;
y = [ 0 0 ymax ymax];
x = [ reward_zone(1) reward_zone(end) reward_zone(end) reward_zone(1)];

p1=patch(x,y,'r','edgecolor','none','facealpha',0.2);

%%
figure;imagesc(lrsn); colormap hot

% *************************************************************************
%% Lap position example
% *************************************************************************
dn=42;

pos=DATA(dn).behavior.T.lap_position; % from wheel_run_5
lick=DATA(dn).behavior.LICK.f_licks;
rew=DATA(dn).behavior.T.reward;
rt=find(diff(rew)) + 1; % reward time

% PLOT
fig=figure;
box off;
set(gca,'LooseInset',get(gca,'TightInset'));
set(fig, 'units', 'inches', 'pos', [0 0 10 1.5]) 

% DATA
ind=find(abs(diff(pos)) >= 255);
pos_plot= pos; pos_plot(ind)=NaN;

% line
hline=plot(pos_plot);
hline.LineWidth=2;

% lick
y2=256+55;
y1=y2-35;
for i =1:length(lick)
       
    if(lick(i)); 
        line([i i],[y1 y2],'LineWidth',1,'LineStyle','-','Color',[0 0 0]);
    end
end

%reward
hold on;
yv=ones(length(rt),1)*335;
scatter(rt,yv,'o','filled','MarkerEdgeColor', [1 0 0]);



% axis 
ax1=gca;
yruler = ax1.YRuler;
yruler.Axle.Visible = 'off';
xruler = ax1.XRuler;
xruler.Axle.Visible = 'off';
set(gca,'XTickLabel','')
set(gca,'Xtick',[],'Ytick',[]);
set(gca,'FontSize',14,'FontWeight','bold');

set(gca,'YTick',[64 128 192 256] ,'YTickLabel',[48 96 144 192]); %
set(gca,'YTick',[ 128 256] ,'YTickLabel',{'5.0', '6.6'}); %
%postion, cm

%set(gca,'YTick',[64 128 192 256] ,'YTickLabel',[48 96 144 192]);

% *************************************************************************
%% SELECT SUBSET
% *************************************************************************
days={'01102017'}; 


 
ind1=false(length({DATA.day}),1)';
for i=1:length(days)
    x=strcmp({DATA.day},days{i});
    ind1=ind1 | x;
    
end

S=DATA(ind1); %sub struct

%ind2=~ind1;select  other days 

%% Plot single
B=[S.behavior];
R=[B.RUN];
epl= [R.lengthRunEpochs];
epl=(epl*15)/1000; 
%epl=cell2mat(epl');
figure;histogram(log10(epl),'BinLimits',[0 5]);




% *************************************************************************
%% Multi select, & plot
% *************************************************************************
grouping={'01052017','01062017','01072017','01082017','01092017', '01102017'}; 
 
figure;hold on;

for k=1:length(grouping)
    
    days=grouping(k);
    ind1=false(length({DATA.day}),1)';
    for i=1:length(days)
        x=strcmp({DATA.day},days{i});
        ind1=ind1 | x;

    end

    S=DATA(ind1); %sub struct
    
    
    B=[S.behavior];R=[B.RUN];
    epl= [R.lengthRunEpochs];
    epl=(epl*15)/1000; 
    
    
    set(gca,'LooseInset',get(gca,'TightInset'));

    % plot
    [h(k),stats(k)]=cdfplot(epl);
    grid('off');

    % lines
    set(h(k),'LineWidth',2);
    
end

set(gca,'XLim',[ 0 30]);

legend(grouping,'Box','off','Location','southeast');
axis square;
%%

figure; ax1=axes(); hold on;
%figure;ax2=axes(); hold on;
for ii=1:15
    D=DATA(ii).behavior;
    
    figure;x=histogram(D.LICK.Z_flicks_nLL_P,10); xx=x.Values;close(gcf);
    %figure;x=histogram(D.LICK.zone_probe_licks,10); xx=x.Values;close(gcf);
    y1=D.zone(D.LAP.probe_lap_ind); 
    figure;y2=histogram(y1,10); yy=y2.Values; close(gcf);
    %plot(ax1,xx./yy);
    %plot(ax2,xx);
    
    zl(ii,:)=xx;
end

%%
figure;plot(zl(13:15,:)','g'); hold on; plot(mean(zl(13:15,:))','r','LineWidth',3);

%%
%  probe laps, lick rate
figure;
subplot(411);
h3=histogram(zones_probe_licks,10);


subplot(412);
h1=histogram(f_licks_probe_zone,10);

% position in probe laps
subplot(413);h2=histogram(position(probe_laps),10);

% rate of licks
subplot(414);plot(h1.Values./h2.Values);

%%
%check probes
reward=AA(:,4);


reward_ind=find( diff(reward) ==1);

intersect(probe_laps,reward_ind);

%% ds for pupil
r=diff(reward);
rd=find(diff(reward)==1)

ds=linspace(1,36803,6050);

%for ii=1:length(rd)
    
Vi=interp1(1:36803, reward, ds, 'linear'); 

rd=find(diff(Vi)==1)

%%

figure;plot(PD.pupil_r_left);
y=PD.pupil_r_left(rd);
hold on; scatter(rd,y);

%% running
Vi=interp1(1:36803, rpm v n, ds, 'linear'); 
figure;plotyy(1:6050,PD.pupil_r_left,1:6050,Vi);






