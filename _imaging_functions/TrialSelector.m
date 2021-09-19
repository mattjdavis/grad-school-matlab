function [ keep ] = TrialSelector(S,vars)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

R=S.rpm;
S=S.trial_type;

trials=S.all;

discard=[]; %trials to discard


% check for input errors
if ~isempty(strfind(vars,'run')) && ~isempty(strfind(vars,'noRun'))
    errordlg('run and noRun cannot be selected at one','Selection invalid');
end

if ~isempty(strfind(vars,'probe')) && ~isempty(strfind(vars,'paired'))
    errordlg('probe and paired cannot be selected at once', 'Selection invalid');
end

if ~isempty(strfind(vars,'cr')) && ~isempty(strfind(vars,'noCr'))
    errordlg('cr and noCr cannot be selected at once', 'Selection invalid');
end



% bad trials
if strfind(vars,'bt')
   bt=S.bad_trial;
   discard=[discard bt];
end

% bad blinks trials
if strfind(vars,'bb')
   bb=transpose(find(S.bad_blink));
   discard=[discard bb];
end

% run trials
if strfind(vars,'run')
   noRunInd=find(~[R{9,:}]);
   discard=[discard noRunInd];
end

% no run trials
if strfind(vars,'noRun')
   runInd=find([R{9,:}]);
   discard=[discard runInd];
end

if strfind(vars,'preRun')
   preRunInd=find([R{11,:}]);
   discard=[discard preRunInd];
end

if strfind(vars,'probe')
  discard=[discard setdiff(trials,S.probe)];
end

if strfind(vars,'paired')
   discard=[discard setdiff(trials,S.paired)];
end

if strfind(vars,'cr')
    discard=[discard setdiff(trials,S.cr)];
end

if strfind(vars,'no_cr')
    discard=[discard setdiff(trials, S.no_cr)];
end
if strfind(vars,'blank')
   discard= [discard setdiff(trials, S.blank)];
end

if strfind(vars,'train')
end

if strfind(vars,'pre')
end


% if strfind(vars,'dac2')
%    discard= [discard setdiff(trials,S.TrialTypeIndex{2,4})];
% end
% 
% if strfind(vars,'dac1')
%    discard= [discard setdiff(trials,S.TrialTypeIndex{2,3})];
% end
% 
% if strfind(vars,'no_blank')
%    discard= [discard S.TrialTypeIndex{2,5}];
% end

if strfind(vars,'cs')
   discard=[discard setdiff(trials, S.cs)];
end

if strfind(vars,'us')
   discard=[discard setdiff(trials, S.us)];
end


%Remove unwanted trials
discard=unique(discard);
keep=setdiff(trials,discard);

       
end

