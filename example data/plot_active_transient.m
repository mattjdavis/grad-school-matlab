%% Grab active cell for example of threshold

% gabbed trace off day02, wheel, eb_arc_3; md170, r1, 10 (358:2117, broad, 1040:1160 zoom, 1:40 bl_
%load('exTraceEventFindingPlot.mat')
load('exTraceEventFindingPlot2.mat') % 'md174 r3 37'.0

% figure;plot(trace(2580:2660),'LineWidth',2);
% figure;plot(trace,'LineWidth',2);

oneEvent=trace(2600:2710); %added .05 to get to 0
% baseline ends 785, 2 frames before big jump

figure;plot(oneEvent,'LineWidth',2);hold on;

base=1:20;

bl=mean(oneEvent(base));
threshOn=std(oneEvent(base))*3;
threshOff=std(oneEvent(base))*.5;
cross1=bl+threshOn;
cross2=bl+threshOff;

plot(base, repmat(bl,1,length(base)), '.', 'LineWidth', 2);

scatter([21,22,23],repmat(cross1,1,3),'o','LineWidth',2);