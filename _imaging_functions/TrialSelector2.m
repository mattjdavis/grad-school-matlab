function [ keep ] = TrialSelector2(struct,day,animal, vars)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%assumes 1:10=pre, 11-60=trial, 61-70=post.
%examples: keep=TrialSelector(md036,'td05',['bt' 'run' 'noCr'])

id=struct; %need to make new struct instance to work with it dynamically;
trials=1:id.(animal).V.TrialsPerDay;

discard=[]; %trials to discard

%check for input errors
if ~isempty(strfind(vars,'run')) && ~isempty(strfind(vars,'noRun'))
    errordlg('run and noRun cannot be selected at one','Selection invalid');
end

if ~isempty(strfind(vars,'probe')) && ~isempty(strfind(vars,'paired'))
    errordlg('probe and paired cannot be selected at once', 'Selection invalid');
end

if ~isempty(strfind(vars,'cr')) && ~isempty(strfind(vars,'noCr'))
    errordlg('cr and noCr cannot be selected at once', 'Selection invalid');
end



   %bad trials
   if strfind(vars,'bt')
       bt=id.(animal).(day).BadTrials;
       discard=[discard bt];
   end
   
   %bad blinks trials
   if strfind(vars,'bb')
       bb=transpose(find(id.(animal).(day).BadBlinkTrials));
       discard=[discard bb];
   end
   
   %run trials
   if strfind(vars,'run')
       noRunInd=find(~[id.(animal).(day).rpm{9,:}]);
       discard=[discard noRunInd];
   end
   
   %no run trials
   if strfind(vars,'noRun')
       runInd=find([id.(animal).(day).rpm{9,:}]);
       discard=[discard runInd];
   end
   
   %probe
    %pretty hacky with trial removal.
   if strfind(vars,'probe')
       pairedInd=1:70;
       pairedInd(11:5:60)=[];
       discard=[discard pairedInd 1:10 61:70];
   end
   
   %paired
   if strfind(vars,'paired')
       probeInd=11:5:60;
       discard=[discard probeInd 1:10 61:70]; %get rid of pre and post
   end
   
   if strfind(vars,'cr')
       noCr=transpose(find([id.(animal).(day).NoCr])+10); %add 10 to account for pre
       discard=[discard noCr 1:10 61:70];
   end
   
   if strfind(vars,'noCr')
       cr=transpose(find([id.(animal).(day).Cr])+10); %add 10 to account fore pre
       discard=[discard cr 1:10 61:70];
   end
   
   if strfind(vars,'train')
   end
   
   if strfind(vars,'pre')
   end
   
   
   if strfind(vars,'dac2')
       discard= [discard setdiff(trials,id.(animal).V.dac2Ind)];
   end
   
   if strfind(vars,'dac1')
       discard= [discard setdiff(trials,id.(animal).V.dac1Ind)];
   end
   
   if strfind(vars,'blank')
       discard= [discard setdiff(trials,id.(animal).V.blankInd)];
   end
   
   if strfind(vars,'cs')
       discard= [discard setdiff(trials,id.(animal).V.csInd)];
   end
   
   if strfind(vars,'us')
       discard= [discard setdiff(trials,id.(animal).V.usInd)];
   end
       
  
   %Remove unwanted trials
   trials(unique(discard))=[];
   keep=trials;
   
       
end

