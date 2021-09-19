clear all



% variables, all times are relative to the start of a trial
stimTrials=45; postTrials=10; preTrials=10;
numTrials=postTrials+preTrials+stimTrials;
possibleLag=(0:50:2000)';
possibleLag=zeros(41,1);
camD=2000;
% camStart=                                     % ttl4,
% dac1=
% dac2=
% dac3=
% ttl1=
% ttl2=
% ttl3=
M=zeros(numTrials,21);
M(:,1)=0:numTrials-1;
M(:,2)=ones(numTrials,1);

%%%PRE AND POST TRIALS%%%
if preTrials~=0
    len=length(possibleLag);
    ind=randi(len,[10 1]);
    lag=possibleLag(ind);
    camDelay=lag+camD;
    
    %place trials in M
    M(1:preTrials,3)=camDelay;
    clear camDelay
end

if postTrials~=0
    len=length(possibleLag);
    ind=randi(len,[10 1]);
    lag=possibleLag(ind);
    camDelay=lag+camD;
    
    %place trials in M
    M(numTrials-postTrials+1:numTrials,3)=camDelay;
    clear camDelay
end


% generate lag
len=length(possibleLag);
ind=randi(len,[stimTrials 1]);
lag=possibleLag(ind);



%%% MIX TRIALS %%%

% stimulus selection
%1 = cs; 2= us; 3=dac1; 4=dac2, 5=dac3; 6=ttl1, 7=ttl2 
stimStart=2500;
numStim=stimTrials;
numCs=15; cs=repmat(1,numCs,1);
numUs=15; us=repmat(2,numUs,1);
numDac2=15; dac2=repmat(4,numDac2,1);
st=[cs; us;dac2];

% lag
len=length(possibleLag);
ind=randi(len,[numStim 1]);
lag=possibleLag(ind);
cam_delay=lag+camD;

stimTime=lag+ stimStart;
ss=zeros(3,numStim)';

idx = randperm(length(st));
s   = st(idx);

for i=1:numStim
    stims2(i, s(i))= stimTime(i);
end

cs_start= stims2(:,1);
us_start= stims2(:,2);
dac1_start=cs_start;
dac2_start=stims2(:,4);

% duration and amp
cs_dur=zeros(numStim,1); cs_dur(find(cs_start))=50;
us_dur=zeros(numStim,1); us_dur(find(us_start))=20;
dac1_dur=zeros(numStim,1); dac1_dur(find(dac1_start))=50;
dac2_dur=zeros(numStim,1); dac2_dur(find(dac2_start))=200;
cs_amp=zeros(numStim,1); cs_amp(find(cs_start))=10;
dac1_amp=zeros(numStim,1); dac1_amp(find(dac1_start))=10;
dac2_amp=zeros(numStim,1); dac2_amp(find(dac2_start))=10;

    
tempM=[cam_delay cs_start cs_dur cs_amp us_start us_dur dac1_start dac1_dur dac1_amp dac2_start dac2_dur dac2_amp ];
M(11:10+numStim,3:size(tempM,2)+2)=tempM; %hack







%% PLOT BLINK

x=1:3000; %hack 8000
y=zeros(numTrials,3000); %hack 8000

figure; hold on;

for i=1:size(M,1)
    % cam delay
    y(i,M(i,3))=1;
    
    aa=M(i,4); bb= M(i,7);cc=M(i,12);
    if aa~=0
        y(i,aa:aa+50)=1; yy=y(i,:)+(i*2); plot(x,yy,'b'); 
    elseif bb~=0
        y(i,bb:bb+20)=1; yy=y(i,:)+(i*2); plot(x,yy,'r'); 

    elseif cc~=0
        y(i,cc:cc+50)=1; yy=y(i,:)+(i*2); plot(x,yy,'g'); 
    else
        yy=y(i,:)+(i*2); plot(x,yy,'Color', [ 0 0 0]);  
    end 
    

    if mod(i,2)==0; text(10,yy(1), num2str(i)); end
    axis square;
    set(gcf,'Color',[1 1 1]);
    set(gca,'ycolor',[1 1 1]);
    
    
end

%% save










