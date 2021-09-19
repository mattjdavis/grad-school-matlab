%% RPM LONG TRACES


%% Get Start times for tiffs 
%{ 
1) Make sure only the relevant tiff files are located in the tiffFilesPath
2) These files names are used to grap the text files in */info
3) The variable returned will have the processed image start times 


%}
directory='X:\\imaging\\eb_arc_4\\10022016\\';
rpmPath='X:\\imaging\\eb_arc_4\\rpm\\';

R=scientifica_get_rpm(directory);


% ---SET VARS---
IMG_SR=10.088781; % hz
num_frames=6000;
realImgTime=num_frames*1/IMG_SR; % sec

RPM_SR=20; % hz
numSamplesRPM= round(RPM_SR*realImgTime);


%% TEXT files
% put all text files in one location
text_files = dir(fullfile(rpmPath, '*.txt'));
read=[];

for i=1:length(text_files)
read = [ read ; csvread(strcat(rpmPath,text_files(i).name))];

end
%%

for j=1:size(R,2)
    % ---FIND---
    RPM=read(:,2);

    % For CDT, minus 5 hours
    timeRPM=read(:,1)'-repmat(18e6,1,size(read,1)); 

    % % For CST, minus 6 hours
    % timeRPM=read(:,1)'-repmat(216e5,1,size(read,1));

    [~, idx] = min(abs(timeRPM-R{4,j}));
    subRPM=RPM(idx:idx+6000-1); % Get the full chuck of relvant RPM

    % ---FILTER---
    % median filter, Also: min = 0, max = 60 
    run=medfilt(subRPM,3); % median filter
    run( run > 60 )=mean(run); % max = 60
    ind = find(run<0);run(ind) = 0; % min =  0
    % moving avg filter
    k = ones(1, 30) / 30;
    filtRPM = conv(run, k, 'same');

    % ---DOWNSAMPLE---
    % caculates which img frame is closest to which running frame, better than dumb downsampling
    z=linspace(1/IMG_SR,realImgTime,num_frames);
    zz=linspace(1/RPM_SR,num_frames/10,num_frames*2);

    for i=1:length(z)
        [~, idx] = min(abs(zz-z(i)));
        TT(i)=idx;
    end

    dsRPM=filtRPM(TT);
    
    % --COLLECT VARS--  
    R{5,j}=subRPM;
    R{6,j}=filtRPM;
    R{7,j}=dsRPM;
    R{8,j}=findRunEpochs(dsRPM, IMG_SR,3);
end

save(strcat(directory,'RPM.mat'),'R');

%%
% Defining running-related epochs: consecutive frames of forward
% lococation.
% 1s in duration, minmum peak of a certain threshold (default = 3);
% Bouts of non running <0.5s are not counted as breaking a run epoch.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IMAGING AND RUN PLOTS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% percent run from entire dataset
% this has the neat trick of getting information from a cell array of
% structs

 %R{8,1:16}; %homecage
 %R{8,17:end}; %wheel

aa={R{8,1:22}}; % puts all the epoch structs into a cell array
allPerRun=cellfun( @(x) x.percentRun, aa); % use cellfun to get the desired variable

figure; 
%[h]=histogram(allPerRun,0:.2:1,'Normalization','probability');
[h]=histogram(allPerRun,0:.2:1);
%ylim([ 0 max(h.Values)+2]); % add space to ylims
ylim([ 0 22]); 
set(gca,'FontName','Arial','FontWeight','bold','FontSize',12 );
xlabel('Running Duration (%)','FontName','Arial','FontWeight','bold','FontSize',18 );
ylabel('Number of Trials','FontName','Arial','FontWeight','bold','FontSize',18 );

%% check sub, filt, and ds rpm
% Dataset
D=11;  
T=R{7,D};

% run epochs
E=findRunEpochs(T, IMG_SR,3);

figure;

subplot(4,1,1);
plot(R{5,D}); 

subplot(4,1,2);
plot(R{6,D});

subplot(4,1,3);
plot(R{7,D});

subplot(4,1,4);
imagesc(~(E.runMask')); colormap hot;


%%
figure;
trace=R{7,D};
[Maxima,MaxIdx] = findpeaks(trace,'Annotate','peaks');
%DataInv = 1.01*max(trace) - trace;
%[Minima,MinIdx] = findpeaks(DataInv);

findpeaks(trace,'Annotate','extent');


%% check against dumb downsampling

figure;

subplot(2,1,1)
plot(nansum(longF,2)); %many cells

subplot(2,1,2);
plot(downsample(filtRPM,2));
hold on;
plot(dsRPM);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IMAGING AND RUN PLOTS %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% run with psth 

figure;
h1=subplot(2,1,1);
psth(find(N),imgHz*10,imgHz,num_rois,num_frames,h1);

subplot(2,1,2);
hold on;
plot(dsRPM);

%% check with img long
figure;
subplot(2,1,1)
%plot(nansum(longF,2));

subplot(2,1,2);
plot(dsRPM);




