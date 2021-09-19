% cr no cr bar
out=process_flouro_data(in,data,0);

avg=out.avg_auc;
sem=out.sem_auc;

%%
in.vars=['noCr'];
nocr_out=process_flouro_data(in,data,0);


in.vars=['cr'];
cr_out=process_flouro_data(in,data,0);

avg_cr=cr_out.avg_auc;
avg_nocr=nocr_out.avg_auc;
sem_cr=cr_out.sem_auc;
sem_nocr=nocr_out.sem_auc;

%%
in.vars=['cs'];
nocr_out=process_flouro_data(in,data,0);


in.vars=['us'];
cr_out=process_flouro_data(in,data,0);

avg_cr=cr_out.avg_auc;
avg_nocr=nocr_out.avg_auc;
sem_cr=cr_out.sem_auc;
sem_nocr=nocr_out.sem_auc;

%%

learn_vec=[1:10];




%fig = figure('Color', [1 1 1]);hold on;

% axis
set(gca,'XTick',1:10,'XTickLabel',1:10);
ylabel('Average area under curve', 'FontSize', 48, 'FontWeight','bold');
xlabel('Day', 'FontSize', 48, 'FontWeight','bold');
set(gca, 'FontWeight','bold','FontSize',36,...
    'LineWidth',4);
hold(gca,'all');
set(gca,'Ylim',[0 1600]);




%colors
c2=[0.2941    0.5447    0.7494];
c1=[0.9047    0.1918    0.1988];

% pre
% plot (avg, 'Color', [ .5 .5 .5], 'LineWidth', 6);
% eb1=errorbar(avg,sem,'.');
% set(eb1(1),'LineWidth',4, 'Color',[ .5 .5 .5]);

%cr
plot (learn_vec,avg_cr, 'Color', c1, 'LineWidth', 6);
eb2=errorbar(learn_vec,avg_cr,sem_cr,'.');
set(eb2(1),'LineWidth',4, 'Color',c1);

%cr
plot (learn_vec,avg_nocr, 'Color', c2, 'LineWidth', 6);
eb3=errorbar(learn_vec,avg_nocr,sem_cr,'.');
set(eb3(1),'LineWidth',4, 'Color',c2);

legend
legend1 = legend(gca,{'All Trials', 'CR Trials' 'No CR Trials'});
set(legend1,'EdgeColor',[1 1 1], 'Location', 'NorthEastOutside',...
    'YColor',[1 1 1],...
    'XColor',[1 1 1]);




%% CS VS US
%in.vars=['cs' 'bb' 'run'];
in.vars=['cs'];
cs_out=process_flouro_data(in,data,0);
avg_cs=cs_out.avg_auc;
sem_cs=cs_out.sem_auc;

%in.vars=['us' 'bb' 'run'];
in.vars=['us']
us_out=process_flouro_data(in,data,0);
avg_us=us_out.avg_auc;
sem_us=us_out.sem_auc;




%%

learn_vec=[1:10];




fig = figure('Color', [1 1 1]);hold on;

% axis
set(gca,'XTick',1:10,'XTickLabel',1:10);
ylabel('Average area under curve', 'FontSize', 16, 'FontWeight','bold');
xlabel('Day', 'FontSize', 16, 'FontWeight','bold');
set(gca, 'FontWeight','bold','FontSize',12,...
    'LineWidth',2);
hold(gca,'all');
set(gca,'Ylim',[0 1600]);




%colors
us_c=[0.2941    0.5447    0.7494];
cs_c=[0.9047    0.1918    0.1988];

% pre
% plot (avg, 'Color', [ .5 .5 .5], 'LineWidth', 6);
% eb1=errorbar(avg,sem,'.');
% set(eb1(1),'LineWidth',4, 'Color',[ .5 .5 .5]);

%us
plot (learn_vec,avg_us, 'Color', us_c, 'LineWidth', 3);
eb2=errorbar(learn_vec,avg_us,sem_us,'.');
set(eb2(1),'LineWidth',2, 'Color',us_c);

%us
plot (learn_vec,avg_cs, 'Color', cs_c, 'LineWidth', 3);
eb3=errorbar(learn_vec,avg_cs,sem_cs,'.');
set(eb3(1),'LineWidth',2, 'Color',cs_c);

legend
legend1 = legend(gca,{'US trials','','CS trials'});
set(legend1,'EdgeColor',[1 1 1], 'Location', 'NorthWest',...
    'YColor',[1 1 1],...
    'XColor',[1 1 1]);



%
