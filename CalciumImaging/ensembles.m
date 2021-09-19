
path='Y:\\experiments\\eb_arc_4\\exp2\\';
d1=load(strcat(path,'md185_wRPM_2.mat'));
d2=load(strcat(path,'md186_wRPM_2.mat'));
d3=load(strcat(path,'md187_wRPM_2.mat'));
%%
n1=1;
n2=6;
activityThreshold= 20;

s1=[d1.dataset{n1}.nEvents d2.dataset{n1}.nEvents d3.dataset{n1}.nEvents];
s2=[d1.dataset{n2}.nEvents d2.dataset{n2}.nEvents d3.dataset{n2}.nEvents];

x{1}=find(s1 >= activityThreshold );
x{2}=find(s2 >= activityThreshold );

nActiveS1=length(x{1});
nActiveS2=length(x{2});

percentOverlap=length(intersect(x{1},x{2})) / length(s1); %over all cells, ASSUME SAME NUMBER ROIS

%%
figure;imagesc([s1' s2']); colormap hot;
%% SIGNLE DATASET : OVERLAPPING ENSEMBLES 

dataset=datasets;
% vars
activityThreshold= 5; % num events to count cell active
sessionsToCompare=[dataset{2}, dataset{2}]; %datasets to look at

nRois=dataset{1}.num_rois; % ASSUME SAME TOTAL ROIS ACROSS SESSIONS, CAN MAKE CHECK
for i=1:length(sessionsToCompare)
    
    n=sessionsToCompare(i).nEvents;
    %perTomH=length(find(n >= activityThreshold ))/ length(tomatoPosNumEvents)
    x{i}=find(n >= activityThreshold ); %this find looks at indexes, not roi label names. must have same rois in index (they were sorted earlier, so it should hold).

end

nActiveS1=length(x{1});
nActiveS2=length(x{2});
%percentOverlap=length(intersect(x{1},x{2})) / length(unique([x{1} x{2}])); %over total active cells from those two sessions
percentOverlap=length(intersect(x{1},x{2})) / nRois; %over all cells

%% MULTI: OVERLAPPING ENSEMBLES

% vars
T=[1 2 3 4 5 6 7 8 9 10];
%D=[d1 d2 d3];
D=datasets;

% days/session to comaper
n1=1;
n2=2;

for k=1:length(T)
    
    activityThreshold= T(k); % num events to count cell active
    
    for j=1:length(D)
        %sessionsToCompare=[D(j).dataset{n1}, D(j).dataset{n2}]; % old, 

        nRois=D(j).dataset{1}.num_rois; % ASSUME SAME TOTAL ROIS ACROSS SESSIONS, CAN MAKE CHECK
        for i=1:length(sessionsToCompare)

            n=sessionsToCompare(i).nEvents;
            %perTomH=length(find(n >= activityThreshold ))/ length(tomatoPosNumEvents)
            x{i}=find(n >= activityThreshold ); %this find looks at indexes, not roi label names. must have same rois in index (they were sorted earlier, so it should hold).

        end

        nActiveS1=length(x{1});
        nActiveS2=length(x{2});
        
        overlapROIs=intersect(x{1},x{2});
        
        %make sure labels are in the same order and match
        if (D(j).dataset{n1}.labels == D(j).dataset{n2}.labels)
            L=D(j).dataset{n1}.labels;
            labelsOverlap{j,k}=L(overlapROIs);
        end
        
        
        percentOverlap(j,k)=length(overlapROIs) / length(unique([x{1} x{2}])); %over total active cells from those two sessions
        %percentOverlap(j,k)=length(overlapROIs) / nRois; %over all cells
        
        

    end
    
end



%%

% 2 for 186, has good diff in overlap, 5 is my chosen threshold
val=labelsOverlap{2,5};
dlmwrite('C:\\tempOverlap.csv',val);

