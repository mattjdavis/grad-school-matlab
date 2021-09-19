function [ onset_index, transient_length] = findOnset(fluor,thresh_matrix,off_matrix,minFramesAbove,frame_window,dim)
%findOnset will find the onset of a threshold crossing
%   gnonive on file exchange
%   http://stackoverflow.com/questions/3274043/finding-islands-of-zeros-in-a-sequence

% This function will mark the threshold crossing, only if the next 3 bins
% remain above threshold.
%
% dim, the dimension that indexes the trials

%number of frames above threshold before a signal is counted
if nargin < 4
    minFramesAbove=3; 
end

%allows one to switch the dim that indexes trials
if nargin < 5
    dim=2;
end

%default look at whole trace
if nargin < 6
    frame_window=[1 size(fluor,1)];
end

% Loop through roi (j) and trial (i)
for j=1:size(fluor,3)
    for i=1:size(fluor,dim)
    
        
        switch dim
            case 1
                signal=fluor(i,:,j);
            case 2
                signal=fluor(:,i,j);
        end
        
         
        % convert the signal to vector of 0 and 1 (1 higher than thresh)
        thresh = thresh_matrix(i,j);
        tsignal = signal > thresh;
        tsignal=~tsignal; %hack to fit code

        %
        dsignal = diff([1 tsignal' 1]);
        startIndex = find(dsignal < 0);
        endIndex = find(dsignal > 0)-1;
        duration = endIndex-startIndex+1;
        

        %
        stringIndex = (duration >= minFramesAbove);
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
        if startIndex==1; startIndex =[]; end
        if startIndex < frame_window(1); startIndex =[]; end
        if startIndex > frame_window(2); startIndex =[]; end
        onset_index{i,j}=startIndex;
        
        
        % offset caculation
        
        
        if isempty(startIndex); % Need to return blank so function does not break - 2016/01/20
            transient_length{i,j}=0;
        
        % > 5 is very important for the to get rid of first onsets
        % changed 09.2015
        elseif (startIndex ~=0)
        %if (startIndex ~=0 & startIndex >5)
            
            off_vec=startIndex(1):length(signal);
            found=0;
            
            for k=1:length(off_vec)
                if (signal(off_vec(k)) < off_matrix(i,j));
                    transient_length(i,j)= k;
                    found=1;
                end

                if (k==length(off_vec))
                    transient_length{i,j}=k;
                    found=1;
                end

            end
            
        end
        
    end

end

