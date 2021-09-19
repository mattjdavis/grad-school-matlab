function [ out ] = process_fluor_data( in,data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% Changes
% 08/26/2014 - changed data -> dF, bl_frames -> baseline_frames, num_cells->num_rois, to reflect
% loading sima changes. Used day_struct var to shorten, data.(animal).(day) 


% DAY CHOICE
% could easily condense td and acc, since they follow the same form
% could not get in struct to return
if isempty(in.day_choice)
    %day_choice=fieldnames(data.(animal)); 
    %day_choice=sort(day_choice);
    in.day_choice=fieldnames(data.(in.animal));
    %day_choice(1)=[]; when vars is present
elseif strcmp('td',in.day_choice)
    % select only td trials
    a=fieldnames(data.(in.animal));
    idx=strfind(a,'td');
    idx=find(~cellfun(@isempty,idx));
    in.day_choice=a(idx);
elseif strcmp('acc',in.day_choice)
    a=fieldnames(data.(in.animal));
    idx=strfind(a,'acc');
    idx=find(~cellfun(@isempty,idx));
    in.day_choice=a(idx); 
end

% CELL
% TRIAL



% Unpack in struct,
v2struct(in); 

for i=1:length(day_choice) 
    
   
    
    % current day
    day=day_choice{i};
    day_struct=data.(animal).(day);
    
    % default cell_choice, choose all
    if isempty(cell_choice); 
        cell_choice=1:day_struct.(roi).num_rois; 
    end;
    
%     %remove edge
%     roi_labels=day_struct.(roi).roi_labels;
%     [~, idx]=ismember(removed_cells, roi_labels);
%     roi_labels(idx)=[];
%     cell_choice= setdiff(1:day_struct.(roi).num_rois,idx);
    

    
    
    
    % skip missing days 
    if isfield(day_struct,roi)   
        
       % if isempty(trial_choice)
       trial_choice=trial_selector(day_struct,vars); 
       
        % some selection may be empty, such as 'cr'
        if ~isempty(trial_choice)

            % make new data matrix with kept trials
            fluor=day_struct.(roi).dF; 
            F{i}=fluor(:,trial_choice,cell_choice);
            roi_labels=day_struct.(roi).roi_labels;
            [dim1,dim2,dim3]=size(F{i});
            
            
            % edge
            
            
            
            
%             % normalize
%             max_roi=max(max(F{i}));
%             max_roi=repmat(max_roi./2,60,47,1);
%             F{i}=F{i}./max_roi;
          
            % smoothing function
            if (smoother == 1)
                F_smooth{i}=zeros(size(F{i}));
                for j=1:dim2
                    for k=1:dim3
                    P=F{i}(:,j,k);
                    filt=LFPmap(P,1:dim1,sigma);
                    F_smooth{i}(:,j,k)=filt';
                    end
                end
                    F=F_smooth;       
            end
            
            

            % get avg bl
            no=std(F{i}(day_struct.(roi).baseline_frames,:,:),1);
            bl{i}=reshape(no,dim2,dim3,[]);

            % threshold crossings
            onset_thresh=bl{i}*on_thresh;
            offset_thresh=bl{i}*off_thresh;
            [onsets{i}, lengths{i}]=findOnset(F{i},onset_thresh,offset_thresh,frame_window,2);
    
        else
            
            F{i}={}; % If no trials are selected for that day, a blank cell is inserted - 2016/01/20
            
        end
    end
    
    
 %if (exist('F','var') && dim2 > 2) 
  if (~isempty(F{i}) && size(F{i},2) > 2)
 

    linear_F=reshape(F{i},dim1,dim2*dim3);
    linear_onsets=reshape(onsets{i},1,dim2*dim3);
    [~,c1]=find(~cellfun(@isempty,linear_onsets));
   
    % get trial and roi labels for active traces
    b=1:dim3;
    c=repmat(b,length(trial_choice),1); c=reshape(c,1,dim2*dim3)';
    d=repmat(trial_choice,1,length(b))';
    ti= [d c];
    active_trace_id{i}=ti(c1,:); % (:,1) = trace, (:,2)= roi;
        

    % active traces
    active_traces{i}= linear_F(:,c1);
    [auc_sort{i}, max_sort{i}] = trace_sort(active_traces{i});
    active_mean(:,i)=mean(active_traces{i},2);
    active_num(i)=size(active_traces{i},2);
    active_percent(i)=(active_num(i)/(dim2*dim3))*100;
    num_total_traces(i)=dim2*dim3;

    % amplitude
    [max_amp{i},max_amp_ind{i}] = max(linear_F(in.stim_vec,:));
    max_amp_ind{i}=max_amp_ind{i}+19; %HACK
    %amps{i}=reshape(max_amp,size(max_amp,2),[]);
    %amps_ind{i}=reshape(max_amp_ind,size(max_amp_ind,2),[]);

    % summary stats for active cells
    

    % weird max data 
    med=median(active_traces{i}(5:20,:));
    [~, index1] = max(active_traces{i}-repmat(med,size(active_traces{i},1),1));
    [~,index2]=sort(index1);
    sorted_traces{i}=active_traces{i}(:,index2);

    % avg auc unders stim period
    x=trapz(active_traces{i}(stim_vec,:));
    avg_auc(i)=mean(x);
    sem_auc(i)=std(x) / sqrt(size(x,2));

    % stats for active traces
    [~,c2]=find(~cellfun(@isempty,onsets{i}));
    active_count{i}= c2;
    bin_count(:,i)=hist(active_count{i},1:dim3);
    num_trials(:,i)=dim2;
    
    selected_trials{i}=trial_choice;




 else
     display(strcat('No trials found for...','day','...','vars'));
 end
  
    display(sprintf('Day %s complete...',day));
end

% frequency response, imagesc
    freq_response=bin_count./repmat(num_trials,dim3,1);
    a=find(freq_response<freq_active_thresh);
    freq_response(a)=0;
    freq_response=freq_response;
    
 
% Description of this
description=struct;
description.name=in.vars;

%day axis label, extracts last two characters in day_choice cell array

d=cellfun(@(x) x(end-1:end), day_choice, 'UniformOutput', false);
description.day_label=cellfun(@(x) str2num(x), d);

%save the input
input=in;
  
% pack ouput variables
out= v2struct(F,...
    bl,onsets,lengths,...
    auc_sort,max_sort,...
    max_amp,max_amp_ind,...
    sorted_traces,...
    avg_auc,sem_auc,bin_count,...
    num_trials,freq_response,active_trace_id,...
    active_traces, active_num, active_mean,...
    selected_trials,active_percent,...
    num_total_traces,...
    description,input,...
    roi_labels);

display(strcat('-----Output Complete-----'));

end

