function [ stim, FileName ] = import_stim_index(FileName, method,day)
%% read stim order from excel


switch method
    case 'auto'
        if nargin <1
            [FileName,PathName] = uigetfile('.xlsx', 'Select the Excel file');
            addpath(PathName); %search path
        end

        read_matrix = xlsread(FileName);

        numTrials=size(read_matrix,1);
        tr=1:numTrials;

        stim=cell(2,7);

        any_cs=find(read_matrix(:,4));
        any_us=find(read_matrix(:,7));


        paired=intersect(any_cs,any_us);
        cs=setdiff(any_cs,paired);
        us=setdiff(any_us,paired);

        %seperates true 'cs' from probe trials
        probe_check=cs+1;
        probe_check=intersect(probe_check,paired);
        probe=[];
        if ~isempty(probe_check)
            cs=setdiff(cs,probe_check-1);
            probe=probe_check-1;
        end



        %just_cs=setdiff(any_cs,us); cs_ind= just_cs>60; only_cs=just_cs(cs_ind); % hack with 60
        %us=setdiff(us,paired);
        %probe=setdiff(just_cs,only_cs);

        stim{2,1}=cs;
        stim{2,2}=us;
        stim{2,4}=find(read_matrix(:,12));
        stim{2,3}=cs;
        stim{2,6}=paired;
        stim{2,7}=probe;

        allStimInd=[ stim{2,1}; stim{2,2}; stim{2,3}; stim{2,4}; stim{2,6}; stim{2,7}]; %can contain non unique trials

        stim{2,5}= find(~ismember(tr,allStimInd))';

        stim{1,1}='cs'; stim{1,2}='us'; stim{1,3}='dac1'; stim{1,4}='dac2'; stim{1,5}='blank'; stim{1,6}='paired'; stim{1,7}='probe'; 

    case 'manual'
        stim{1,1}='cs'; stim{1,2}='us'; stim{1,3}='dac1'; stim{1,4}='dac2'; stim{1,5}='blank'; stim{1,6}='paired'; stim{1,7}='probe';
        
        
        if strfind(day,'acc');
            ddsadf;
        else strfind(day,'td')
                blank=[1:10 71:80];
                total=70;
                probe=11:5:total;
                paired=setdiff(11:70,probe);
                
                stim{2,6}=paired;
                stim{2,7}=probe;
                stim{2,5}=blank;
                
            end
                

                
                
                
        display(paired, 'paired');
        display(probe, 'probe');
        displat(blank, 'blank');
        
        
end




