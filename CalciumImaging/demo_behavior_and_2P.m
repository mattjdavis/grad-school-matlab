
%% single dataset, browse run data

day=1; % select day/session
B=datasets{day}.behavior;
R=datasets{day}.behavior.run;
D

%% PLOT: rpm + rpm_mask
figure; 
subplot(211); plot(R.rpm_ds); % rpm, downsampled to match imaging 
subplot(212); imagesc(~R.run_mask'); colormap hot; % binary run data, when a running bout is detected

%% PLOT: rpm + lick + reward

% fig
fig1=figure;
set(fig1,  'units', 'inches', 'Position', [1, 1, 10, 2]);
set(gca,'LooseInset',get(gca,'TightInset'))

% rpm 
plot(R.rpm_ds,'LineWidth',1.2,'Color',[.5 .5 .5]); 
set(gca, 'Xlim', [ 0 length(runn)]);
hold on;

% lick
y2=40; % position of lick marker, top
y1=y2-3; % position of lick marker, bottom
for i =1:B.lick_num
    x=B.lick_times(i);    
    line([x x],[y1 y2],'LineWidth',1,'LineStyle','-','Color',[0 0 0]);
end


% reward
y_vec1=ones(B.reward_num,1)*y1-1.5;
y_vec2=ones(B.mreward_num,1)*y1-1.5;
scatter(B.reward_times,y_vec1,'*','MarkerEdgeColor', [0 0 1]); % earned reward, blue marker 
scatter(B.mreward_times,y_vec2,'*','MarkerEdgeColor', [1 0 0]);% manual reward, red marker

% run off all axis marks
box off;
set(gca, 'XTick', []); set(gca, 'YTick', []);
set(gca, 'XColor', [1,1,1]); set(gca, 'YColor', [1,1,1]);

% set(gca,'Ylim',[0 30]); % set axis limit