%%
figure; plot(percentOverlap');

mPercentOverlap=mean(percentOverlap);
semPercentOverlap=std(percentOverlap)/sqrt(length(percentOverlap));

m(3,:)=mPercentOverlap;
s(3,:)=semPercentOverlap;

%%

figure;

%plot(m','LineWidth',3); hold on;
h1=errorbar(m',s','LineWidth',2);



% fig
%legend({'24 hr','5 hr'},'Box','off');
%legend({'2-3','2-4','2-5','2-6'},'Box','off');

%retag
%legend_tag={'(24hr)','(24 hr)','(24 hr)','(10 hr)', '(5 hr)'};
%legend(strcat(e_legend,legend_tag),'Box','off','Location','southwest');
%for i=1:3; h1(i).LineStyle='--';end

%e_legend={'24 hr','1 Day','7 Days'};
e_legend=cellfun(@num2str,e_legend,'UniformOutput',0);
legend(e_legend,'Box','off','Location','southwest'); %normal legend
box off;

% ax
xlabel({'Active threshold';'(# events)'},'FontName','Arial','FontWeight','bold','FontSize',20 );
ylabel({'Overlapping ensemble'; '(% reactivated)'},'FontName','Arial','FontWeight','bold','FontSize',20 );
set(gca,'FontSize',14,'FontWeight','bold');

set(gca,'XTick',T);
set(gca,'Ylim',0:1)
%set(gca,'Xlim',0:12)

%% MULTI DATASETS w/ sessions: OVERLAPPING ENSEMBLES

% vars
%T=[1 2 3 4 5 6 7 8 9 10];
T=1:20;
%D=[d1 d2 d3];

%new
d1.dataset=datasets;
D=[d1];

% days/session to comaper
%s_comp={[1 6], [2 6], [3 6], [4 6], [5 6], [7 6]};
%s_comp={[1 5], [2 5], [3 5], [4 5], [5 6]};
%s_comp={[1 2], [2 3], [3 4], [4 5], [5 6]};
%s_comp={[1 7], [2 7], [3 7], [4 7], [5 7]};

%s_comp={[5 6], [2 3], [6 7]};

%eb_arc_5
%s_comp={[1 2], [1 3], [1 4], [1 5], [1 6]};
s_comp={[1 2], [2 3], [3 4], [4 5], [5 6]};
s_comp={[2 3], [4 5], [5 6]};
%
%s_comp={[2 3], [5 6]};



%blank vars
m=[]; s=[]; percentOverlap=[]; e_legend={};


for l=1:length(s_comp)
    
    for k=1:length(T)

        activityThreshold= T(k); % num events to count cell active

        for j=1:length(D)

            sessionsToCompare=[D(j).dataset{s_comp{l}(1)}, D(j).dataset{s_comp{l}(2)}]; %datasets to look at

            nRois=D(j).dataset{1}.num_rois; % ASSUME SAME TOTAL ROIS ACROSS SESSIONS, CAN MAKE CHECK
            for i=1:length(sessionsToCompare)

                n=sessionsToCompare(i).nEvents;
                %perTomH=length(find(n >= activityThreshold ))/ length(tomatoPosNumEvents)
                x{i}=find(n >= activityThreshold ); %this find looks at indexes, not roi label names. must have same rois in index (they were sorted earlier, so it should hold).

            end

            nActiveS1=length(x{1});
            nActiveS2=length(x{2});

            overlapROIs=intersect(x{1},x{2});

            %make sure labels are in the same order and match
            if (D(j).dataset{s_comp{l}(1)}.labels == D(j).dataset{s_comp{l}(2)}.labels)
                L=D(j).dataset{s_comp{l}(1)}.labels;
                labelsOverlap{j,k}=L(overlapROIs);
            end
            
            %percentOverlap(j,k)=length(overlapROIs) / length(unique([x{1} x{2}])); %over total active cells from those two sessions
            percentOverlap(j,k)=length(overlapROIs) / nRois; %over all cells



        end

    end

figure; plot(percentOverlap');

mPercentOverlap=mean(percentOverlap,1);
semPercentOverlap=std(percentOverlap,[],1)/sqrt(length(percentOverlap));

m(l,:)=mPercentOverlap;
s(l,:)=semPercentOverlap;

e_legend{l}=strcat(mat2str(s_comp{l}(1)) , '-', mat2str(s_comp{l}(2)));

end

%% shuffled