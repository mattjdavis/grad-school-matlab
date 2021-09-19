%%

out=output1;

%% Plot: all trial, all rois

day=1;
M=output1.F{day};

%sort with rois adjacent
M1=reshape(M,60,[])';
figure;
colormap('hot');
imagesc(M1,[0 200]);

%sort with trials adjacent
M2=permute(M, [1 3 2]);
M2=reshape(M2,60,[])';
figure;
colormap('hot');
imagesc(M2,[0 200]);



%% double check rearrange above is good
% M1 and M2 are equal, which should be the case
% very clear that the first frame has value that are way higher than the
% rest; probably should not use for the baseline; why is the first frame
% consistenly higher?

figure; 
subplot(2,1,1);
hold on; 
plot(mean(M2)); plot(mean(M1));

subplot(2,1,2);
hold on; 
plot(median(M2)); plot(median(M1));

%% is every trace have high 1st pixels?

MM=mean(M,2);
MM=permute(MM,[1 3 2])';

figure;
imagesc(MM,[0 15]);


%% distribution of pixel values
figure;
subplot(4,1,1);hist(M1(:,1),30); set(gca,'XLim',[-80 80]);
subplot(4,1,2);hist(M1(:,2),30); set(gca,'XLim',[-80 80]);
subplot(4,1,3);hist(M1(:,3),30); set(gca,'XLim',[-80 80]);
subplot(4,1,4);hist(M1(:,4),30); set(gca,'XLim',[-80 80]);

