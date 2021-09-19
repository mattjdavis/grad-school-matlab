function [ output_args ] = plot_mvl_circle(on,cpos,cell )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% if cell fires in the same position same lap, the dot will not be visible
% in some sense this prevents the occupancy issue

figure;
hold on;

% constant 
center=[0,0]; % center cordinates
t=-pi:0.001:pi;
vl=length(t); % circle vector

 % read from data, have to add to data (can have zero radius)

% calculate lap at img frame at same time
le=find(diff(cpos)<0); %lap end
ls=[ 1 ;le+1];
ls(end)=[]; % lap start index

trans=on{cell};
ntrans=length(trans);

for i=1:ntrans
    e=find(ls <= trans(i));
    lti(i)=e(end)+1; %lap trans ind, add 1 to index for inner circle

end

nlaps=length(ls)+1;

z=linspace(0,1,nlaps); % to make radius of circle change
vc=linspace(1,vl,256); % vector cicle HACK


% plot laps and events on circle
for i=2:nlaps
r=z(i); % radius
x=r*cos(t)+center(1);
y=r*sin(t)+center(2);
plot(x,y,'k',...
    'LineWidth',1.1); %plot lap
    
    % loop through multiple transients/lap
    tl_ind=find(lti==i);
    if (tl_ind)
        for j=1:length(tl_ind)
            tpos=cpos(trans(tl_ind(j))); %transient positions
            %[~,ind] = min((vc-tpos).^2);
            ind=round(vc(tpos));
            scatter(x(ind),y(ind),80,[1 0 0],'filled');
            display(ind);
        end
    end

end

% axis
axis square;
set(gca,'DataAspectRatio',[1 1 1])

% turn off
ax1=gca;
yruler = ax1.YRuler;
yruler.Axle.Visible = 'off';
xruler = ax1.XRuler;
xruler.Axle.Visible = 'off';
set(gca,'XTickLabel','')
set(gca,'Xtick',[],'Ytick',[]);

end

