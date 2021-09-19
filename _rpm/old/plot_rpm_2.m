
%% compare trials types for number of observed run events

animal=cell2mat(fields(data));
%days={'td01' 'td02' 'td03' 'td04' 'td05' 'td06' 'td07' 'td08' 'td09','td10'};
%days={'td06' 'td07' 'td08' 'td09','td10'};
days={'td09','td10'};
trial_type={'cr', 'nocr'};
%trial_type={'probe', 'paired'};
%trial_type={'cs','us'};


figure; ax1=gca; %hold on;


for i=1:length(days)
    day=days{i};
    S=data.(animal).(day);
    
    % cr
    switch cell2mat(trial_type);
        case 'crnocr'
        %case 'cr'
            tt1=find(S.Cr);
            tt2=setdiff(11:70,tt1);
            display('yes');
        case 'probepaired'
            tt1=S.TrialTypeIndex{2,7};
            tt2=S.TrialTypeIndex{2,6};
        case 'csus'
            tt1=S.TrialTypeIndex{2,1};
            tt2=S.TrialTypeIndex{2,2};
    end
    
    rpm_tt1=cell2mat(S.rpm(9,tt1));
    rpm_tt2=cell2mat(S.rpm(9,tt2));
    
    run_per(i,1)=length(find(rpm_tt1))/length(tt1);
    run_per(i,2)=length(find(rpm_tt2))/length(tt2);
    
    % individual running matrix, ALL TRIALS
    ind1=find(rpm_tt1); ind1=tt1(ind1);
    ind2=find(rpm_tt2); ind2=tt2(ind2);
    rpm_tt1_traces=cell2mat(S.rpm(8,ind1)); 
    rpm_tt2_traces=cell2mat(S.rpm(8,ind2));
   
    %rpm_tt1_traces=reshape(rpm_tt1_traces,[],60);
    %rpm_tt2_traces=reshape(rpm_tt2_traces,[],60);

    
    % avg of running
    avg_tt1=mean(rpm_tt1_traces,2); %sem_tt1= std(x) / sqrt(size(x,2))
    avg_tt2=mean(rpm_tt2_traces,2); %sem_tt2= std(x) / sqrt(size(x,2))
    
    %plot individual
    %figure; colormap('jet');imagesc(rpm_tt1_traces', [0 30]);
    figure; plot(rpm_tt1_traces);
    title(sprintf('Animal: %s, Day: %s, Type:%s', animal, day, trial_type{1}));
    %figure; colormap('jet');imagesc(rpm_tt2_traces', [0 30]);
    figure; plot(rpm_tt2_traces);
    title(sprintf('Animal: %s, Day: %s, Type:%s', animal, day, trial_type{2}));
    
%     % plot avgs
%     axis(ax1); hold on;
%     plot(ax1,(1:60)+(70*i),avg_tt1','LineWidth',2, 'Color','r'); 
%     plot(ax1,(1:60)+(70*i),avg_tt2','LineWidth',2,'Color','b');
%     xlabel('Days'); ylabel('Running (RPM)');
%     % line
%     x_line= [25 25] +(i*70);
%     x_line2= [22 22] +(i*70);
%     line(x_line,[20 25],'LineWidth',2,'LineStyle','-','Color',[.5 .5 .5]);
%     line(x_line2,[20 25],'LineWidth',2,'LineStyle','-','Color',[1 0 0]);
end

figure; bar(run_per);
set(gca,'XTickLabel', days);
ylabel ('Trials with Running (%)'); xlabel('Days');

%% blank running


%%

%% start vs stim induced running
% In my first idea the stim portion is favored to have larger values, it
% covers ~40 frames, whereas start is ~ 20 frames. Now, I make both vectors
% to be 20 elements (start and stim).
rpm=run{1, 1}.rpm

r=cell2mat(rpm(8,:));

start=trapz(r(1:21,:));
stim=trapz(r(22:42,:));

[a,ind]=sort(stim);

run_ratio=stim./start; 




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
