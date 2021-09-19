function [ epoch ] = findRunEpochs(signal, IMG_SR, rpmThresh )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if (nargin >3); rpmThresh=3; end

nSamples=length(signal);


% convert to binary
binarySignal = signal > 0;

% Get start and end of 1's, difference brings size of zero vectors
t = diff([false;binarySignal==0;false]);
p = find(t==1);
q = find(t==-1);
qp=q-p; % size of zero runs

% get zeros vectors less than 0.5 seconds (short segments)
% These are pauses in the running trace that we don't want to count as true
% stops. They will be treated as running so we have more contiounous
% running events.
[sh]=find (qp <= 0.5 *IMG_SR); 

% set all short zero segments to one 
for i=1:length(sh)
    si=qp(sh(i)); % size of zero run
    st=p(sh(i)); % start of zero run
    binarySignal(st:st+si)=1; % set parts of signal to zero
end


%%
% blank variables for later
runMask=zeros(nSamples,1);
lengthRunEpochs=[];
runEpochs=[];

if ~(qp == length(signal)) % this equality happens when there is no running
    
    binarySignal(end)=[]; %get rid of extra element from diff step

    runEpochs=[];oneInd=[];

    o=regionprops(bwlabel(binarySignal)); %gives bw and objects
    oo=vertcat(o.BoundingBox); % from bounding box give start and size of black regions (1's)
    g=round(oo(:,2)); % round the start index up
    oneInd=[g (oo(:,4)+ g -1)]; % get start and end index of black regions

    % For all the one segments, make sure that there is a minimum peak
    for i=1:size(oneInd,1);
        rTrace=[]; peakFound=[]; 

        rTrace=signal(oneInd(i,1):oneInd(i,2));
        peakFound=find(rTrace >= rpmThresh);
        if ~isempty(peakFound); runEpochs(i,:)=oneInd(i,:);end
    end

    if ~isempty(runEpochs)
        x=find(runEpochs(:,1)==0);
        runEpochs(x(:),:)=[]; % get rid of 0 indexs( previous loop found that there was no max threshold)
    end

    % create mask

    for i=1:size(runEpochs,1)
        runMask(runEpochs(i,1):runEpochs(i,2))=1;
        lengthRunEpochs(i)=runEpochs(i,2)-runEpochs(i,1)+1; %get lengh of each epoch, +1 to make it inclusive
    end
end


% percent running
percentRun=sum(lengthRunEpochs)/length(signal);

% return strut
epoch=v2struct(runMask,runEpochs,lengthRunEpochs,percentRun);

end

