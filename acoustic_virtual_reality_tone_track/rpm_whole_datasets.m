
DATA=struct;

%rpm_path='X:\\imaging\\eb_arc_5\\rpm\x\\';
%IMG_nFRAMES=6000;



rpm_path='X:\\imaging\\wheel_run_3\\rev\\';
IMG_nFRAMES=6000;
%%
files = dir(fullfile(rpm_path, '*.txt'));
files = {files.name}';

for i=1:length(files)
    split_fns=strsplit(files{i},'_');
    
    DATA(i).animal=split_fns{1};
    DATA(i).day=split_fns{2};
    DATA(i).group=split_fns{3};
    
    %NEED TO FIX FUNCTION TO ALLOW JUST RUN WITHOUT IMAGING!!!
    file=strcat(rpm_path,files{i});
    DATA(i).behavior=process_rpm_ToneTrack(file,IMG_nFRAMES); %% CHANGE THIS FUNCTION DEPENDEING ON RUN TYPE
    display(sprintf('File processed...%s',file));
end
    


%%

B=[DATA.behavior];
R=[B.run];

all_rpm=[R.rpm_ds];

figure;imagesc(all_rpm'); colormap hot;

%% Select certain days


days={'12012016','12022016','12032016','12042016','12052016','12062016'}; %LED60
ind1=zeros(length({DATA.day}),1);

for i=1:length(days)
x=strcmp({DATA.day},days{i})';
ind1=ind1+x;
end

%% logical
%% Select certain days

ind1=[];

%days={'12012016','12022016','12032016','12042016','12052016','12062016'}; %LED60
%days={'12042016','12052016','12062016'}; %led60
%days={'11127016','11128016','11129016'}; %run

%
%days={'01082017','01092017','01102017'}; %wheel run 3
days={'01132017','01142017','01152017'}; 

ind1=false(length({DATA.day}),1)';
for i=1:length(days)
    x=strcmp({DATA.day},days{i});
    ind1=ind1 | x;
end

%ind2=~ind1;select  other days 



%% plot

% FOR ALL SELECT LINE BELOW
%ind1=1:30;

subset1_rpm=all_rpm(:,ind1)';
figure;imagesc(subset1_rpm,[0 40]); colormap hot;
%figure;imagesc(all_rpm(:,ind2)'); colormap hot;

%% mean

%can plot mean, but very noisey
mean_rpm = ( subset1_rpm(1:3:end,:) + subset1_rpm(2:3:end,:) + subset1_rpm(3:3:end,:)) / 3;


 k = ones(1, 300) / 300;
 for i=1:size(mean_rpm,1)
    smooth_rpm(i,:) = conv(mean_rpm(i,:), k, 'same');
 end
 
 
 %% PLOT
 
 % FOR LED
 xLines={[0 600],[1200 1800], [2400 3000], [3600 4200], [4800 5400]};
 %xLines={[0 6360]};
 

 
 %figure;plot(smooth_rpm','Color',[0.5 0.5 0.5]);
 figure;
 ax1=plot(smooth_rpm');
 hold on;
 plot(mean(smooth_rpm),'LineWidth',6);
 
 %set(gca,'YLim',[0 45]);
 set(gca,'XTick',[1200 2400 3600 4800 6000],'XTickLabel',{'2','4','6','8','10'});
 xlabel('Time (m)','FontName','Arial','FontWeight','bold','FontSize',24 );
 ylabel('Speed (rpm)','FontName','Arial','FontWeight','bold','FontSize',24 );
set(gca,'FontSize',16,'FontWeight','bold'); 
 
 
%  % LED MARKER
% %y2=max(run); 
% y=40; % position of lick marker, bottom
% for i=1:length(xLines)  
%     line(xLines{i},[y y],'LineWidth',15,'LineStyle','-','Color',[0 .447 .741]);
% end


%% PLOT SUMMARY VARS

NUM_ANIMALS=5;

% sort array by day for easy indexing later (can change to animal);
[~,ind]=sort({DATA.day});
DATA=DATA(ind);




 
