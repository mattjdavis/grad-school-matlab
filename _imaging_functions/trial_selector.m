function [ keep ] = trial_selector(S,vars)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

R=S.rpm;
S=S.trial_type;

trials=S.all;

discard=[]; %trials to discard

% 
% % check for input errors
% if ~isempty(find(ismember(vars,'run'))) && ~isempty(find(ismember(vars,'noRun')))
%     errordlg('run and noRun cannot be selected at one','Selection invalid');
% end
% 
% if ~isempty(find(ismember(vars,'probe'))) && ~isempty(find(ismember(vars,'paired')))
%     errordlg('probe and paired cannot be selected at once', 'Selection invalid');
% end
% 
% if ~isempty(find(ismember(vars,'cr'))) && ~isempty(find(ismember(vars,'noCr')))
%     errordlg('cr and noCr cannot be selected at once', 'Selection invalid');
% end
% 


% bad trials
if find(ismember(vars,'bt'))
    discard=[discard S.bad_trial];
end

% bad blinks trials
if find(ismember(vars,'bb'))
    discard=[discard S.bad_blink'];
end

% run trials
if find(ismember(vars,'run'))
   noRunInd=find(~[R{9,:}]);
   discard=[discard noRunInd];
end

% no run trials
if find(ismember(vars,'no_run'))
   runInd=find([R{9,:}]);
   discard=[discard runInd];
end

if find(ismember(vars,'preRun'))
   preRunInd=find([R{11,:}]);
   discard=[discard preRunInd];
end

if find(ismember(vars,'probe'))
  discard=[discard setdiff(trials,S.probe)];
end

if find(ismember(vars,'paired'))
   discard=[discard setdiff(trials,S.paired)];
end

if find(ismember(vars,'cr'))
    discard=[discard setdiff(trials,S.cr)];
end

if find(ismember(vars,'no_cr'))
    discard=[discard setdiff(trials, S.no_cr)];
end
if find(ismember(vars,'blank'))
   discard= [discard setdiff(trials, S.blank)];
end

if find(ismember(vars,'train'))
end

if find(ismember(vars,'pre'))
end


% if find(ismember(vars,'dac2')
%    discard= [discard setdiff(trials,S.TrialTypeIndex{2,4})];
% end
% 
% if find(ismember(vars,'dac1')
%    discard= [discard setdiff(trials,S.TrialTypeIndex{2,3})];
% end
% 
% if find(ismember(vars,'no_blank')
%    discard= [discard S.TrialTypeIndex{2,5}];
% end

if find(ismember(vars,'cs'))
   discard=[discard setdiff(trials, S.cs)];
end

if find(ismember(vars,'us'))
   discard=[discard setdiff(trials, S.us)];
end


%Remove unwanted trials
discard=unique(discard);
keep=setdiff(trials,discard);

       
end

