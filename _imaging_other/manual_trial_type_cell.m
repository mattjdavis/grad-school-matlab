%% make stim
% NOTE
% This is the old stim, using a cell array. 5/2015 I switched to defining
% trail types with handy structs. The other parts of this script still work
% fine.

%days={'td01','td02','td03','td04','td05','td06', 'td07', 'td08', 'td09', 'td10'};
clear stim cs_ind us_ind blank
stim{1,1}='cs'; stim{1,2}='us'; stim{1,3}='dac1'; stim{1,4}='dac2'; stim{1,5}='blank'; stim{1,6}='paired'; stim{1,7}='probe';


%% DEFINE 1: control trials
%cs_ind=[];
%us_ind=[];

blank=[1:10 71:80]
cs_ind=find(cs_ind);
us_ind=find(us_ind);

stim{2,1}=cs_ind;
stim{2,2}=us_ind;
stim{2,5}=blank;

%% DEFINE II: training trials
blank=[1:10 71:80];
total=70;
probe=11:5:total;
paired=setdiff(11:total,probe);

stim{2,6}=paired;
stim{2,7}=probe;
stim{2,5}=blank;




%% DEFINE III: blank trials
blank=[1:60];
stim{2,5}=blank;

%% DEFINE IV: same as another day

md075.td13.TrialTypeIndex=md075.td10.TrialTypeIndex;
md075.td12.TrialTypeIndex=md075.td09.TrialTypeIndex;
md075.td11.TrialTypeIndex=md075.td08.TrialTypeIndex;

%% load into struct
%days={'td01','td02','td03','td04','td05', 'td09'}
%days={'td06','td07','td10'};
days={'td11' 'td12' 'td13'};
%days={'acc01' 'acc02' 'acc03'};
for i=1:length(days)
    day=days{i};
    md076.(day).TrialTypeIndex=stim;
end
