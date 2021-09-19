 function  barWithData( data,A,mdata,semData)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

% data: cell array with individual data files columns is each bar, row if
% want a grouped bar graph.

if ~iscell(data);lol=7;end % need to put into cell for the rest

if (nargin < 3); mdata=cellfun(@mean,data)'; end;
if (nargin < 4); semData=cellfun(@std,data)./sqrt(cellfun(@numel,data)); end;




%% PLOTTING
figure;

bar_color=[0 .44 .74];

hold on;
% Bar properties
bar(mdata, 'LineWidth',3,'FaceColor',[1 1 1],'EdgeColor',bar_color);


% Error bars
errorbar(mdata,semData,'.','Color', bar_color, 'LineWidth',2,'MarkerSize',2);


% Plot markers

for ii=1:size(data,1)
    temp=data{ii};   
    x = repmat(ii,1,length(temp)); %the x axis location
    x = x+(rand(size(x))-0.5)*0.25; % x jitter
    
    %temp = temp + (rand(size(temp)))*0.1; % y random

    % marker properties
    plot(x,temp,'MarkerSize',6,'Marker','o','LineWidth',1.5,'LineStyle','none',...
        'Color',bar_color);
end
hold off




set(gca,'FontName','Arial','FontWeight','bold','FontSize',16 );
xlabel(A.xAL,'FontName','Arial','FontWeight','bold','FontSize',22 );
ylabel(A.yAL,'FontName','Arial','FontWeight','bold','FontSize',22 );


% axes
if (~isempty(A.yT)); set(gca, 'YTick',A.yT);end
if (~isempty(A.yTL));set(gca,'YTickLabel',A.yTL);end
if (~isempty(A.yLim));set(gca,'YLim',A.yLim);end


if (~isempty(A.xT)); set(gca,'XTick',A.xT); end
if (~isempty(A.xTL));set(gca,'XTickLabel',A.xTL);end

set(gca,'LineWidth',3);
% set bottom of axis on top
set(gca ,'Layer', 'Top')
end

