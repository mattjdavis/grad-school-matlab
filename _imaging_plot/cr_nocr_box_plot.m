%

%1st two intial days of learning

%animal='md076'; days_learn={'td09', 'td10'}; days_pre={'td04', 'td05', 'td06', 'td07', 'td08'};
%animal='md079'; days_learn={'td06', 'td07'}; days_pre={'td01', 'td02', 'td03', 'td04', 'td05'};
%animal='md081'; days_learn={'td09', 'td10'}; days_pre={'td04', 'td05', 'td06', 'td07', 'td08'};

 days_learn={'td10'};
 days_pre={'td07'};

%%

in.day_choice=days_learn;
in.vars=['noCr'];
nocr_out=process_flouro_data(in,data,0);
%plot_flouro(in,nocr_out,0);

in.day_choice=days_learn;
in.vars=['cr'];
cr_out=process_flouro_data(in,data,0);
%plot_flouro(in,cr_out,0);


in.day_choice=days_pre;
in.vars=['no_b'];
pre_out=process_flouro_data(in,data,0);
%plot_flouro(in,pre_out,0);

%%


    
traces1=cell2mat(cr_out.active_traces(:)');
traces2=cell2mat(nocr_out.active_traces(:)');
traces3=cell2mat(pre_out.active_traces(:)');

%cr
x=trapz(traces1);
avg_auc_cr=mean(x);
sem_auc_cr=std(x) / sqrt(size(x,2));

%nocr
y=trapz(traces2);
avg_auc_nocr=mean(y);
sem_auc_nocr=std(y) / sqrt(size(y,2));

%pre
z=trapz(traces3);
avg_auc_pre=mean(z);
sem_auc_pre=std(z) / sqrt(size(z,2));
    

%figure;
figure; hold on;

%colors
c2=[0.2941    0.5447    0.7494];
c1=[0.9047    0.1918    0.1988];

%axis
set(gca,'XTick',[1 1.1],'XTickLabel',{'Pre-learning Days' 'Initial Learning Days'});
ylabel('Average area under curve', 'FontSize', 24, 'FontWeight','bold');
%xlabel('Day', 'FontSize', 12, 'FontWeight','bold');
set(gca, 'FontWeight','bold','FontSize',12,...
    'LineWidth',2);
hold(gca,'all');
set(gca,'Ylim',[0 1600]);


%error bars
eb1=errorbar([1.1],avg_auc_cr, sem_auc_cr);
eb2=errorbar([1.1],avg_auc_nocr, sem_auc_nocr);
eb3=errorbar([1],avg_auc_pre, sem_auc_pre);
set(eb1,'LineWidth',3, 'Color',c1,...
    'Marker','square',...
    'MarkerSize',8,'MarkerFaceColor', [1 1 1]);
set(eb2,'LineWidth',3, 'Color',c2,...
    'Marker','square',...
    'MarkerSize',8,'MarkerFaceColor', [1 1 1]);
set(eb3,'LineWidth',3, 'Color',[0.5 0.5 0.5],...
    'Marker','square',...
    'MarkerSize',8,'MarkerFaceColor', [1 1 1]);





  




%bar([avg_auc_nocr avg_auc_cr]);
