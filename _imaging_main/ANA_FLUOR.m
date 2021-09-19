%%
% load recent dataset in particular path
% clear all;
% animal='md076';
% folder=sprintf('C:/data/ana_%s/',animal);
% mat_files = dir(fullfile(folder, '*.mat'));
% [tmp ind]=sort([mat_files.datenum],'descend');
% mat_files=mat_files(ind);
% dataset=load(sprintf('%s%s',folder,mat_files(1).name));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOTTING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% PLOT 1 - PERCENT/COUNT ACTIVE ROIS 

fig=figure; ax=gca;
hold on;
y_lim=[0 90];

fig1=figure; ax1=gca; hold(ax1,'on'); % percent
fig2=figure; ax2=gca; hold(ax2,'on'); % count


for i=1:length(GO)
    S=GO{i};
    h(i)=plot(ax1,S.active_percent,...
        'LineWidth',2);
    
    h(i)=plot(ax2,S.active_num,...
        'LineWidth',2);
    
    % for legend/axis
    ids{i} = S.description.name{1};
    day_label=S.description.day_label;
end


% axis
axes(ax1);
title('Signficant events across days',...
    'FontSize',20);
ylabel('Percent Signficant Events',...
    'FontSize',16);
xlabel('Days',...
    'FontSize',16);
set(gca,'XTick',1:length(day_label),'XTickLabel',day_label);
ax.FontWeight='bold';
ylim(y_lim);

% legend
if (length(GO) > 1)
    legend1 = legend(gca,ids);
    set(legend1,'EdgeColor',[1 1 1],'Location','NorthEast')
end


%% plot: AUC

fig1=figure; ax1=gca; hold(ax1,'on'); % mean_fig

for i=1:length(GO)
    
    % hist
    S=GO{i};    
    % mean
    h1(i)=plot(ax1,S.avg_auc,...
         'LineWidth',2);

    % for legend/axis
    ids{i} = S.description.name{1};
    day_label=S.description.day_label;
    
end

% legend
if (length(GO) > 1)
    legend1 = legend(gca,ids);
    set(legend1,'EdgeColor',[1 1 1],'Location','NorthEast')
end



%% PLOT 2 - STANDARD
out=output1;
plot_flouro(in,out,0);

%% plot II: onsets
out=output1;
display_frames=[1 60];
[onsets, first_onset,onsets_hist]=plot_onset(in,out,display_frames);

%% plot IIA: Onset pre and post learn

pre_learn_days=1:5;
post_learn_days=6:10;


pre_learn=sum(onsets_hist(pre_learn_days,:));
post_learn1= sum(onsets_hist(post_learn_days,:)); % Balanced to pre learn, including 1 pre CR day.
%post_learn2= sum(onsets_hist(6:13,:)); % All post learn days, including 1 pre CR day.

figure;
bar([pre_learn' post_learn1']);


%% plot III: lengths
%probably need to make this proportional

HIST_CHOICE='yes';
LONG_TRAN_THRESH=30;

fig1=figure; ax1=gca; hold(ax1,'on'); % mean_fig
fig2=figure; ax2=gca; hold(ax2,'on'); % long_transients count
fig3=figure; ax3=gca; hold(ax3,'on'); % long_transients percent

for i=1:length(grouped_output)
    
    % hist
    S=grouped_output{i};
    lengths=plot_lengths(S,in,HIST_CHOICE);
    
    % mean
    mean_lengths=cellfun(@mean, lengths);
    std_lengths=cellfun(@std, lengths);
    h1(i)=plot(ax1,mean_lengths,...
         'LineWidth',2);
    title('Mean Transient Length',...
        'FontSize',20);


    
    % long transients count
    long_tran_ind=cellfun(@(x) find(x > LONG_TRAN_THRESH), lengths, 'UniformOutput', false);
    num_long_tran=cellfun(@length, long_tran_ind);
    h2(i)=plot(ax2, num_long_tran,...
         'LineWidth',2);
    title('Number of Long Transients',...
        'FontSize',20);
     
    % long transients percent
    per_long_tran=(num_long_tran./S.num_total_traces)*100;
    h3(i)=plot(ax3, per_long_tran,...
         'LineWidth',2);
     title('Percent Long Transients',...
        'FontSize',20);
     
     
    
    
end



%% roi trial type breakdown
NUM_TOP_ROIS= 10; % number of active rois to take on graph. 


fig1=figure; h1=tight_subplot(1,length(grouped_output)); % event count 
fig2=figure; h2=tight_subplot(1,length(grouped_output)); % event count 

for i=1:length(grouped_output)
    
    S=grouped_output{i};
    day_label=S.description.day_label;
    
    
    
    % event count
    event_count=S.bin_count;
