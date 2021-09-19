%% import mat
% new way to import from mat files



%path='Y:\GsImaging\data\md138_r1_am_002_signals.mat'
%path='Y:\GsImaging\data\md138_d3_cno_001_signals'
%path='Y:\GsImaging\data\md138_d3_veh_001_signals'

%path='Y:\GqImg\data\md148_R2\md148_d1_cno_r2_002_signals'
path='Y:\GqImg\data\md148_R2\md148_d1_veh_r2_002_signals'

path='Y:\GqImg\data\md148_R3\md148_d1_cno_r3_00_signals'

imgHz=10.088781;

[ raw, labels, tags ] = import_sima_mat(path);
[num_frames, num_rois]=size(raw);






%% CONT: d/df
% Bl = median of whole trace

baseline=median(raw,1);
bl=repmat(baseline,size(raw,1),1);
dF=((raw-bl)./bl)*100;


%% BASELINE: check for abberrant values in baseline
figure;
hist(baseline);

%identify outlines
[v,ind]=sort(baseline); 

%% BASLINE: PLOT
figure;
plot(dF(:,65));

%% PLOT: Indidvidual traces

roi=6;

figure; hold on;
plot(dF(:,roi));
%plot(raw(:,roi));




%% CONT: PLOT 1


longF=reshape(dF,num_frames,num_rois); % dont need for cont


% plot: all F plot
figure;
plot(longF); axis('tight'), ylabel('F (au)')

%plot: all F imagesc
qmax=max(max(dF))/4;
figure;
colormap hot;
imagesc(dF',[0 qmax]);

figure;
plot(nansum(longF,2));



%% foopsi: one trace
V.dt =1/imgHz;
trace=double(longF(:,28));

[Nhat Phat V C ] = fast_oopsi(trace,V);


% thresh
N=Nhat>std(Nhat) * 8;

figure;
h(1)=subplot(411); plot(trace); axis('tight'), ylabel('F (au)')
h(2)=subplot(412); plot(C); axis('tight'), ylabel('C (au)')
h(3)=subplot(413); plot(Nhat); axis('tight'), ylabel('Nhat')
h(4)=subplot(414); plot(N); axis('tight'), ylabel('N')

%% multi trace
V.dt =1/imgHz;
N=false(num_frames,num_rois); %intialize spike matrix

for i=1:num_rois
    trace=double(longF(:,i));
    [Nhat]= fast_oopsi(trace,V);
    N(:,i)=Nhat>std(Nhat) * 5;
end

%% PSTH

N(1,find(N(1,:)))=0; % delete spikes from 1st row, seems to be artifact 

psth(find(N),imgHz*10,imgHz,num_rois,num_frames);



%% plot: firing rate estimates!
figure;
plot(sum(N,2));
%hist(sum(N,2));

%%
figure; 
colormap hot;
imagesc(N')


%% Population: isolate ca peaks

a=longF;
a(a <60)=NaN; % NaN is better than zeros, but doesn't work for sum, mean


figure; plot(a);
%figure;hist(reshape(a,1,numel(a)));
figure;imagesc(a',[0 100]); % produces a raster-like plot
%figure;plot(max(a,2));


peak_sum=nansum(a,2);



%% dumb for dumb rpm

%track 
for j=1:6
    %
    for i=1:8
        R(i,:)=RPM{i}{7,j};
    end

auc(j,:)=trapz(R');
end

figure;
%plot(auc(1:3,:)');
plot(mean(auc(1:3,:)));
%plot(auc');

