%% load struct with cr data
animal='md081';
S=data;
S.(animal)=rmfield(S.(animal),'V');
days=fields(S.(animal));
len=length(days);

%% add cr especially

for i=1:len
    
    day=days{i};
    cr=data.(animal).(day).Cr;
    
    % new struct
    % todo: put this into a method
    trial_type = struct(...
    'all',[],...    
    'cr',[],...
    'no_cr',[],...
    'blank',[],...
    'cs',[],...
    'us',[],...
    'probe',[],...
    'paired',[],...
    'bad_blink',[],...
    'bad_trial',[]);

    
    % add cr info
    if ~isempty(cr)
        
        %cr trials
        cr_ind=find(cr);
        cr_ind=setdiff(cr_ind,[1:10 71:80]); % get rid of blanks
        
        % no cr trials
        no_cr_ind=~cr;
        no_cr_ind=find(no_cr_ind);
        no_cr_ind=setdiff(no_cr_ind,[1:10 71:80]);
        
        % fill struct with cr
        trial_type.cr=cr_ind;
        trial_type.no_cr=no_cr_ind;
    end
    
    % add to main data struct
    data.(animal).(day).trial_type = trial_type;
    display(day);
    display(trial_type);
end


%% add probes and blanks

for i=1:len
    
    day=days{i};
    S=data.(animal).(day);
    tt=S.TrialTypeIndex;
    
    S.trial_type.cs=tt{2,1};
    S.trial_type.us=tt{2,2};
    S.trial_type.blank=tt{2,5};
    S.trial_type.paired=tt{2,6};
    S.trial_type.probe=tt{2,7};
    
    S.trial_type.bad_blink=find(S.BadBlinkTrials);
    S.trial_type.all=1:S.total_trials;
    
    
    data.(animal).(day)=S;
    
end

%%
for i=1:len
      day=days{i};
    S=data.(animal).(day);
    
  if(isfield(data.(animal).(day),'Cr'));data.(animal).(day)=rmfield(data.(animal).(day),'Cr');end
   if(isfield(data.(animal).(day),'NoCr'));data.(animal).(day)=rmfield(data.(animal).(day),'NoCr');end
    if(isfield(data.(animal).(day),'ProbeInd'));data.(animal).(day)=rmfield(data.(animal).(day),'ProbeInd');end
    if(isfield(data.(animal).(day),'PairedInd'));data.(animal).(day)=rmfield(data.(animal).(day),'PairedInd');end
   if(isfield(data.(animal).(day),'BadBlinkTrials'));data.(animal).(day)=rmfield(data.(animal).(day),'BadBlinkTrials');end
    if(isfield(data.(animal).(day),'BadTrials'));data.(animal).(day)=rmfield(data.(animal).(day),'BadTrials');end
    if(isfield(data.(animal).(day),'TrialTypeIndex'));data.(animal).(day)=rmfield(data.(animal).(day),'TrialTypeIndex');end
    if(isfield(data.(animal).(day),'total_trials'));data.(animal).(day)=rmfield(data.(animal).(day),'total_trials');end
end


%% new trial type struct
% I decided to leave rpm finding alone,



    trial_type = struct(...
    'all',[],...    
    'cr',[],...
    'no_cr',[],...
    'blank',[],...
    'cs',[],...
    'us',[],...
    'probe',[],...
    'paired',[],...
    'bad_blink',[],...
    'bad_trial',[]);



