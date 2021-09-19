path='X:\\imaging\\wheel_run_6\\';

files = dir(fullfile(path, '*.txt'));
files = {files.name}';

numpos=384;

for i=1:length(files)
    % parse file
    split_fns=strsplit(files{i},'_');
    animal{i,1}=split_fns{1};
    day{i,1}=split_fns{2};
    group{i,1}=split_fns{3};
    
    % import table
    file=strcat(path,files{i});
    T=readtable(file);
    behavior=T; 
    
    
    % parse table
    nreward(i,1)=max(T.reward);
    dist(i,1)=max(T.position);
    nlicks(i,1)=sum(T.lick_detected);
    
    
    %get length of ones
    dt=16;
    A = logical(behavior.beep_on');
    [lengths, values] = runLengthEncode(A);
    beep_lengths{i,1} = lengths(values==1)*dt; %
    off_lengths{i,1} = lengths(values==0)*dt; %
    
    %length of total time
    beep_percent(i,1)=length(find(A))/length(A);
    
    % licks, 1/2 of descending
    e=round(0.75*numpos);
    s=round(0.5*numpos);
    pos=behavior.lap_position;
    ind=find(pos >= s & pos <= e);
    licks_desc1(i,1)=sum(T.lick_detected(ind));
    
    
    %display
    display(sprintf('File processed...%s',file));
end

data=table(animal,day,group,nreward,dist,nlicks,licks_desc1,beep_percent,beep_lengths, off_lengths);
data2=sortrows(data,{'animal'});
%data2=sortrows(data,{'day','animal'});

%% hack 
ndays=14;
plot_mean=0;
%dist=reshape(data.nreward,ndays,[]);
dist=reshape(data.dist/384,ndays,[]);
%dist=reshape(data.nlicks,ndays,[]);
%dist=reshape(data.licks_desc1,ndays,[]);

figure;plot(dist);
ax=gca;

 plot(dist,'LineWidth',1.5,...
        'MarkerSize',8,'Marker','square',...
        'LineStyle','--');
ylabel('Laps','FontName','Arial','FontWeight','bold','FontSize',16 );
xlabel('Days','FontName','Arial','FontWeight','bold','FontSize',16 );
set(gca,'FontSize',14,'FontWeight','bold');
ax.XTick=1:14;
if (plot_mean)
    plot(ax1,stats.day,stats.mean_tdist/sc,'b','LineWidth',3,...
        'MarkerSize',10,'Marker','square');
end

 axis xy;

%stats=grpstats(data,'day',{'mean'},'DataVars','dist')

%% plot with broken axis

%% hack 
ndays=16;
plot_mean=0;
sc=384; % scale

stats=grpstats(data,'day',{'mean'},'DataVars','dist');

%var=reshape(data.dist/sc,ndays,[]);
%var=reshape(data.nlicks,ndays,[]);
%var=reshape(data.licks_desc1,ndays,[]);
var=reshape(data.nreward,ndays,[]);

% split
xvar{1}=1:8;xvar{2}=9:11;xvar{3}=12:16;
dist{1}=var(1:8,:);dist{2}=var(9:11,:);dist{3}=var(12:16,:);

figure; hold on;
ax=gca;


for ii=1:length(dist)
plot(xvar{ii},dist{ii},'LineWidth',1.5,...
        'MarkerSize',8,'Marker','square',...
        'LineStyle','--');
end
    
    
%Total licks (descending,1st half)
ylabel('Rewards','FontName','Arial','FontWeight','bold','FontSize',16 );
xlabel('Days','FontName','Arial','FontWeight','bold','FontSize',16 );
set(gca,'FontSize',14,'FontWeight','bold');

ax.XTick=1:16;

if (plot_mean)
    plot(ax,stats.mean_dist/sc,'b','LineWidth',3,...
        'MarkerSize',10,'Marker','square');
end

 axis xy;



%% get length of ones
dt=16;
A = logical(behavior.beep_on');
[lengths, values] = runLengthEncode(A);
beep_lengths = lengths(values==1)*dt; %


%% hist - Percent tone on

figure;hist(data.beep_percent)
ax=gca;
ax.XLim=[.1 .9];
ylabel('Count','FontName','Arial','FontWeight','bold','FontSize',16 );
xlabel('Tone on (%)','FontName','Arial','FontWeight','bold','FontSize',16 );
