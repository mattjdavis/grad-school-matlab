% multi animal, percent running


ids={'C1', 'T1', 'C2', 'T2', 'T3'};
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


%% compare trials type for number of 

animal='md081';
%days={'td06' 'td07' 'td08' 'td09','td10'};
days={'td09','td10'};

for i=1:length(days)
    day=days{i};
    S=data.(animal).(day);
    
    cr=find(S.Cr);
    nocr=setdiff(11:70,cr);
    
    rpm_cr=cell2mat(S.rpm(9,cr));
    rpm_nocr=cell2mat(S.rpm(9,nocr));
    
    run_cr_per(i,1)=length(find(rpm_cr))/length(cr);
    run_cr_per(i,2)=length(find(rpm_nocr))/length(cr);
end

figure; bar(run_cr_per);