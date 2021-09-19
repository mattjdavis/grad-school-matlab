function [ onset_index, eventLengths,rOnsets,rLengths,bin] = findOnset2(dF,ont,offt,minframes,dF_sub,dim)
%findOnset2 will find the onset of a threshold crossing
% 
%   adapted from: gnonive on file exchange
%   http://stackoverflow.com/questions/3274043/finding-islands-of-zeros-in-a-sequence

if (nargin < 4); minframes=3; end; % #frames above threshold to count event
if (nargin < 5); dF_sub=[1 size(dF,1)]; end % default, whole dF
if (nargin < 6);dim=2;end; % dim that indexes trial

if (ndims(dF)==2 ); dF=permute(dF,[1 3 2]); end % one trial format, old

% Loop through roi (j) and trial (i)
for j=1:size(dF,3)
    TL=[];
    for i=1:size(dF,dim)
    
        
        switch dim
            case 1
                signal=dF(i,:,j);
            case 2
                signal=dF(:,i,j);
        end
        
         
        % convert the signal to vector of 0 and 1 (1 higher than thresh)
        thresh = ont(i,j);
        tsignal = signal > thresh;
        tsignal=~tsignal; %hack to fit code

        %
        dsignal = diff([1 tsignal' 1]);
        startIndex = find(dsignal < 0);
        endIndex = find(dsignal > 0)-1;
        duration = endIndex-startIndex+1;
        
        %
        stringIndex = (duration >= minframes);
        startIndex = startIndex(stringIndex);
        endIndex = endIndex(stringIndex);

        % indices gives the whole length of the vector
        indices = zeros(1,max(endIndex)+1);
        indices(startIndex) = 1;
        indices(endIndex+1) = indices(endIndex+1)-1;
        indices = find(cumsum(indices));
        
        % 4.20.2015, added ~=1 if to get rid of transients that 'start' at 1
        % 09.08.2015, added window variable to ignore transients outside a certain
        % window
%         if startIndex==1; startIndex =[]; end
%         if startIndex < frame_window(1); startIndex =[]; end
%         if startIndex > frame_window(2); startIndex =[]; end
        
        % better way to remove values from outside frame_window
        ind1 = find(abs(startIndex)<dF_sub(1)); startIndex(ind1) = [];
        ind2 = find(abs(startIndex)>dF_sub(2)); startIndex(ind2) = [];
        
        % offset caculation
        
        % Need to return blank so function does not break - 2016/01/20
        if ~isempty(startIndex); 
            
            transient_length{i,j}=0;
            deleteInd=[];
            
            for ii=1:length(startIndex)
                
                % make vector that goes from onset start to end of whole
                % signal
                off_vec=signal(startIndex(ii):length(signal));
                found=0;
                k=1;
                
                % step through all values of off_vec, looking for offset
                % threshold crossing, K is the actual frame count, or
                % transient length (TL)
                while (found ==0);

                        % checks if signal goes below off thresh, for that
                        % roi
                        if (off_vec(k) < offt(i,j));
                            TL=[TL k];
                            found=1;
                        end
                        
                        % this means k got to the end of whole signl, so
                        % the whole tranient is not observed before
                        % recording ends. Decided to ignore these
                        % transients and delete from start index (8.12.16)
                        % The offest can occur on the very last frame, thus
                        % found ~1 prevents removing this elemtent
                        if (k==length(off_vec) && found ~=1)
                            %TL=[TL k];
                            deleteInd=[deleteInd ii];
                            
                            %ii=ii+1; % so it doesn't loop again. 
                            found=1;
                        end

                        % loop counter
                         k=k+1;
                    end
            
            end 
            startIndex(deleteInd)=[]; %remove the last start indexes
        end
            
            % FINAL OUPUT VARIABLES
            onset_index{i,j}=startIndex;
            eventLengths{i,j}=TL;
            
           % reduced onsents and lenths, only keep transients that are
           % longer than 1 second ( cited in danielson DG paper). This is
           % to further reduce false positives.
            ind3 = find(TL >= 10);
            rOnsets{i,j}=startIndex(ind3);
            rLengths{i,j}=TL(ind3);
            
            %blank for next run
            TL=[]; 
        end     
end
    
onset_hack=0; %subtract 1 from start of onset
numframes=size(dF,1);
numcells=size(dF,3);
% build binary vector
for i=1:numcells
    con=onset_index{i}; % cell event onsets
    clen=eventLengths{i}; %cell, event lengths
    x=zeros(1,numframes);
    if (~isempty(con))
        for j=1:length(con)
            
            if (con(j)==1); con(j)=con(j)+1;end % start of vector
            if (con(j)+clen(j)>=length(con)); clen(j)=clen(j)-1;end % end of vector
            
            if (onset_hack)
                %subtract 1 to make onset looks better on plot
                v=con(j)-1:con(j)+clen(j);
            else
                v=con(j):con(j)+clen(j)-1;
            end
            x(v)=1;
        end
    end
    bin(:,i)=x;
end
    
end

