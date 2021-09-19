% Loads .xlsx file from imagej. Use standard imagej multimeasure parameters
% (4 measurements per region of interest).

% 08.12.2015



file='X:\imaging\md090\raw\other\md090_td03_long_001\md090_td03_long_pyr1.xlsx'

bl_frames=1:60;
num_frames=60;

read = xlsread(file);
read(:,1) = []; 
[total_frames, num_cells] =size(read);
num_cells=num_cells/4;
num_traces=total_frames/num_frames;

 for i=0:num_cells-1
        mean_intensity(:,i+1)= read(:,2+(4*i));
 end
 
% df/f 
F= reshape(mean_intensity,num_frames,num_traces,num_cells);
bl_vec=F(bl_frames,:,:);
bl_avg=mean(bl_vec);
bl=repmat(bl_avg,num_frames,1);
dF=((F-bl)./bl)*100;

% median
med=median(mean_intensity);
med=repmat(med,2400,1);
dFmed=((mean_intensity-med)./med)*100;


%% plot I: all trials, all rois

for i=1:size(dF,3)
    figure;
    plot(dF(:,:,i));
    title(strcat('Cell: ',num2str(i)));
end


%% plotII : long

l=reshape(F,1,[],20);

figure;hold on;
for i=1:1
plot(l(:,:,i));
end

%% plot III: median

figure;plot(dFmed)

figure;plot(sum(dFmed,2));

figure;imagesc(dFmed',[0 200]);
