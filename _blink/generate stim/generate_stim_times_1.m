clear all
% probe trials?
pr=0;


% variables
numTrials=50;
cs=2200;        % dac0, right, light
us=2500;         % ttl3, puff
camD=2000;
%camStart=   % ttl4,
%dac1=
%dac2=
%dac3=
%ttl1
%ttl2
%ttl3
probe=1:5:numTrials;

% generate lag
possibleLag=(0:50:2000)';
len=length(possibleLag);
ind=randi(len,[numTrials 1]);
lag=possibleLag(ind);

% set stim times, incorporating lag
camDelay=lag+camD;
csStart=lag+cs;
usStart=lag+us;

stims=[camDelay csStart usStart];

% duration
dura=repmat([50 20],numTrials,1);

% take care of probe trials
if pr==1
    stims(probe,3)=repmat([0],10,1);
    dura(probe,2)=repmat([0],length(probe),1);
end



%% interpersed trials
stimStart=2500;
camDelay=lag+camD;
stimTime=lag+ stimStart;
ss=zeros(3,50)';
stims2=[ camDelay ss];

% 1= puff, 2 = light, 3 = tone
st=[1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3];
idx = randperm(length(st));
s   = st(idx);

for i=1:50
    stims2(i, s(i)+1)= stimTime(i);
end
    

%% 10 cam delay trials
possibleLag=(0:50:2000)';
len=length(possibleLag);
ind=randi(len,[10 1]);
lag=possibleLag(ind);
camDelay=lag+camD;


%% plot for stim trials
figure; hold on

x=1:8000
y=zeros(numTrials,8000)
for i=1:size(stims,1)
    % cam delay
    y(i,stims(i,1))=1;
    
    aa=stims(i,2);
    y(i,aa:aa+50)=1;
    
    bb=stims(i,3);
    if bb~=0;y(i,bb:bb+20)=1; end
    
    plot(x,y(i,:)+(i*2));
end
    



%% light, tone , camdelay



