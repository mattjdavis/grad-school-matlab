

animal='md090';
days=fields(dataset.(animal));
roi='roi_pyr2'

% remove edge rois
edge=[];
for i=1:length(days)
    day=days{i};
    tags=dataset.(animal).(day).(roi).roi_tags;
    edge=[edge find(~cellfun(@isempty,tags))']
end
removed_cells_index=unique(edge);
num_removed= length(removed_cells_index);


%% remove edge rois
edge=[];
in.day_choice=fields(dataset.(in.animal));
for i=1:length(in.day_choice)
    day=in.day_choice{i};
    tags=dataset.(in.animal).(day).(in.roi).roi_tags;
    edge=[edge find(~cellfun(@isempty,tags))']
end
in.removed_cells_index=unique(edge);
num_removed= length(in.removed_cells_index);

%%

reduced_dataset=dataset;

for i=1:length(in.day_choice)
    day=in.day_choice{i};
    S=reduced_dataset.(in.animal).(day).(in.roi);
    S.roi_labels(in.removed_cells_index)=[];
    cell_choice= setdiff(1:S.num_rois,in.removed_cells_index);
    
    S = rmfield(S,'roi_tags');
    S.num_rois=length(S.roi_labels);
    
    S.raw_fluor=S.raw_fluor(:,:,cell_choice);
    S.dF=S.dF(:,:,cell_choice);
    S.mean_baseline=S.mean_baseline(:,cell_choice);
    
    reduced_dataset.(in.animal).(day).(in.roi)=S;
end


%%

fluor=reshape(reduced_dataset.md089.td02.roi_pyr1.dF,60,80*89);

figure; imagesc(fluor',[0 50]);


%%
fluor=reshape(dataset.md089.td06.roi_pyr1.dF,60,80*151);

figure; imagesc(fluor',[0 50]);


%%
days=fields(dataset.(in.animal));

for i=1:length(days)
    day=days{i};
    
    labels{i}=dataset.md089.(day).roi_pyr1.roi_labels;
end
