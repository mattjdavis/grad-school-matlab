%% set vars
cdt=1/10.088;
raw = double(squeeze(raw)');
ct = cdt*ones(size(raw,1),1);
ct = cumsum(ct);
numcells = size(raw,2);
nbins = 100;
maps = zeros(numcells,nbins);
ard_timestamp = (ard_timestamp - min(ard_timestamp))/1000 + cdt;
%%
%remove NaNs from raw and get dF/F
rm = sum(isnan(raw),2);
raw = raw(rm==0,:);
dF = (raw-repmat(mean(raw,2),1,size(raw,2)))./repmat(mean(raw,2),1,size(raw,2));
%%

%%
%get position for each ct
cpos = zeros(size(ct));
for t = 1:length(ct)    
   [~,midx] = min((ard_timestamp-ct(t)).^2);
   cpos(t) = lap_position(midx);    
end

%plot dF on trajectory for each cell
for c = 1:numcells
    plot([min(ct) max(ct)],repmat(linspace(min(cpos),max(cpos),33)',1,2),'-k')
    hold on
    scatter(ct,cpos,15,raw(:,c),'filled');
    colormap hot
    xlim([min(ct) max(ct)])
    ylim([min(cpos) max(cpos)])
    xlabel('time (sec)')
    ylabel('position (wheel squares)')
    pause
    hold off    
end

%%
%get time since lap start for each ct
tfromstart = zeros(size(ct));
lapidx = find(cpos == 1);
for t = 2:length(ct)    
   start = lapidx(find(lapidx<=t,1,'last'));
   tfromstart(t) = ct(t) - ct(start);    
end

%plot dF on trajectory for each cell
for c = 1:numcells
    scatter(ct,tfromstart,15,raw(:,c),'filled');
    colormap hot
    xlim([min(ct) max(ct)])
    ylim([min(tfromstart) max(tfromstart)])
    xlabel('time (sec)')
    ylabel('time into lap (sec)')
    pause
    hold off    
end

%% sum_dF
figure;

plot([min(ct) max(ct)],repmat(linspace(min(cpos),max(cpos),33)',1,2),'-k')
hold on
scatter(ct,cpos,15,sum(dF),'filled');
colormap hot
xlim([min(ct) max(ct)])
ylim([min(cpos) max(cpos)])
hold off

