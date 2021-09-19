function [ output_args ] = plot_flouro(in,out,per_thresh)

%generate this with choice specific package
x_label=[1:10];


v2struct(out);
v2struct(in);

%[dim1,dim2,dim3]=size(F{1});  % HACK: flouro{1}

fig1h=figure; fig1=tight_subplot(5,4); %title('Temporal Max Sorted (sig Ca2+)');
fig2h=figure;fig2=tight_subplot(5,4); %title('AUC Sorted (sig Ca2+)');
fig3h=figure;fig3=tight_subplot(5,4); %title('Max Amplitude (sig Ca2+)');
fig4h=figure;fig4=tight_subplot(5,4); %title('Max Amplitude Index (sig Ca2+)');

num_column=length(F);

for i=1:num_column;
    set(fig1h);
    axes(fig1(i));
    imagesc(sorted_traces{i},[-10 100]);
    
    set(fig2h);
    axes(fig2(i));
    imagesc(auc_sort{i},[-10 150]);
    
    set(fig3h);
    axes(fig3(i));
    hist(max_amp{i},50);
    
    set(fig4h);
    axes(fig4(i));
    hist(max_amp_ind{i},1:60);
       
end
    
     
% freq_response, imagesc
figure; imagesc(freq_response);
title(sprintf('Frequency of response, t=%d',per_thresh));
set(gca,'XTick',1:num_column,'XTickLabel',x_label);

% freq hist
fig5h=figure;fig5=tight_subplot(5,4);
for i=1:length(day_choice)
    set(fig5h);
    axes(fig5(i));
    hist(freq_response(:,i),0:.05:1);
    [ro(i,:)]=hist(freq_response(:,i),0:.05:1);
    set(gca,'XTick',0:.2:1, 'XLim',0:1);
end

%frequency response, bar
[r,c]=find(freq_response);
cell_count=hist(c,1:num_column); %hack
figure;  bar(cell_count);
title(sprintf('Frequency of response, t=%d',per_thresh));
set(gca,'XTick',1:num_column,'XTickLabel',x_label);

% avg_auc, bar
figure;hold on;
bar(avg_auc,'w');
errorbar(1:num_column,avg_auc,sem_auc,'.');
set(gca,'XTick',1:num_column,'XTickLabel',x_label);
ylabel('Average area under curve', 'FontSize', 16);
xlabel('Day', 'FontSize', 16);
% 
% % num_active, bar
% figure;hold on;
% bar(num_active);
% set(gca,'XTick',1:num_column,'XTickLabel',x_label);
% ylabel('# of active traces', 'FontSize', 16);
% xlabel('Day', 'FontSize', 16);
% 

end

