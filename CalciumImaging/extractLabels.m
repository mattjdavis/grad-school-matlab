function [ exLabels, collLabels ] = extractLabels( a )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
exLabels={};

for i=1:size(a,2)
    animal={a(i).INFO.animal};
    region={a(i).INFO.region};
    
    aCell=repmat(animal,a(i).num_rois,1);
    rCell=repmat(region,a(i).num_rois,1);
    
    T=[aCell rCell num2cell(a(i).labels)'];
    
    exLabels=[exLabels; T];
end

% COLLAPSE LABELS
% this gives 1 string that is easy to assing

collLabels={};

for i=1:size(exLabels,1)
    
    num2str(exLabels{i,3});
    collLabels{i}=strjoin([exLabels(i,1)  exLabels(i,2) num2str(exLabels{i,3})]);
end


end


