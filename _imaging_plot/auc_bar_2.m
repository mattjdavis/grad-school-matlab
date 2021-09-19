


in.vars={'blank' 'bb' 'bt'};
output1=process_fluor_data(in,dataset,freq_active_thresh);



in.vars={'no_blank' 'bb' 'bt'};
output2=process_fluor_data(in,dataset,freq_active_thresh);


%% lengths


in.vars=['run'];
output1=process_flouro_data(in,dataset,0);
l_cr=plot_lengths(output1.lengths,in.day_choice, 'no');

%%
in.vars=['run' 'paired'];
output2=process_flouro_data(in,data,0);
l_nocr=plot_lengths(output2.lengths,in.day_choice, 'no');


%%

in.vars=['blank'];
%in.vars=['paired'];
output1=process_flouro_data(in,data,0);

in.vars=['paired'];
%in.vars=['run'];
output2=process_flouro_data(in,data,0);

var_names={'Avg_USnoRun' 'sem_USnoRun' 'Avg_USRun' 'sem_USRun' };


%%
% great code for figuring out error bars
c2=[0.2941    0.5447    0.7494];
c1=[0.9047    0.1918    0.1988];

avg=[output1.avg_auc; output2.avg_auc]';
sem=[output1.sem_auc; output2.sem_auc]';


x_label=[7:13]; 
ylim=[0 1400];

% AVG AUC BAR
% fig + bar
fig = figure('Color', [1 1 1]);hold on;
h=bar(avg, 'BarWidth', 1);
set(h(1),'FaceColor',c1, 'EdgeColor',c1);
set(h(2),'FaceColor',c2, 'EdgeColor', c2);

% axis
set(gca,'XTick',1:length(x_label),'XTickLabel',x_label);
ylabel('Average area under curve', 'FontSize', 16, 'FontWeight','bold');
xlabel('Day', 'FontSize', 16, 'FontWeight','bold');
set(gca, 'FontWeight','bold','FontSize',12,...
    'LineWidth',2);
hold(gca,'all');
set(gca,'Ylim',ylim);

%error bars
a = bsxfun(@plus, h(1).XData, [h.XOffset]');
eb1=errorbar([a(1,:);a(2,:)]',avg,sem,'.');
set(eb1(1),'LineWidth',2, 'Color','black');
set(eb1(2),'LineWidth',2, 'Color', 'black');

%%
% TABLES
T1=table(avg(:,1), sem(:,1), avg(:,2),sem(:,2),'RowNames',in.day_choice',...
    'VariableNames',var_names);
%could put number of cs and us running trials
T2=table(output1.num_trials', output2.num_trials','RowNames',in.day_choice',...
    'VariableNames',{'Num_US_no', 'Num_US_Run'});
display(T2);
display(T1);



%% single

avg=[out.avg_auc; out.avg_auc]';
sem=[out.sem_auc; out.sem_auc]';


%% combined 
avg2=[output1.avg_auc; output2.avg_auc];
sem2=[output1.sem_auc; output2.sem_auc];

avg3=[avg avg2]';
sem3=[sem sem2]';

%% single bar

x_label=[1 2 3 4 5 6 7 8 ];

% avg_auc, bar
fig = figure('Color', [1 1 1]);hold on;
h=bar(avg, 'BarWidth', 1);
set(h(1),'FaceColor',[ .5 .5 .5], 'EdgeColor',[ .5 .5 .5]);
set(h(2),'FaceColor',[ .5 .5 .5], 'EdgeColor', [ .5 .5 .5]);


% axis
set(gca,'XTick',1:length(x_label),'XTickLabel',x_label);
ylabel('Average area under curve', 'FontSize', 48, 'FontWeight','bold');
xlabel('Day', 'FontSize', 48, 'FontWeight','bold');
set(gca, 'FontWeight','bold','FontSize',36,...
    'LineWidth',4);
hold(gca,'all');
set(gca,'Ylim',[0 1400]);

%error bar
eb1=errorbar(avg,sem,'.');
set(eb1(1),'LineWidth',4, 'Color','black');
set(eb1(2),'LineWidth',4, 'Color','black');


