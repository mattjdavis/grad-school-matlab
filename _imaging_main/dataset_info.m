
animal='md078';
S=data;
S.(animal)=rmfield(S.(animal),'V');
days=fields(S.(animal));
len=length(days);




for i=1:len
    day=days{i};
    %if day~='V';    
        rpm_track(i)=~isempty(S.(animal).(day).rpm);
        tti_track(i)=~isempty(S.(animal).(day).TrialTypeIndex);
        cr_track(i)=~isempty(S.(animal).(day).Cr);
    %end
end


T=table(rpm_track',tti_track', cr_track','RowNames',days,...
    'VariableNames',{'RPM' 'Trial_Type' 'CR'});
display(T);