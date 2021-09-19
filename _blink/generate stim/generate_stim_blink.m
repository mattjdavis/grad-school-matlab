clear all

% variables, all times are relative to the start of a trial
stimTrials=50;
postTrials=10;
preTrials=10;
numTrials=postTrials+preTrials+stimTrials;
%possibleLag=(0:50:2000)';
possibleLag=repmat(0,1,41)';
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
    cam_delay=lag+camD;
    cs_start=lag+cs;
    us_start=lag+us;
    dac1_start=cs_start;




tempM=[cam_delay cs_start cs_dur cs_amp us_start us_dur dac1_start dac1_dur dac1_amp ];

% remove probes
if pr==1
    tempM(probe,5:6)=repmat([0],length(probe),2);
end
M(preTrials+1:preTrials+stimTrials,3:11)=tempM; 







%% PLOT BLINK

x=1:5000; %hack 8000
y=zeros(numTrials,5000); %hack 8000

figure; hold on;

for i=1:size(M,1)
    % cam delay
    cc=M(i,3);
    y(i,cc)=1;
    
    %cs
    aa=M(i,4);
    if aa~=0;y(i,aa:aa+50)=1; end %hack 50
    
    %us
    bb= M(i,7);
    if bb~=0;y(i,bb:bb+20)=1; end %hack 20
    
    
    yy=y(i,:)+(i*2);
    plot(x,yy);
    if mod(i,2)==0; text(10,yy(1), num2str(i)); end
    axis square;
    set(gcf,'Color',[1 1 1]);
    set(gca,'ycolor',[1 1 1]);
    
    plot(cc,1+(i*2), 'Marker', '*', 'MarkerEdgeColor','r');
    %plot(cc,1+(i*2), 'Marker', '*');
    plot(bb,1+(i*2), 'Marker', '+','MarkerEdgeColor','k');
end

%% PLOT MIX TRIALS
    




