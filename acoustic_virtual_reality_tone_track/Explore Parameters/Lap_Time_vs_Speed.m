%% rpm and speed

lap_length=256; % squares
rot_squares=64; % rotation_squares
rot_cm=48; %cm, 48cm x 4
lap_cm=192;

% speed
rpm=1:2:50;
cmps= rot_cm/60;%cmps m, 
cm=rpm*cmps;

t_lap=repmat(lap_cm,length(cm),1)'./cm; % time per lap


% cmps
figure;plot(cm, t_lap,'LineWidth',2);
xlabel('Speed (cm/s)');
ylabel('Lap time (s)');
title('192 cm lap');
set(gca,'XLim',[4 max(cm)]);

% 
figure;plot(rpm, t_lap,'LineWidth',2);
xlabel('Speed (rpm)');
ylabel('Lap time (s)');
title('192 cm lap');

set(gca,'XLim',[4 max(rpm)]);







 