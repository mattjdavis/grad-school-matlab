%% compare trials types for number of observed run events

% TO DO
% 1) make cr_per real

%cr_per={'31.6 %' '15.0 %' '53.3 %' '45.0 %' '53.3 %' '51.7 %' '63.3 %'};
cr_per={};

animal=cell2mat(fields(data));
days={'td07' 'td08' 'td09' 'td10' 'td11'  'td12'};
%days={'td06' 'td07' 'td08' 'td09','td10'};
%days={'td06' 'td07' 'td08' 'td09','td10' 'td11', 'td12' 'td13'};
%days={'acc01','acc02' 'acc03'};
trial_type1=['cr']; trial_type2=['noCr'];
%trial_type={'probe', 'paired'};
%trial_type={'cs','us'};
ylim=[0 40];


figure; ax1=gca; %hold on;


for i=1:length(days)
    day=days{i};
    S=data.(animal).(day);
    
    % select trials
    tt1=TrialSelector(S,trial_type1);
    tt2=TrialSelector(S,trial_type2);
    
    
    rpm_tt1=cell2mat(S.rpm(9,tt1));
    rpm_tt2=cell2mat(S.rpm(9,tt2));
    
    % running percent
    % may be able to get rid of this
    run_num(i,1) =length(rpm_tt1);
    run_num(i,2) =length(rpm_tt2);
    run_per(i,1)=run_num(i,1)/length(tt1);
    run_per(i,2)=run_num(i,2)/length(tt2);
    
    % individual running matrix, ALL TRIALS
    %ind1=find(rpm_tt1); ind1=tt1(ind1);
    %ind2=find(rpm_tt2); ind2=tt2(ind2);
    rpm_tt1_traces{i}=cell2mat(S.rpm(8,tt1)); 
    rpm_tt2_traces{i}=cell2mat(S.rpm(8,tt2));
   
    %rpm_tt1_traces=reshape(rpm_tt1_traces,[],60);
    %rpm_tt2_traces=reshape(rpm_tt2_traces,[],60);

    
    % avg of running
    avg_tt1=mean(rpm_tt1_traces{i},2); %sem_tt1= std(x) / sqrt(size(x,2))
    avg_tt2=mean(rpm_tt2_traces{i},2); %sem_tt2= std(x) / sqrt(size(x,2))
%     
%     %plot individual
%     %figure; colormap('jet');imagesc(rpm_tt1_traces', [0 30]);
%     figure; plot(rpm_tt1_traces{i});
%     title(sprintf('Animal: %s, Day: %s, Type:%s', animal, day, trial_type1));
%     %figure; colormap('jet');imagesc(rpm_tt2_traces', [0 30]);
%     figure; plot(rpm_tt2_traces{i});
%     title(sprintf('Animal: %s, Day: %s, Type:%s', animal, day, trial_type2));
%     
    % MULTIPLE AVGS
    axis(ax1); hold on;
    plot(ax1,(1:60)+(70*i),avg_tt1','LineWidth',2, 'Color','r'); 
    plot(ax1,(1:60)+(70*i),avg_tt2','LineWidth',2,'Color','b');
    %all_fr=65*length(days); label1=repmat([1.0 3.0 6.0],1,length(days));
    %set(ax1,'XTick',65:35:all_fr, 'XTickLabel',label1)
    set(ax1,'XTick',[],'YLim', ylim);
    xlabel('Time'); ylabel('Running (RPM)');
    % line
    x_line= [25 25] +(i*70);
    x_line2= [22 22] +(i*70);
    line(x_line,[20 25],'LineWidth',2,'LineStyle','-','Color',[.5 .5 .5]);
    line(x_line2,[20 25],'LineWidth',2,'LineStyle','-','Color',[0 0 1]);
    %text(x_line(2)+3,22,cr_per{i});
    
    legend({'CR Trials' ' No CR Trial'});
end

% figure; bar(run_per);
% set(gca,'XTickLabel', days);
% ylabel ('Trials with Running (%)'); xlabel('Days');

%% blank running

%% long trace, FLUORO and RPM

for i=1:1
    long_run=reshape(rpm_tt1_traces{3},1,[]);
    long_flouro=reshape(out.flouro{3}(:,tt1,1),1,[]);
end


figure;
%%subplot(2,1,1);
%%plot(long_run); subplot(2,1,2); plot(long_flouro);

ax=plotyy(1:length(long_run),long_run,1:length(long_flouro),long_flouro);
%ax=plotyy(1:length(long_run),reshape(out.flouro{3}(:,tt1,1),1,[]),1:length(long_flouro),reshape(out.flouro{3}(:,tt1,2),1,[]));
set(ax(1),'YLim',[0 60]);

%corr(long_run',long_flouro');

%% start vs stim induced running
% In my first idea the stim portion is favored to have larger values, it
% covers ~40 frames, whereas start is ~ 20 frames. Now, I make both vectors
% to be 20 elements (start and stim).

days={'acc01' 'acc02' 'acc03'};
days={'td01' 'td02' 'td03' 'td04' 'td05' 'td06' 'td07' 'td08' 'td09' 'td10' 'td11' 'td12'}

fig1=figure;

prs_vec=1:21;
pos_vec=22:43; % These need to be equalized 21 elements, else comparison could be off
trial_type1=['paired' 'run'];    trial_type2=['probe' 'run']; 

aniaml=fields(data);

for i=1:length(days)
    day=days{i};
    S=data.(animal).(day);
    rpm=S.rpm;
    
    
    

    for j=1:80 % FIX TRIAL NUM
        run=rpm{8,j};

        pre_stim(j)=trapz(run(prs_vec,1));
        post_stim(j)=trapz(run(pos_vec,1));
        run_ratio(j)=post_stim(j)-pre_stim(j); % is division or subtraction better?

    end

    % trial select
    
    tt1=TrialSelector(S,trial_type1);
    tt2=TrialSelector(S,trial_type2);

    a=run_ratio(tt1);a2=run_ratio(tt2);
    b=post_stim(tt1);b2=post_stim(tt2);
    c=pre_stim(tt1);c2=pre_stim(tt2);
    
    
    % hist
    get(fig1);
    subplot(length(days),1,i); hist(a);
    set(gca,'XLim',[ -600 600],'YLim',[0 25]);
    
    b_avg_tt1(i)=mean(b);     c_avg_tt1(i)=mean(c);
    b_avg_tt2(i)=mean(b2); c_avg_tt2(i)=mean(c2);
end

figure;
bar([b_avg_tt1' b_avg_tt2'],'grouped');
title('pre');

figure;
bar([c_avg_tt1' c_avg_tt2'],'grouped');
title('post');


%% combined running plot

ids={'Unpaired 1', 'Paired 1', 'Unpaired 2', 'Paired 2', 'Paired 3'}
N=size(percent_run,1);
C = linspecer(N);

fig1 = figure('Color',[1 1 1]); 
set(gcf, 'color', 'none');

for ii=1:N
    plot(percent_run(ii,:),'color',C(ii,:),'linewidth',3);
    hold on;
end;
set(gca,'XTick',0:10, 'XTickLabel',[0:10],...
    'Ylim',[0 1]);
ylabel('Percent of Running Trials', 'FontSize', 16);
xlabel('Day', 'FontSize', 16);
set(gca,'Box','off');

%legend
legend1 = legend(gca,ids);
set(legend1,'EdgeColor',[1 1 1],'Location','NorthEastOutside',...
    'YColor',[1 1 1],...
    'XColor',[1 1 1]);
