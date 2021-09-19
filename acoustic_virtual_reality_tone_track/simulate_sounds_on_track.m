


% *************************************************************************
%  LOAD DATA
% *************************************************************************
%% load data
file='X:\\imaging\\wheel_run_3\\probe\\md216_02012017_gamma1_2017_02_01_04_06_59_616.txt'; % last day, wheel run 3, probe 3
fid = fopen(file);
READ=textscan(fid,'','delimiter',',','headerlines',1);

fclose(fid);

%
lap_length=256;

position_total=READ{3};
pos=position_total(5001:15000); % grab good section
pos=mod(pos,lap_length); % turn into pos in lap
pos(find(pos==0))=256; % fix mod
%pos=pos-(pos(1)-1); % start at 1
pos(1:886)=[];
pos(2874:end)=[];

rpm=READ{2}; rpm=rpm(5001:15000); rpm(1:886)=[];rpm(2874:end)=[];
[indR]=find(rpm>60 | rpm<0);
rpm(indR)=0;

w=20;
 k = ones(1, w) / w;
 f_rpm = conv(rpm, k, 'same');
 figure;plot(f_rpm);

%%
% *************************************************************************
% SPACE BEEPS
% *************************************************************************

% tone parameters
amp=5; 
fs=40000;  % sampling frequency
duration=.05; % beep duration.
t=0:1/fs:duration;

% track parameters
lap_length=256;
bf=64; % beep freq
s_freq=300;
e_freq=2860;


% set tone frequencies
beep_positions=bf:bf:lap_length;

freqs=linspace(s_freq,e_freq,length(beep_positions));
%step=25;
%e_freq=s_freq+step*(length(beep_positions)-1);
%freqs=s_freq:step:e_freq;

% position transition check
d_pos=[0; diff(pos)]; 

% *************************************************************************
% PLOTTING
figure; 


% SUBPLOT 1
ax1=subplot(211);
ax1.XLim=[0 length(pos)];

hold on;
x=1:length(pos);
plot(pos,'LineWidth',3);
ylabel('Position on Track','FontSize',16);

% marker on track
p = plot(x(1),pos(1),'o','MarkerFaceColor','red');

% beep lines
xl=get(gca,'XLim');
for i=1:length(beep_positions)
    y=beep_positions(i);
    line('XData', xl, 'YData', [y y], 'LineStyle', '-', ...
        'LineWidth', 1, 'Color',[.8 .8 .8])
end

hold off;

% subplot 2
ax2=subplot(212);
h = animatedline;
axis([0,length(pos),0,30])
%plot(f_rpm);






% *************************************************************************
% ANIMATE
UPDATE_FS=15; %ms 
% animate and play sound
for i =1:length(pos)
    
    %set current position
    current_pos=pos(i);
    
    % determine which sound to play, based on position
    [~,ind]=intersect(beep_positions,current_pos);
    if(ind>0 & d_pos(i)==1)
        freq=freqs(ind);
         a=amp*sin(2*pi* freq*t);
         sound(a,fs);
         %display('hit');
           
    end
    
    %animate marker
    p.XData = x(i);
    p.YData = current_pos;
    
    
    % animate rpm
    addpoints(h,x(i),f_rpm(i));
    drawnow limitrate
    
    pause(UPDATE_FS/1000); %, % update datashould go before or after?
end

drawnow


%%
% *************************************************************************
% TIME BEEPS
% *************************************************************************

UPDATE_FS=15; % ms

% tone parameters
amp=5; 
fs=40000;  % sampling frequency
duration=.05; % beep duration.
t=0:1/fs:duration;

% track parameters
lap_length=256;
bf=1; % beep freq
s_freq=450;
step=10;

% time beeps parameters
beep_fs=10; % hz 4.44, 8.88, 2.22;
fr=round((1000/UPDATE_FS)/beep_fs);
beep_ind=1:fr:length(pos);
beeps=zeros(length(pos),1);
beeps(beep_ind)=1;

% set tone frequencies
beep_positions=bf:bf:lap_length;
e_freq=s_freq+step*(length(beep_positions)-1);
freqs=s_freq:step:e_freq;

% position transition check
d_pos=[0; diff(pos)]; 




% *************************************************************************
% PLOTTING

figure; 
% SUBPLOT 1
ax1=subplot(211);
ax1.XLim=[0 length(pos)];
ax1.YLim=[0 lap_length];
ylabel('Tone Frequency \n (hz)','FontSize',16);

hold on;
x=1:length(pos);


% beep lines
xl=get(gca,'XLim');
yl=get(gca,'YLim');
% for i=1:length(beep_positions)
%     y=beep_positions(i);
%     line('XData', xl, 'YData', [y y], 'LineStyle', '-', ...
%         'LineWidth', 1, 'Color','b')
% end


% x patches

% cb=[0 beep_positions]; %color beeps
% colors=jet(length(cb));
% x_coor = [ xl(1); xl(1); xl(2);xl(2)];
% zboth = zeros(4,1);
% for i=1:length(cb)-1
%     y_coor=[ cb(i); cb(i+1); cb(i+1); cb(i)];
%     p1=patch(x_coor,y_coor,zboth,'facecolor',colors(i,:),'edgecolor','none','facealpha',0.4);
% 
% end


% y lines
for i=1:length(beep_ind)
    x2=beep_ind(i);
    line('XData', [ x2 x2], 'YData', yl, 'LineStyle', '-', ...
        'LineWidth', 1, 'Color',[.8  .8 .8]);
        %'LineWidth', 1, 'Color',[.8 .8 .8
    
end

% position
plot(pos,'LineWidth',3);

% marker 
p = plot(x(1),pos(1),'o','MarkerFaceColor','red');


hold off;
% subplot 2
ax2=subplot(212);
ylabel('Speed (RPM)','FontSize',16);
h = animatedline;
axis([0,length(pos),0,30])
%plot(f_rpm);



% *************************************************************************
% ANIMATE
UPDATE_FS=15; %ms 
% animate and play sound

beep_positions(end)=[]; % now this holds the start of beep zones

%sound_all=zeros;
for i =1:length(pos)
    tic
    %set current position
    current_pos=pos(i);
    
    % determine which sound to play, based on position
    [~,ind]=intersect(beep_positions,current_pos);
    
    %set initial
    if (i==1)
    freq=freqs(1);
    a=amp*sin(2*pi* freq*t);
    end
    
    % change freq at zone transition
    if(ind>0 & d_pos(i)==1)
        freq=freqs(ind+1);
         a=amp*sin(2*pi* freq*t);
         
         %display('hit');
           
    elseif (current_pos < beep_positions(1))
            freq=freqs(1);
            a=amp*sin(2*pi* freq*t);
            sound_all(i,:)=a;
        end
         
    
    % play beep at fixed time
    if (beeps(i)==1)
        sound(a,fs);
    end
        
    
    %animate marker
    p.XData = x(i);
    p.YData = current_pos;
    
    
    % animate rpm
    addpoints(h,x(i),f_rpm(i));
    drawnow limitrate
    
    pause(UPDATE_FS/1000); %, % update datashould go before or after?
    display(toc*1000)
end
    drawnow


%%
% *************************************************************************
% FIXED RPM BEEPS
% *************************************************************************
% set tone parameters
amp=5; 
fs=20000;  % sampling frequency
duration=.05; % sec
t=0:1/fs:duration;

% set tone frequencies
freqs=450:50:2000;
freqs= [ freqs fliplr(freqs)];


for i =1:length(freqs)
    
freq=freqs(i);
a=amp*sin(2*pi* freq*t);
sound(a,fs);
pause(0.5);
end


