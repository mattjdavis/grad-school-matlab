numrewards = 6; %number of rewards 
prop = .02; %von mises width expressed as proportion of track
numpos = 384; %number of discrete positions
center = round(0.75*numpos); %center of reward location
FWHM = prop*numpos; %full width at half max
pos = 1:numpos; %positions in squares
radpos = linspace(-pi,pi,numpos); %positions in radians
%rescale position and FWHM to phase
pos = (pos-(max(pos)-min(pos))/2);
FWHM = FWHM/max(abs(pos))*pi;
%convert FWHM to von Mises concentration parameter
kappa = log(2)/(1-cos(FWHM/2));
%make von mises distribution
delta = angle(exp(1i*repmat(radpos(center),1,numpos)).*conj(exp(1i*radpos)));
vmk = exp(kappa*cos(delta));
vmk = vmk/sum(vmk); %make probability distribution


%generate a reward sample for a single lap
rewsamp = randsample(1:numpos,numrewards,true,vmk);

% decimate
vmkd=decimate(vmk,16)*200; % 200 scales for plotting with lickrate

%% multi lap, put into bins
edges=1:16:numpos+16; % defines left edge of bin
nlaps=1;
for ii=1:nlaps
rewsamp = randsample(1:numpos,numrewards,true,vmk);
rewbin=sort(discretize(rewsamp,edges));
end

%% multi lap with string
edges=1:16:numpos+16; % defines left edge of bin
nlaps=50;
locations=[1:16:384 ; 16:16:384]';
xx=[];

for ii=1:nlaps
    %random sample
    rewsamp = randsample(1:numpos,numrewards,true,vmk); %von mises
    %rewsamp = randsample(1:numpos,numrewards,true); %uniform
    rewbin=sort(discretize(rewsamp,edges));

    L=locations(rewbin,:);
    S=strcat('{',num2str(L(1,1)),',',num2str(L(1,2)),'},',...
        '{',num2str(L(2,1)),',',num2str(L(2,2)),'},',...
        '{',num2str(L(3,1)),',',num2str(L(3,2)),'},',...
        '{',num2str(L(4,1)),',',num2str(L(4,2)),'},',...
        '{',num2str(L(5,1)),',',num2str(L(5,2)),'},',...
        '{',num2str(L(6,1)),',',num2str(L(6,2)),'},');
    rr=strcat(num2str(rewbin(1)),',',num2str(rewbin(2)),',',num2str(rewbin(3)),',',num2str(rewbin(4)),',',num2str(rewbin(5)),',',num2str(rewbin(6)),','); 

    % 1st part
    if(ii==1);
        loc_string='{';
        ind_string='{';
    end

    loc_string= [loc_string S];
    ind_string= [ind_string rr];

    if(ii==nlaps);
        loc_string(end)=[];
        loc_string= [loc_string '}'];
    end
    
    % binary matrix of locations
    %x=zeros(1,24);
    %x(rewbin)=1;
    %xx=[xx;x];
    x=histcounts(rewbin,1:25);
    xx=[xx;x];
end
%
% visual of reward locations
%
figure;imagesc(-1*xx); colormap gray;

end




%% uniform sample

numrewards = 6; %number of rewards 
rewsamp = randsample(1:numpos,numrewards,true);


%




