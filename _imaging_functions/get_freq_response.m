function [out] = get_freq_response(animal_struct,days,thresh,per_thresh)
%multi_var={'noRun blank', 'noRun cs', 'noRun us', 'noRun dac2' 'run'};
%x= {'blank', 'light', 'puff', 'tone', 'run' 'paired' 'probe'};
x= {'light', 'puff', 'tone'};
multi_var={'noRun cs', 'noRun us', 'noRun dac2'};

      
animal=varname(animal_struct);
id=struct(animal,animal_struct);
%for i=1:length(animals)

% JUNK
  roi=fields(id.(animal).d01); r2=strfind(roi,'roi'); %should be the latest added roi, not gauranteed!
    aa=find(~cellfun(@isempty,r2)); roi=roi{aa};
  [~,~,f3]= size(id.(animal).d01.(roi).Data);
  
  light=zeros(f3,2);
  puff=zeros(f3,2);
  tone=zeros(f3,2);
  
    
    

    
    for j=1:length(days)
    %animal=animals{i}
    day=days{j};
    roi=fields(id.(animal).(day)); r2=strfind(roi,'roi'); %should be the latest added roi, not gauranteed!
    aa=find(~cellfun(@isempty,r2)); roi=roi{aa};

    F=id.(animal).(day).(roi).Data;
    [~,~,f3]= size(id.(animal).(day).(roi).Data);
    
    bin_count=zeros(f3, length(multi_var));
    for i=1:length(multi_var)
        keep=TrialSelector(id,day,animal,multi_var{i});
        flouro{1}=F(:,keep,:);          
        [f1,f2,f3]=size(flouro{1});

        % get avg bl
        no=std(flouro{1}(id.(animal).V.BaselineFrames,:,:),1);
        bl{1}=reshape(no,f2,f3,[]);

        % threshold crossings
        onsets=findOnset(flouro{1},bl{1}*thresh);
        [~,c]=find(~cellfun(@isempty,onsets));
        active_count{:,i}= c;
        bin_count(:,i)=hist(active_count{i},1:f3);
        num_trials(:,i)=f2;



    end

    freq_response=bin_count./repmat(num_trials,f3,1);


    %find to clean up
    a=find(freq_response<per_thresh);
    freq_response(a)=0;

    
%      
%     figure;
%     imagesc(freq_response);
%     %set(gca,'XTick',.5:1:4.5,'XGrid','on');
%     set(gca,'XTick',1:length(multi_var),'XTickLabel',x);
    
    %
    light(:,j)=freq_response(:,1);
    puff(:,j)=freq_response(:,2);
    tone(:,j)=freq_response(:,3);
    

    %imagesc
    % false_freq=freq_response;
    % false_freq(find(false_freq(1:6:f3,:)))=.01;
    % false_freq(find(false_freq(2:6:f3,:)))=.1;
    % false_freq(find(false_freq(3:6:f3,:)))=.3;
    % false_freq(find(false_freq(4:6:f3,:)))=.5;
    % false_freq(find(false_freq(5:6:f3,:)))=.8;
    % false_freq(find(false_freq==0))=.66;
    % 
    % imagesc(false_freq,[0 1])

    %bar
    %length(find(freq_response))
    [r,c]=find(freq_response);
    cell_count=hist(c,1:length(multi_var));
    cell_per=cell_count./f3;
%     
%     display(animal);
%     figure; 
%     %bar(cell_count);
%     bar(cell_per);
%     set(gca,'XTick',1:length(multi_var),'XTickLabel',x,'Ylim',[0 1]);
%     title(sprintf('%s - % s - t1: %d t2: %d',cell2mat(fields(id)),day,thresh,per_thresh));
%     
    out(j,:)=cell_per;
    end
%end
figure;imagesc(light);
figure;imagesc(puff);
figure;imagesc(tone);

end

