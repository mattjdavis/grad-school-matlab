


figure;
x=1:32;
y=ones(32,1);

plot(x,y,'LineWidth',2,'Color','black');
hold on;
c = colormap(copper(32));

for i=1:32
    plot([i i],[1 1.05],'LineWidth',3,'Color',c(i,:)');
end

set(gca,'YLim',[0 2]);
