
%25-64=41 frames, 25=0.0 30 40 50 60 
xrange=[25:2:65];

yA=[0 150];
%xA=[
figure;

fig1 = tight_subplot(1,2);

axes(fig1(1));
hist(tO,xrange)
ylim(yA);
set(gca,'XTick',[30 40 50 60],'XTickLabel',{'0.5','1.5','2.5','3.5'} )

axes(fig1(2));
hist(pO,xrange)
ylim(yA);
set(gca,'XTick',[30 40 50 60],'XTickLabel',{'0.5','1.5','2.5','3.5'} )


%%

%25-64=41 frames, 25=0.0 30 40 50 60 

t1='Tone'
t2='Puff'

xl='Time Post Stimulus (s)'
xrange=[25:2:65];
xAL={'0.5','1.5','2.5','3.5'};
xAT=[30 40 50 60];

yl='Count of Ca2+ Events';
yA=[0 135];


%xA=[
figure;
box off;


%1
subplot(1,2,1)
hist(tO,xrange)
ylim(yA);
set(gca,'XTick',xAT,'XTickLabel',xAL )
title(t1,...
    'FontName','Arial',...
    'FontSize',24 );

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

%2
subplot(1,2,2)
hist(pO,xrange)
ylim(yA);
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