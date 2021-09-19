%paired and probe on top and shaded


in.vars=['noCr'];
nocr_out=process_flouro_data(in,data,0);


in.vars=['cr'];
cr_out=process_flouro_data(in,data,0);

out1=cr_out;
out2=nocr_out;

for i=1:1
    %figure;
    %plot(pr_out.active_traces{i},'r');hold on
    %plot(pa_out.active_traces{i},'b');
    
    
    avg_paired = mean(out1.active_traces{i},2);
    std_paired = std(out1.active_traces{i},0,2);
    avg_probe = mean(out2.active_traces{i},2);
    std_probe = std(out2.active_traces{i},0,2);
    
    %%CHANGES
avg_paired= avg_paired(11:45);
std_paired= std_paired(11:45);
avg_probe= avg_probe(11:45);
std_probe= std_probe(11:45);
%%
    
c1=[0.9047    0.1918    0.1988]
c2=[0.5 0.5 0.5];


    %PAIRED
    fig1 = figure('Color',[1 1 1]); 
    axes1 = axes('Parent',fig1,'ZColor',[1 1 1],'YColor',[1 1 1],...
    'XMinorTick','off',...
    'XColor',[1 1 1]);
    hold(axes1,'all');
    

    shadedErrorBar([],avg_paired,std_paired,{'r', 'LineWidth', 2});
    set(gca,'XMinorTick', 'on');
    ylim([-30 130]);
    
    yy=ylim(gca);
    line('XData', [15 15],'YData',yy-40, 'Color', c2, 'LineWidth',2, 'LineStyle', '--');
    line('XData', [12 12],'YData',yy-40, 'Color', c1, 'LineWidth',2, 'LineStyle', '-.');
    %addStimGraphics('paired')
    %add_ca_graphics(fig1);
    
    %hold on;
    
    % PROBE
    fig2 = figure('Color',[1 1 1]); 
    axes2 = axes('Parent',fig2,'ZColor',[1 1 1],'YColor',[1 1 1],...
    'XMinorTick','off',...
    'XColor',[1 1 1]);
    hold(axes2,'all');
    
    shadedErrorBar([],avg_probe,std_probe,{'b', 'LineWidth', 2});
    set(gca,'XMinorTick', 'on');
    ylim([-30 130]);
    
    yy=ylim(gca);
    line('XData', [15 15],'YData',yy-40, 'Color', c2, 'LineWidth',2, 'LineStyle', '--');
    line('XData', [12 12],'YData',yy-40, 'Color', c1, 'LineWidth',2, 'LineStyle', '-.');
    
    %add_ca_graphics(fig2);
    %addStimGraphics('paired')
    
    
    
end;







%%
% Day compressions
    
for i=0:2
    compressed_day_pa{i+1}= [pa_out.active_traces{1+i*1} pa_out.active_traces{2+i*2} pa_out.active_traces{3+i*3}]
end


    
for i=0:2
    compressed_day_pr{i+1}= [pr_out.active_traces{1+i*1} pr_out.active_traces{2+i*2} pr_out.active_traces{3+i*3}]
end


%%


for i=1:2
    %figure;
    %plot(pr_out.active_traces{i},'r');hold on
    %plot(pa_out.active_traces{i},'b');
    
    
    avg_paired = mean(compressed_day_pa{i},2);
    std_paired = std(compressed_day_pa{i},0,2);
    avg_probe = mean(compressed_day_pr{i},2);
    std_probe = std(compressed_day_pr{i},0,2);


%     fig1 = figure('Color',[1 1 1]); 
%     axes1 = axes('Parent',fig1,'ZColor',[1 1 1],'YColor',[1 1 1],...
%     'XMinorTick','off',...
%     'XColor',[1 1 1]);
%     hold(axes1,'all');
% 
% % 
% %     shadedErrorBar([],avg_paired,std_paired,{'b', 'LineWidth', 2});
% %     set(gca,'XMinorTick', 'on');
% %     ylim([-30 85]);
%     
%     hold on; 
%     %h2 = figure();
% %  
%     shadedErrorBar([],avg_probe,std_probe,{'r', 'LineWidth', 2});
%     set(gca,'XMinorTick', 'on');
%     ylim([-30 85])
%     
%     add_ca_graphics(fig1);
%     addStimGraphics('probe');

    %PAIRED
    fig1 = figure('Color',[1 1 1]); 
    axes1 = axes('Parent',fig1,'ZColor',[1 1 1],'YColor',[1 1 1],...
    'XMinorTick','off',...
    'XColor',[1 1 1]);
    hold(axes1,'all');
    

    shadedErrorBar([],avg_paired,std_paired,{'b', 'LineWidth', 2});
    set(gca,'XMinorTick', 'on');
    ylim([-20 80]);
    addStimGraphics('paired')
    add_ca_graphics(fig1);
    
    %hold on;
    
    % PROBE
    fig2 = figure('Color',[1 1 1]); 
    axes2 = axes('Parent',fig2,'ZColor',[1 1 1],'YColor',[1 1 1],...
    'XMinorTick','off',...
    'XColor',[1 1 1]);
    hold(axes2,'all');
    
    shadedErrorBar([],avg_probe,std_probe,{'r', 'LineWidth', 2});
    set(gca,'XMinorTick', 'on');
    ylim([-20 80]);
    
    add_ca_graphics(fig2);
    addStimGraphics('probe')


    
end;