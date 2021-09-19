%% i


in.vars=['noCr'];
nocr_out=process_flouro_data(in,data,0);


in.vars=['cr'];
cr_out=process_flouro_data(in,data,0);
%% lengths


in.vars=['run'];
cr_out=process_flouro_data(in,data,0);
l_cr=plot_lengths(cr_out.lengths,in.day_choice, 'no');

%mean(l_cre)=avg(

in.vars=['noRun'];
nocr_out=process_flouro_data(in,data,0);
l_nocr=plot_lengths(nocr_out.lengths,in.day_choice, 'no');


%%




in.vars=['cr'];
cr_out=process_flouro_data(in,data,0);

in.vars=['noCr'];
nocr_out=process_flouro_data(in,data,0);

var_names={'Avg_USnoRun' 'sem_USnoRun' 'Avg_USRun' 'sem_USRun' };


%%
% great code for figuring out error bars
c2=[0.2941    0.5447    0.7494];
c1=[0.9047    0.1918    0.1988];

avg=[cr_out.avg_auc; nocr_out.avg_auc]';
sem=[cr_out.sem_auc; nocr_out.sem_auc]';


x_label=[9:13];


% fig + bar
fig = figure('Color', [1 1 1]);hold on;
h=bar(avg, 'BarWidth', 1);
set(h(1),'FaceColor',c1, 'EdgeColor',c2);
set(h(2),'FaceColor',c2, 'EdgeColor', c2);

% axis
set(gca,'XTick',1:length(x_label),'XTickLabel',x_label);
ylabel('Average area under curve', 'FontSize', 16, 'FontWeight','bold');
xlabel('Day', 'FontSize', 16, 'FontWeight','bold');
set(gca, 'FontWeight','bold','FontSize',12,...
    'LineWidth',2);
hold(gca,'all');
set(gca,'Ylim',[0 1400]);



%error bars
a = get(get(h(1),'children'),'xdata');
b = get(get(h(2),'children'),'xdata');
a_err=mean([a(2,:);a(3,:)])';
b_err=mean([b(2,:);b(3,:)])';
eb1=errorbar([a_err b_err],avg,sem,'.');
set(eb1(1),'LineWidth',4, 'Color','black');
set(eb1(2),'LineWidth',4, 'Color', 'black');

% tables
T1=table(avg(:,1), sem(:,1), avg(:,2),sem(:,2),'RowNames',in.day_choice',...
    'VariableNames',var_names);
%could put number of cs and us running trials
T2=table(cr_out.num_trials', nocr_out.num_trials','RowNames',in.day_choice',...
    'VariableNames',{'Num_US_no', 'Num_US_Run'});
display(T2);
display(T1);



%% single

avg=[out.avg_auc; out.avg_auc]';
sem=[out.sem_auc; out.sem_auc]';


%% combined 
avg2=[cr_out.avg_auc; nocr_out.avg_auc];
sem2=[cr_out.sem_auc; nocr_out.sem_auc];

avg3=[avg avg2]';
sem3=[sem sem2]';

%% single type

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


