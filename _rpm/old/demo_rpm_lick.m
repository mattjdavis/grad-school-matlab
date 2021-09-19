%% rpm_lick


%
%1=timestamp
%2=rpm
%3=transitionCounter
%4=lapCounter
%5=rewardCounter
%6=manualRewardCountre
%7=lick
%8=ledState
%9=runState

%%
%path='X:\imaging\eb_arc_4_run\md185_11062016_FT4_2016_11_06_05_10_57_318.txt';
%path='X:\imaging\eb_arc_4_run\md186_11062016_FT4_2016_11_06_05_27_21_243.txt';
%path= 'X:\imaging\eb_arc_4_run\md187_11062016_FT4_2016_11_06_05_44_42_162.txt';

% eb_arc_4_run
path='X:\imaging\eb_arc_4_run\md186_11112016_FT3_2016_11_11_12_57_49_230.txt';
%path='X:\imaging\eb_arc_4_run\md187_11112016_FT3_2016_11_11_11_41_57_176.txt';

%%
path='X:\imaging\Img DLX\run\md198_1130016_FT3_2016_11_30_12_24_40_259.txt';
%path='X:\imaging\Img DLX\run\md200_1130016_FT3_2016_11_30_01_11_09_474.txt';

run=process_rpm_lick(path);

%% plot - run + run_epochs
figure; subplot(211); plot(run.rpm_ds); set(gca, 'Xlim', [ 0 length(run.rpm_ds)]); subplot(212); imagesc(run.run_mask');


%% GET READ FROM DEBUG 

read=csvread(path); % HACK!!!!!!!!

a=[0; read(:,1)];
b=[read(:,1); 0];
sampling_int=b-a; sampling_int(1)=[];sampling_int(end)=[];
figure;hist(sampling_int);

time_vector=read(:,1);

lap_vector=read(:,4);
lap_times=find(diff(lap_vector)) + 1;
lap_num=length(lap_times);

reward_vector=read(:,5);
reward_times=find(diff(reward_vector)) + 1;
reward_num=length(reward_times);

mreward_vector=read(:,6);
mreward_times=find(diff(mreward_vector)) + 1;
mreward_num=length(mreward_times);

total_reward=mreward_num+reward_num;
all_reward_times=[ mreward_times;reward_times];

%lick - remove waterdrop artifacts. if long string of licks occurs when a
%drop is delivered
lick_vector=read(:,7);


lick_times=find(diff(lick_vector)) + 1;
lick_num=length(lick_times);

behavior=v2struct(run, time_vector, sampling_int,lap_vector, lap_times,lap_num,reward_vector, reward_times,...
    reward_num,mreward_times, mreward_vector, mreward_num,total_reward,total_reward,...
    all_reward_times,lick_vector,lick_times,lick_num);

%% run + lick

%figure
fig1=figure;
set(fig1,  'units', 'inches', 'Position', [1, 1, 10, 2]);
set(gca,'LooseInset',get(gca,'TightInset'))

% r6, not ds
runn=behavior.run.rpm_filt;

plot(runn,'LineWidth',1.2,'Color',[.5 .5 .5]); set(gca, 'Xlim', [ 0 length(runn)]);
hold on;

% LICK
%y2=max(run); 
y2=38;
y1=y2-3;
for i =1:lick_num
    x=lick_times(i);    
    line([x x],[y1 y2],'LineWidth',1,'LineStyle','-','Color',[0 0 0]);
end



% REWARD 
y_vec1=ones(reward_num,1)*y1-1.5;
y_vec2=ones(mreward_num,1)*y1-1.5;

scatter(reward_times,y_vec1,'*','MarkerEdgeColor', [0 0 1]);
scatter(mreward_times,y_vec2,'*','MarkerEdgeColor', [1 0 0]);


box off;
set(gca,'Ylim',[0 40]); % reasonable for rpm
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca, 'XColor', [1,1,1]);
set(gca, 'YColor', [1,1,1]);





