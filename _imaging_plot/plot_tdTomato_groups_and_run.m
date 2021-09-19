%%
figure;plot(zscore(T),'r'); hold on; plot(tomatoNegDf,'b');
figure;plot(zscore(T),'r'); hold on; plot(tomatoPosDf,'b');

%%
figure;subplot(211);imagesc(dF',[0 .5]);
hold on;plot(mean(tomatoNegDf,2)*10,'LineWidth',1);
subplot(212);imagesc(tomatoNegDf',[0 1]); colormap hot;

figure;subplot(211);imagesc(dF',[0 .5]); 
hold on;plot(mean(tomatoPosDf,2)*10,'LineWidth',1);
subplot(212);imagesc(tomatoPosDf',[0 1]); colormap hot;