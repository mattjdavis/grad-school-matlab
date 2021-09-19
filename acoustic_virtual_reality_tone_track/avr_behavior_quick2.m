path='X:\\imaging\\wheel_run_6\\'

files = dir(fullfile(path, '*.txt'));
files = {files.name}';

for i=1:length(files)
    % parse file
    split_fns=strsplit(files{i},'_');
    DATA(i).animal=split_fns{1};
    DATA(i).day=split_fns{2};
    DATA(i).group=split_fns{3};
    
    % import table
    file=strcat(path,files{i});
    T=readtable(file);
    DATA(i).behavior=T; 
    
    
    % parse table
    DATA(i).nreward=max(T.reward);
    DATA(i).dist=max(T.position);
    DATA(i).nlicks=sum(T.lick_detected);
    
    
    %display
    display(sprintf('File processed...%s',file));
end


%
