%% tone possible plots

% 10 zones
%tones=2000:1000:11000;
%tones=tones(randperm(length(tones)));
%tones=2000:500:6500;

% 5 zones
tones=[1:5 0 0 0 0 0] *1e3;

% 20 zones
tones=2000:500:11500;

figure;
bar(tones);

set(gca,'YLim',[0 12000]);
set(gca,'FontSize',16,'FontWeight','bold');
xlabel('Zones','FontName','Arial','FontWeight','bold','FontSize',18 );
ylabel('Tone Frequency (hz)','FontName','Arial','FontWeight','bold','FontSize',18 );
box off;

set(gca,'XTick',0:5:20);


