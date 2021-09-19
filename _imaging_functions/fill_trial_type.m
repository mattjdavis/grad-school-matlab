function [ tt] = fill_trial_type(S,num_trial,method)

tt=S.trial_type;

switch method
    
    case 'acc'
        tt.blank=1:num_trial;
        tt.all=1:num_trial;
    case 'standard'
        
        all=1:num_trial;
        blank=[1:10 (num_trial-9):(num_trial)]; 
        stim= setdiff(1:num_trial,blank);
        probe=11:5:stim(end);
        paired=setdiff(11:stim(end),probe);

        tt.all=all;
        tt.blank=blank;
        tt.stim=stim;
        tt.probe=probe;
        tt.paired=paired;

    case 'auto'
        
        ST=import_stim_template();
        
        % fill
        all=1:num_trial;
        blank=[1:10 (num_trial-9):(num_trial)];
        us= find(ST.US_start_wave)
        cs=find(ST.CS_start_wave)
        stim=setdiff(1:num_trial,blank);
        
        tt.all=all;
        tt.blank=blank;
        tt.stim=stim;
        tt.cs=cs;
        tt.us=us;
        tt.stim_template=ST;
end


% CR 
% Only works in eb has been processed in main script
% this removes all the blank trials from cr and no_cr
if isfield(S.eb,'CR')
    
    %cr
    cr=find(S.eb.CR.raw_data(:,1));
    tt.cr=setdiff(cr,tt.blank);

    %no cr
    no_cr=find(S.eb.CR.raw_data(:,2));
    tt.no_cr=setdiff(no_cr,tt.blank);
    
    % bad blink
    tt.bad_blink=find(S.eb.CR.raw_data(:,3));
end





end



