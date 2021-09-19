% Load MAIN scripts (sima or imagej) and blink data will be called with
% correct inputs.

% Alternatively, use Blink to Mat (Manual) in blink_load_mat

% Note: prep_eb_import() needs import_waterfall_text()

%% Manual Blink -> Mat

dates={'151205', '151206', '151207', '151208', '151209', '151210',...
    '151211', '151212', '151213', '151214', '151215', '151216', '151217', '151218'}
days={'td01','td02','td03', 'td04', 'td05', 'td06','td07',...
    'td08','td09', 'td10', 'td11', 'td12', 'td13', 'td14'};
animal='md124'

for i=1:length(days)
    
    day=days{i};
    date=dates{i};
    
    cr{i}=prep_eb_import(animal,date,day);
    
end

