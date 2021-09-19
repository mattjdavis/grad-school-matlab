function [ events ] = detect_events( dF,onthresh,offthresh,minframes )
%UNTITLED2 Summary of this function goes here



% dF is matrix, frames x cells
[numframes, numcells]=size(dF);
bin=zeros(size(dF));

% sigma estimate (not great for active cells)
onsets=std(dF)*onthresh;
offsets=std(dF)*offthresh;

% HACK: will take onsets greater than 1SD of avg onset, and make it average
% I dont why this exists, 6.6.16
onsetCutoff=mean(onsets) + std(onsets);
%added 6.6.16 when adapting for multi trial
%onsetCutoff = repmat(onsetCutoff,1,num_trials,1); 
[a,b]=find( onsets > onsetCutoff);
onsets(b)=mean(onsets);
offsets(b)=mean(offsets);


% permute needed to get dF into 1 trial format
[on, len,onr, lenr]=findOnset2(dF,onsets,offsets,minframes);
num=cellfun(@numel,on);
numr=cellfun(@numel,onr);



        
    
    

events=v2struct(on, len, num, onr, lenr,numr,bin);



% great code to remove transients from trace, will implement later
%ind=find(~sbin);
%nd=sdF(ind);
%figure;plot(sdF,'r');hold on; plot(nd,'b'); %observe event removal


end

