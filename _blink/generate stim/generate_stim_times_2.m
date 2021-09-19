clear all

blink=1; mix=1;
if blink==1 && mix==1; error('Choices incompatible'); end

% variables, all times are relative to the start of a trial
stimTrials=50;
postTrials=10;
preTrials=10;
numTrials=postTrials+preTrials+stimTrials;
possibleLag=(0:50:2000)';
cs=2200;                                        % dac0, right, light
us=2500;                                        % ttl3, puff
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


% eyeblink trials


% interspersed trials 


% probe trials?
pr=1;
probe=1:5:stimTrials;


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



%%% BLINK TRIALS%%%
% stimulus paramaters
cs_dur=repmat(50,stimTrials,1);
us_dur=repmat(20,stimTrials,1);
dac1_dur=repmat(50,stimTrials,1);
cs_amp=repmat(10,stimTrials,1);
dac1_amp=repmat(10,stimTrials,1);

% generate lag
len=length(possibleLag);
ind=randi(len,[stimTrials 1]);
lag=possibleLag(ind);


% set stim times, incorporating lag
if blink==1
    cam_delay=lag+camD;
    cs_start=lag+cs;
    us_start=lag+us;
    dac1_start=cs_start;
end


if mix==1
    % stimulus selection
    %1 = cs; 2= us; 3=dac1; 4=dac2, 5=dac3; 6=ttl1, 7=ttl2 

    stimStart=2500;
    numStim=50;
    numCs=20; cs=repmat(1,numCs,1);
    numUs=10; us=repmat(2,numUs,1);
    numDac2=20; dac2=repmat(4,numDac2,1);
    st=[cs; us;dac2];



    % lag
    len=length(possibleLag);
    ind=randi(len,[numStim 1]);
    lag=possibleLag(ind);
    camDelay=lag+camD;


    camDelay=lag+camD;
    stimTime=lag+ stimStart;
    ss=zeros(3,numStim)';
    stims2=[ camDelay ss];


    idx = randperm(length(st));
    s   = st(idx);

    for i=1:numStim
        stims2(i, s(i)+1)= stimTime(i);
    end
   
end
    
    




tempM=[cam_delay cs_start cs_dur cs_amp us_start us_dur dac1_start dac1_dur dac1_amp ];

% take care of probe trials
if pr==1
    tempM(probe,5:6)=repmat([0],10,2);
end
M(11:60,3:11)=tempM; %hack







%% PLOT BLINK

x=1:8000; %hack 8000
y=zeros(numTrials,8000); %hack 8000

figure; hold on;

for i=1:size(M,1)
    % cam delay
    y(i,M(i,3))=1;
    
    aa=M(i,4);
    if aa~=0;y(i,aa:aa+50)=1; end %hack 50
    
    bb= M(i,7);
    if bb~=0;y(i,bb:bb+20)=1; end %hack 20
    
    
    yy=y(i,:)+(i*2);
    plot(x,yy);
    if mod(i,2)==0; text(10,yy(1), num2str(i)); end
    axis square;
    set(gcf,'Color',[1 1 1]);
    set(gca,'ycolor',[1 1 1]);
    
    
end

%% PLOT MIX TRIALS
    




