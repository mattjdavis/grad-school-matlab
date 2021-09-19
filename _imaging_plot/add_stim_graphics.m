function [] = addStimGraphics(type)

if nargin <1
    type=['probe' 'paired'];
end

lim=axis; 
%xCS = [22.5;23;23;22.5];
%xUS = [25;25.5;25.5;25];

xCS = [22.5;23.5;23.5;22.5];
xUS = [24.5;25.5;25.5;24.5];
yboth = [ lim(3); lim(3); lim(4); lim(4)];
zboth = zeros(4,1);

set(gcf,'renderer','openGL');
if strfind(type,'probe')
    p1=patch(xCS,yboth, zboth,'facecolor','b','edgecolor','none','facealpha',0.2);

else if strfind(type,'paired')
    p1=patch(xCS,yboth, zboth,'facecolor','b','edgecolor','none','facealpha',0.2);
    p2=patch(xUS,yboth, zboth,'facecolor',[.8 .8 .8],'edgecolor','none','facealpha',0.75);
    else
    p1=patch(xCS,yboth, zboth,'facecolor','b','edgecolor','none','facealpha',0.2);
    p2=patch(xUS,yboth, zboth,'facecolor',[.8 .8 .8],'edgecolor','none','facealpha',0.75);
    
end

end

