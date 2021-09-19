function [data] = import_waterfall_text( file )
% reads in wf data from blink program
% TODO: make data matrix intialized, would have to pass num_trials

fileID = fopen(file,'r');
wf=textscan(fileID,'%s','Delimiter','\n');
fclose(fileID);

wf=cellstr(wf{:});
a = find(strcmp(wf,'BEGIN'));
b = find(strcmp(wf,'END'));

a=a+1;
b=b-1;

for i=1:size(a)
    if i==1 || i==2
        % read in color wave data if desired
    else
        c=wf(a(i):b(i),1);
        data(:,i-2)=cellfun(@str2num,c); % prevent color wave with -2
    end
end

end



% file= 'X:\eyeblink\md081\150506F\analysis_F150506\WaterFall_r4_fix.txt'


