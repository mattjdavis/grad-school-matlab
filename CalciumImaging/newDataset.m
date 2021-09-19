%% new dataset
% 1st used for AdImg, oriens recordings. 06/2016

dataset=struct;

raw=[];
dF=[];
genotype='';
stim=struct; stim.tone=[];stim.hlight=[];stim.llight=[];stim.puff=[];
day='';
info=struct; info.imgSf=10.088;
empty=v2struct(raw,dF,stim,genotype,day,info);

%%

animals={'md157', 'md158', 'md159', 'md160', 'md161', 'md162', 'md163', 'md164', 'md165'} 

for i=1:length(animals)
    dataset.(animals{i})=empty;
end


%%