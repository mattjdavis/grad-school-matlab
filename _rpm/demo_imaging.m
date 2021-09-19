%% WITH IMG


imgFlag=1;
imgPath='X:\\imaging\\eb_arc_4\\10242016\\';
rpmPath='X:\\imaging\\eb_arc_4\\10242016\\rpm\\';

r=processRPM(rpmPath,imgFlag,imgPath);



%% Plot

X=1;
figure; subplot(211); plot(r{7,X}); subplot(212); imagesc(r{8,X}.runMask');

%%
run_hack=read(:,1);


% got beahvior time from timestamp on actual file from processing
% before calcualted it manually: 
% zz=linspace(1/RPM_SR,nFrames/10,nFrames*2);
imaging_time=linspace(1/IMG_SR,realImgTime,nFrames)*1000;
start=repmat(read(1,1),length(read(:,1)),1);
timestamp=read(:,1)-start;
%timestamp=linspace(1/RPM_SR,nFrames/10,nFrames*2)*1000;
behavior_time=zeros(1,length(imaging_time));
 for i=1:length(imaging_time)
     [~, idx] = min(abs(timestamp-imaging_time(i)));
     behavior_time(i)=idx;
 end