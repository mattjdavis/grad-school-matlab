function [ DATA] = batch_tone_track( path,IMG_SR)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
%%

if (nargin  < 2); IMG_SR=10.088; end;

files = dir(fullfile(path, '*.txt'));
files = {files.name}';

for i=1:length(files)
    split_fns=strsplit(files{i},'_');
    
    DATA(i).animal=split_fns{1};
    DATA(i).day=split_fns{2};
    DATA(i).group=split_fns{3};
    
    %NEED TO FIX FUNCTION TO ALLOW JUST RUN WITHOUT IMAGING!!!
    file=strcat(path,files{i});
    DATA(i).behavior=process_tone_track(file,IMG_SR); %% CHANGE THIS FUNCTION DEPENDEING ON RUN TYPE
    display(sprintf('File processed...%s',file));
end

end

