%% rpm_lick

%% Post change serial ouput, which happend with RPM lick 6


%%
% eb_arc_4
%path='X:\imaging\eb_arc_4_run\md185_11062016_FT4_2016_11_06_05_10_57_318.txt';
%path='X:\imaging\eb_arc_4_run\md186_11062016_FT4_2016_11_06_05_27_21_243.txt';
%path= 'X:\imaging\eb_arc_4_run\md187_11062016_FT4_2016_11_06_05_44_42_162.txt';

% eb_arc_4_run
path='X:\imaging\eb_arc_4_run\md186_11112016_FT3_2016_11_11_12_57_49_230.txt';
%path='X:\imaging\eb_arc_4_run\md187_11112016_FT3_2016_11_11_11_41_57_176.txt';

behavior=process_rpm_lick_LONGOUTPUT(path,6360);

%% img_DLX_1
%path='X:\imaging\Img DLX\run\md198_1130016_FT3_2016_11_30_12_24_40_259.txt';
%path='X:\imaging\Img DLX\run\md199_1130016_FT3_2016_11_30_12_41_02_105.txt';
%path='X:\imaging\Img DLX\run\md200_1130016_FT3_2016_11_30_01_11_09_474.txt';

path='X:\imaging\Img DLX\12012016\md198_12012016_FT3_2016_12_01_03_20_10_843.txt';
path='X:\imaging\eb_arc_5\12072016\md192_12072016_VT3-6_2016_12_07_04_37_23_182.txt'

behavior=process_rpm_lick(path,6000);

%% eb_arc_5 
%path='X:\imaging\eb_arc_5\md191_12012016_FT3_2016_12_01_07_34_27_363.txt';
%path='X:\imaging\eb_arc_5\md192_12012016_FT3_2016_12_01_06_56_20_349.txt';
%path='X:\imaging\eb_arc_5\md193_12012016_FT3_2016_12_01_07_11_26_808.txt';



behavior=process_rpm_lick(path,6000);

%%

path='X:\imaging\wheel run 2\md206_11232016_FT3_2016_11_23_01_56_15_309.txt'
behavior=process_rpm_lick_LONGOUTPUT(path,6360);

%% run + lick

v2struct(behavior);

%% PLOT: rpm + rpm_mask
figure; 
subplot(211); plot(run_single.rpm_ds); % rpm, downsampled to match imaging 
subplot(212); imagesc(~run_single.run_mask'); colormap hot; % binary run data, when a running bout is detected


%%
%figure
fig1=figure;
set(fig1,  'units', 'inches', 'Position', [1, 1, 10, 2]);
set(gca,'LooseInset',get(gca,'TightInset'))

% r6, not ds
runn=run.rpm_ds;

plot(runn,'LineWidth',1.2,'Color',[.5 .5 .5]); set(gca, 'Xlim', [ 0 length(runn)]);
hold on;

% LICK
%y2=max(run); 
y2=38; % position of lick marker, top
y1=y2-3; % position of lick marker, bottom
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
set(gca,'Ylim',[0 30]); % reasonable for rpm
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca, 'XColor', [1,1,1]);
set(gca, 'YColor', [1,1,1]);



%% This code is now in process_rpm_lick
% originally used to do direct analysis on behavior, without downsample

read=csvread(path); 


timestamp=read(:,1);
start=repmat(timestamp(1),size(read,1),1);
sampling_int=timestamp-start;
figure;hist(sampling_int);

position=read(:,3);
lap=floor(position./64);

lap_times=find(diff(lap)) + 1;
lap_num=length(lap_times);

reward=read(:,4);
reward_times=find(diff(reward)) + 1;
reward_num=length(reward_times);

mreward=read(:,5);
mreward_times=find(diff(mreward)) + 1;
mreward_num=length(mreward_times);

total_reward=mreward_num+reward_num;
all_reward_times=[ mreward_times;reward_times];

%lick - remove waterdrop artifacts. if long string of licks occurs when a
%drop is delivered
lick=read(:,6);


lick_times=find(diff(lick)) + 1;
lick_num=length(lick_times);

behavior=v2struct(run, timestamp, sampling_int,lap, lap_times,lap_num,reward, reward_times,...
    reward_num,mreward_times, mreward, mreward_num,total_reward,total_reward,...
    all_reward_times,lick,lick_times,lick_num);

