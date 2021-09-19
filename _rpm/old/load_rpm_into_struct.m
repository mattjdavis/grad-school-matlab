
path='x:\\imaging\\cyclops\\md081\\rpm';
cd(path);

%days={'td01','td02','td03','td04','td05','td06','td07','td08', 'td09', 'td10'};

days={'acc01','td11', 'td12',};
%days={'td11', 'td12', 'td13'};
%days={'td08', 'td09', 'td10'};
fn=strcat('md081_',days);

for i=1:length(days)
    day=days{i};
    load(strcat(fn{i},'.mat'));
    data.md081.(day).rpm=rpm;
end

