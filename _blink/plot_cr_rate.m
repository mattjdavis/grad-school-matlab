

c=colormap(cool(4));
figure; 

control=zeros(13,1);

h=plot([ cr_percent control control],...,
    'MarkerSize',10,'Marker','square','LineWidth',3);


for i=1:4; h(i).Color=c(i,:); end

set(gca,'FontSize',14,'FontWeight','bold');
xlabel(gca,'Days','FontName','Arial','FontWeight','bold','FontSize',16 );
ylabel(gca,'Conditioned response (%)','FontName','Arial','FontWeight','bold','FontSize',16 );
%set(gca,'XTick',,'XTickLabel',1:1:length(day_names));
%title('');

box off;

%legend
legend({'TEC1', 'TEC2', 'Control', 'Control'},'Box','off','Location','northwest')