%     axes(h1(i));
%     imagesc(event_count,[0 15]);
%     
%     colormap hot;
%     if i > 1; set(h1(i),'YTickLabel',[]); end
%     title(S.description.name{1})
%     set(gca,'XTick',1:length(day_label),'XTickLabel',day_label);
    
   
    
    % event percent
    event_percent=event_count./repmat(S.num_trials,size(event_count,1),1);
    axes(h2(i));
    imagesc(event_percent,[0 .5]);
    
    colormap hot;
    if i > 1; set(h2(i),'YTickLabel',[]); end
    title(S.description.name{1})
    set(gca,'XTick',1:length(day_label),'XTickLabel',day_label);
    
    
    
    % THIS IS A DIRTY TRICK SO I CAN USE PERCENT BELOW
    event_count=event_percent;
    
    % sort event count
    [sum_event,ind]=sort(sum(event_count,2));
    sort_event_count=event_count(ind,:);
    roi_labels_sort=S.roi_labels(ind);

    
    % imagesc, event count all
    figure; imagesc(sort_event_count,[0 .5]);
    %imagesc, event count thresholded (freq response)
    figure; imagesc(S.freq_response(ind,:));

    % plot of number of rois with high reponse
    [a,b]=find(S.freq_response);
    [x,y]=hist(b,unique(b));
    %figure; plot(x);
    
    % save all event count with orginal indexes, so indx3 will work
    EC(:,:,i)=event_count; 
    
    % get up rois 
    top_active_rois(i,:)=roi_labels_sort(end-NUM_TOP_ROIS+1:end);

    % idx3 indexes top rois, for all outputs
    A=top_active_rois(i,:);
    B=S.roi_labels;
    [~,idx1]=intersect(B,A);
    [~,idx2] = sort(A);
    idx3(:,i)=idx1(idx2);
    
end


%%
output_num=1;

event_count_sum=sum(EC,2); % collapse across days
event_count_sum=permute(event_count_sum,[1 3 2]);

event_count_long=reshape(EC, size(EC,1)*size(EC,2),[]);


top_tec=event_count_sum(idx3(:,output_num),:);

figure; 
bar(1:NUM_TOP_ROIS,[top_tec(:,1) top_tec(:,2) top_tec(:,3)],'stack');

%%

X1=event_count_sum(:,1);
Y1=event_count_sum(:,2);

figure; scatter(X1, Y1);
lsline();

mdl_1 = fitlm(X1,Y1);


% individual days
X2=event_count_long(:,1);
Y2=event_count_long(:,2);

figure; scatter(X2, Y2, 'o', 'jitter','on', 'jitterAmount', 0.06);
lsline();

mdl_2 = fitlm(X2,Y2);

%% top rois

for i=1:length(gouped_output)
    
    ind=roi_labels_sort(i,end-NUM_TOP_ROIS+1:end);
    
    for j=1:length(grouped_output)
        total_event_count();


;
%% plot IV: thirds plots
out=output1;

thirds_plot(out.F,'roi');
thirds_plot(out.F,'trial');


%% plot V: individual cells

out=output1;

