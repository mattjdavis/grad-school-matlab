function [ len_out ] = plot_lengths(out,in,plot)


x_vec=1:42; %HACK

lengths=out.lengths;
day_choice=in.day_choice;

for i=1:length(day_choice) 
    len=lengths{i};
    len=len(:);
    [len_ind,~]=find(len);
    len=len(len_ind);
    %for hist
    len_out{i}=len;
   %for hist
    y=hist(len,x_vec);
    len_num(i)=max(y);

end


if strcmp(plot,'yes')
    
    
    % still working on axis
    y_ax=zeros(5,4);y_ax(:,1)=1; y_ax=y_ax';%y_ax=reshape(y_ax,5*4,[],1); 
    x_ax=zeros(5,4);x_ax(end,:)=1; x_ax=x_ax';

    figh=figure; set(figh, 'units', 'inches', 'pos', [0 0 8 8])
    fig=tight_subplot(5,4);    
    
    

    for i=1:length(day_choice) 
     % PLOT: onsets, hist
        axes(fig(i));

        %still working on axis
        hist(len_out{i},x_vec); 
        h = findobj(gca,'Type','patch');
        set(h,'FaceColor',[0 0 0]);    
        xlim([0 length(x_vec)]);

        % text (as title)
        text(.5,0.9,...
            sprintf('Day: %s', day_choice{i}),...
            'FontWeight','bold',...
            'HorizontalAlignment','center',...
            'Units','normalized');

    end
    
    
    % readust y-axis limits now that max is known.
    ymax=max(len_num)+10;
    for i=1:length(day_choice) 
        set(fig(i),'Ylim',[0 ymax]);

        % still working on axis
        %if (x_ax(i)==0); display(i);set(gca,'XTick',[],'XTickLabel',{}); end
        %if (y_ax(i)==0); set(gca,'YTick',[],'YTickLabel',{}); end
    end    
    
end





end