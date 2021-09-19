%%



PathName = uigetdir(cd,'Select the RPM text files');
%RoiFiles = dir(PathName,'*.xlsx');
TextFiles = dir(fullfile(PathName, '*.txt'));
TextFiles = {TextFiles.name}';
addpath(PathName);

%make sure these are imported in the correct order.
PathName = uigetdir(cd,'Select the RPM xml');
%RoiFiles = dir(PathName,'*.xlsx');
XmlFiles = dir(fullfile(PathName, '*.xml'));
XmlFiles = {XmlFiles.name}';
addpath(PathName);

%%
animal='F08';

for i=49:length(XmlFiles)
    acq=XmlFiles{i,1}(23:25);
    
    T=PraireTimeExtract(XmlFiles{i});
    T=PraireReadRpm(T,TextFiles{i});
    s=sprintf('%s_Td%d_%s',animal,Day(i),acq);
    save(s,'T');
    display(sprintf('run complete: %d/96',i));
    display(sprintf('...saved: %s',s));
end
    

%%for Day
% Day=1:16;
% Day=Day';
% Day=repmat(Day,1,6);
% Day=reshape(Day',[],1);

%TextFiles=repmat(TextFiles,1,6);
%TextFiles=reshape(TextFiles',[],1);


%%
%Selecting certain files
PathName='Z:\Z-Lab\Imaging\F08\ana\rpm';
Files = dir(fullfile(PathName, '*002*'));
Files = {Files.name}';

for i=1:length(Files)
    if isempty(Files{i}) 
        
    else
        load(Files{i}); 
        r002(:,i)=T.rpm_up_long;
    end
end
    