for j=1:length(in.cell_choice)
    roi=j;
    for i=1:length(in.day_choice)
        
        a=out.F{i}(:,:,roi);
        figure; imagesc(a',[0 75]);
        %figure; plot(a);
        
        % active traces
        %b=out.auc_sort{i};
        %b=out.F{i}(:,:,roi);
        %figure; imagesc(b',[1 75]);
        %figure; plot(b);
        
        
        %plot parameters
        set(gca,'FontWeight','bold',...
        'FontSize',16);
        set(gca,'XTick',10:10:60,'XTickLabel',1:6);
        xlabel('Seconds');
        ylabel('Trial');
     

        c1=[0.9 0.2 0.2]
        c2=[0.5 0.5 0.5];
        yy=ylim(gca);
        line('XData', [25 25],'YData',yy, 'Color', c2, 'LineWidth',3, 'LineStyle', '--');
        line('XData', [22 22],'YData',yy, 'Color', c1, 'LineWidth',3, 'LineStyle', '-.');
        
        
        
        
    end
end




%% plot: boxplot, two conditions

for i=1:2
    d1=output1.freq_response(:,i);
    d2=output2.freq_response(:,i)
    
    figure;boxplot([ ]);
end


%% plot: simple dayplot, active traces all one 

x=output1;

yy=50;

for i=1:7

    figure; plot(x.active_traces{i},'b')
    
    a=size(x.active_traces{i},2);
    y_shift=1:yy:a*yy; y_shift=repmat(y_shift,60,1);
    figure; plot(x.active_traces{i}+y_shift,'r');% shifted plot
    
end
%% plot: grouped
% 7.29.2015

min_num_traces=5;
grouping = 1; % 1 = trial, 2 = cell

for i=1:length(grouped_output)
    
    current_dataset=dataset_group{i};
    
    fig3=figure;
    
    for j=1:length(current_dataset.F)
        
        %plot active traces
        active=current_dataset.active_traces{j}';
        %figure; imagesc(active,[0 100]); % This is order by roi


        % calculate mean
        mean_active(i,:)=mean(active);


        % trace identity sort
        tr_id = current_dataset.trace_identity{j};
        
        [traces,ind]=sort(tr_id(:,grouping)); 
        active_by_trace=active(ind,:);
       % figure; imagesc(active_by_trace,[0 50]);


        %twa = traces with activity
        twa=unique(traces(:,1));
        for k=1:length(twa)
            a=find(traces ==twa(k));
            active_one_trial=active_by_trace(a,:);

            % sort them by peak
            [~,ind]=max(active_one_trial,[],2);
            [~,sort_vector]=sort(ind);
            active_one_trial=active_one_trial(sort_vector,:);



            if (size(active_one_trial,1) > min_num_traces)
                
                
                %make subplot for multiple days
%                 if (length(current_dataset.F) > 1)
%                      set(fig3);
%                      subplot(1,length(current_dataset.F),j);
%                 end
                    
                    
                figure; imagesc(active_one_trial, [0 75]);
                
                % plot params
                day_name=in.day_choice{j}; name=num2str(twa(k)); % name can be a trace, or roi; fix grouping above
                title(strcat('Day: ',day_name, ', ROI: ', name)); % ROI name is not correct.
                
                % plot text on rows
                  for ii=1:size(active_one_trial,1)
                      
                  end
                      
                  
            end
             
        end
    
        
    
    end
    
    
end

%good to count the number of trials that had any response
length(unique(tr_id(:,1)))


%% plot: quick run plots OLD
R=grouped_output.rpm;
figure; plot(cell2mat(R(8,:)))

%%

D=dataset{1,5}.md125;

days=fieldnames(D)


% intial vars
num_run=zeros(1,length(days));
num_pre=zeros(1,length(days));

for i=1:length(days)
    
    day=days{i};
    R=D.(day).rpm;
    TT=D.(day).trial_type;

    RE{i,:}=R.run_events; %may not need
    PE{i,:}=R.pt_run_events; %may not need
    
    A=find(RE{i,:});
    B=find(PE{i,:}); 
    
    % does run overlap with CR or no_cr?
    crRun(i)=length(intersect(TT.cr,A);
    noCrRun(i)=length(intersect(TT.no_cr,A);
    
    num_run(i)=length(A);
    num_pre(i)=length(B);
    
    


end


figure;
hold on;
plot(num_run);
plot(num_pre);

%% PLOT-CALCIUM RASTER

D=14;
fig1=figure; ax1=gca; hold(ax1,'on'); %

for i=1:D
    sum_ca=[];
    mean_ca=[];

    F=grouped_output{4}.F{i};

    [d1,d2,d3]=size(F);
    % F_long concatenates all trials together.
    F_long=reshape(F,d1*d2,d3)';

    %figure; imagesc(F_long, [0 50]);

    sum_ca(i,:)=sum(F_long,1);
    mean_ca(i,:)=sum_ca(i,:)/d3;
    plot(ax1,mean_ca(i,:) + (i*100),'b');
    %plot(ax1,rpm_all_days(i,:) + (i*100),'r');
end

% 
% figure; imagesc(mean_ca,[0 20]);
% figure;imagesc(cumsum(mean_ca,2));
% figure;plot(cumsum(mean_ca,2)');



% % normalized to max, note that this is direct data, and have not gotten rid
% % of inactive cells.
% % makes noisy data, especially in inactive cells
% maxf=max(F_long');
% norm_F=F_long./repmat(maxf,size(F_long,2),1)';
% figure; imagesc(norm_F);


%% RUN, all trials

for i=1:length(in.day_choice)
    day=in.day_choice{i};
    rpm_cell=dataset.(in.animal).(day).rpm;
    R=cell2mat(rpm_cell(8,:));
    R=R(:)';

    rpm_all_days(i,:)=R;

end


%% 




%% plot: grouped
% 7.29.2015

%dataset_group={output1, output2};
dataset_group={output1}
min_num_traces=5;

grouping = 2; % 1 = trial, 2 = cell
HIST_CHOICE=1; % 1 = plot all

for i=1:length(dataset_group)
    
    current_dataset=dataset_group{i};
    num_days=length(current_dataset.F); %CHANGED
    %num_days=2;
    for j=1:num_days
        fig(j)=figure;
        
        active=current_dataset.active_traces{j}';

        % trace identity sort
        tr_id = current_dataset.active_trace_id{j};   
        [traces,ind]=sort(tr_id(:,grouping));
        active_by_trace=active(ind,:);
        tr_id_sort=tr_id(ind,:);
        
        if(HIST_CHOICE == 1)
            figure; imagesc(active_by_trace,[0 50]);
        end

        %twa = traces with activity
        twa=unique(traces(:,1));
        for k=1:length(twa)
            a=find(traces ==twa(k));
            active_one_trial=active_by_trace(a,:);
            tr_id_sort2=tr_id_sort(a,:);
            
            % sort them by peak
            [~,ind]=max(active_one_trial,[],2);
            [~,sort_vector]=sort(ind);
            active_one_trial=active_one_trial(sort_vector,:);
            tr_id_sort2=tr_id_sort2(sort_vector,:);


            if (size(active_one_trial,1) >= min_num_traces)
                
                
                % make subplot for multiple days, or new plot for single
                if (num_days >= 12)
                     set(fig(j));
                     subplot(1,5,5);
                     imagesc(active_one_trial, [0 75]);
                else
                    figure; imagesc(active_one_trial, [0 75]);
                    %figure; plot(active_one_trial');
                end
                    
                
                % plot params
                switch grouping
                    case 1
                        name='Trace'
                        row_names=tr_id_sort2(:,2); %cells are row names here
                    case 2
                        name='Cell'
                        row_names=tr_id_sort2(:,1); % trace is row names
                end
         

                day_name=in.day_choice{j}; num=num2str(twa(k)); % name can be a trace, or roi; fix grouping above
                title(strcat('Day: ',day_name, ', ', name, ': ', num)); % ROI name is not correct.
                
                % plot text on rows
                  for ii=1:size(active_one_trial,1)
                      h=text(5,ii,num2str(row_names(ii)));
                      h.Color='White', h.FontWeight='bold';
                      
           
                      
                  end
                      
                  
            end
             
        end
    
        
    
    end
    
    
end


%% cells per trial

dataset_group={output1, output2};
%dataset_group={output};
min_num_traces=5;
sequence_num=[]; mean_active_per_trial=[];


for i=1:length(dataset_group)
    current_dataset=dataset_group{i}; 
    for j=1:length(current_dataset.F)
       
       if ~isempty(current_dataset.active_trace_id{j})
           
       x=current_dataset.active_trace_id{j}(:,1);
       [a,b]=hist(x,unique(x))
       %figure; hist(a);
    
       %num_active_per_trial(j,i)=sum(a);
       mean_active_per_trial(j,i)=mean(a);
       
       % number greater than
       sequence_num(j,i)=length(find(a>=min_num_traces));
       
       % potential number of trials
       tt(j,i)=length(current_dataset.selected_trials{j});
       
       end
       
    end
   
    
end

%figure; plot(num_active_per_trial);
figure; plot(mean_active_per_trial);
title('Mean # Active Cells Per Day')
ylim([0 14]);
ylabel('Num Active Cells (mean)')
xlabel('Days');

% legend
 ids={'Run', 'No Run'};
 legend1 = legend(gca,ids);
 set(legend1,'EdgeColor',[1 1 1],'Location','NorthEast')


figure; plot(sequence_num);
title('Number of Trials with Sequences ')
ylabel('# of Sequence Per Trial')
xlabel('Days');


%% combine all active traces from multiple days



for i=1:length(grouped_output)
    current_dataset=grouped_output{i}; 
    all_traces=[];
    
    c=current_dataset.active_traces;
    %c=current_dataset.F;
    for j=1:length(c)
        all_traces= [ all_traces cell2mat(c(j))];
    end
    
    
    figure; imagesc(all_traces',[0 70])
    
    % avg
    mean_all(i,:)=mean(all_traces,2);
end
        


% plot avg
figure;
plot(mean_all');



% day=pooled, cell=summed - separate by type

GO=GGO(2,:);

unique vars
mean_all=[];


for i=1:length(GO)
    current_dataset=GO{i}; 
    all_traces=[];
    
    D=current_dataset.F;
    for j=1:length(D)
        
        if ~isempty(D{j})
            all_traces= [ all_traces sum(D{j},3)];
        end
    end
    
    
    figure; imagesc(all_traces',[0 200])
    
    % avg
    %mean_all(i,:)=mean(all_traces(:,1:100),2);
    mean_all(i,:)=mean(all_traces,2);
end 

% plot avg
figure;
%plot(mean_all(:,10:end)'); % remove 1st 10 frames
plot(mean_all'); ylim([-40 140]);