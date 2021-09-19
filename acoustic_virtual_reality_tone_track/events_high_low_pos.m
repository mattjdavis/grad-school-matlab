
% sort events into high and low tone positions, return p() and ratio of h/l

events=detect_events(dF,2,.5,3);

evpos=histcounts(cell2mat(events.on),length(cpos)); %events per cpos

% P() of seeing an event on any given frame
h=find(cpos> max(cpos)/2); %high tone area
l=find(cpos<= max(cpos)/2); % low tone area

% mulitple events/bin is possible thus P() h + l can be greater than 1
%ph=sum(evpos(h))/length(h);
%pl=sum(evpos(l))/length(l);

% only counts 1 event/frame 
ph=length(find(evpos(h)))/length(h);
pl=length(find(evpos(l)))/length(l);
rh(i)=ph/pl; % ratio p(event /frame in high) : p(event /frame in low)
