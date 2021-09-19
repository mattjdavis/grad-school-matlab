
normFactor=tRois(1)*40;;


%% LENGTHS
figure;
numberOfBins = 20;
yrange=[0 3.5];
xAT=[10 20 30 40 50];
xAL={'0.5','1.5','2.5','3.5', '4.5'};
xl='Length of Ca^{2+} Transient (s)';
yl='Frequency (percent)';
t1='Dim Light'
t2='Bright Light'



%
subplot(1,2,1);
[counts, binValues] = hist(len1, numberOfBins);
normalizedCounts = (counts/(normFactor))*100 ; % normalization, hack should be in terms  
bar(binValues, normalizedCounts, 'barwidth', 1);
ylim(yrange)
title(t1,...
    'FontName','Arial',...
    'FontSize',24 );
set(gca,'XTick',xAT,'XTickLabel',xAL )
set(gca,...
    'FontName','Arial',...
    'FontWeight','bold',...
    'FontSize',12 );
xlabel(xl,... 
    'FontName','Arial',...
    'FontWeight','bold',...
    'FontSize',18 );
ylabel(yl,...
    'FontName','Arial',...
    'FontWeight','bold',...
    'FontSize',18 );


axis square;




%
subplot(1,2,2);
[counts, binValues] = hist(len2, numberOfBins);
normalizedCounts = (counts/(normFactor))*100 ; % normalization, hack should be in terms  
bar(binValues, normalizedCounts, 'barwidth', 1);

ylim(yrange)
set(gca,'XTick',xAT,'XTickLabel',xAL )

title(t2,...
    'FontName','Arial',...
    'FontSize',24 );

xlabel(xl,...
    'FontName','Arial',...
    'FontWeight','bold',...
    'FontSize',18 );
set(gca,...
    'FontName','Arial',...
    'FontWeight','bold',...
    'FontSize',12 );

axis square;


%% ONSETS
data1=pO;
data2=tO;

figure;
numberOfBins = [25:2:65];
yrange=[0 2.5];
xAT=[30 40 50 60]; 
xAL={'0.5','1.5','2.5','3.5'};
xl='Time Post Stimulus (s)'
yl='Frequency (percent)';
t1='Dim Light'
t2='Bright Light'



%
subplot(1,2,1);
[counts, binValues] = hist(data1, numberOfBins);
normalizedCounts = (counts/(normFactor))*100 ; % normalization, hack should be in terms  
bar(binValues, normalizedCounts, 'barwidth', 1);
ylim(yrange)
title(t1,...
    'FontName','Arial',...
    'FontSize',24 );
set(gca,'XTick',xAT,'XTickLabel',xAL )
set(gca,...
    'FontName','Arial',...
    'FontWeight','bold',...
    'FontSize',12 );
xlabel(xl,... 
    'FontName','Arial',...
    'FontWeight','bold',...
    'FontSize',18 );
ylabel(yl,...
    'FontName','Arial',...
    'FontWeight','bold',...
    'FontSize',18 );


axis square;



%%
%
subplot(1,2,2);
[counts, binValues] = hist(data2, numberOfBins);
normalizedCounts = (counts/(normFactor))*100 ; % normalization, hack should be in terms  
bar(binValues, normalizedCounts, 'barwidth', 1);

ylim(yrange)
set(gca,'XTick',xAT,'XTickLabel',xAL )

title(t2,...
    'FontName','Arial',...
    'FontSize',24 );

xlabel(xl,...
    'FontName','Arial',...
    'FontWeight','bold',...
    'FontSize',18 );
set(gca,...
    'FontName','Arial',...
    'FontWeight','bold',...
    'FontSize',12 );

axis square;

