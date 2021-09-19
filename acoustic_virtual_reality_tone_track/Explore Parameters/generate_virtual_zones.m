
%%

RPM=12; %standard trained mouse can run at the pace
tm=64*12; %transtions/min
ts=tm/60; %transtions/s

% 12.8 ~ 13 t/s

% 1:13   off
% 14:39  2 hz
% 40:65  4 hz
% 66:78  8 hz
% 79:91 16 hz
% 1 second tone, reward
% 3 second time out


%% common virtual tracks


% [26,4,13] [0-16-2x]
% {{1,13},{14,39},{40,65},{66,91},{92,117}}
% {0,2,4,8,16};

% [13,8,13] [0-16-2+]
%{{1,13},{14,26},{27,39},{40,52},{53,65},{66,78},{79,91},{92,104},{105,117}};
%{0,2,4,6,8,10,12,14,16}

% [13,8,13] [0-16-1+]
% {{1,13},{14,26},{27,39},{40,52},{53,65},{66,78},{79,91},{92,104},{105,117},{118,130},{131,143},{144,156},{157,169},{170,182},{183,195},{196,208}}
% {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}
%% generate zone limits

%%%%%%%%%%%%%%%%%%%%%%%
% ADJUSTABLE VARIABLES
zone_size=26;
zone_num=4;
buffer_size=0;
%%%%%%%%%%%%%%%%%%%%%%%


m=buffer_size+1:(zone_num*zone_size+buffer_size);
m=reshape(m,zone_size,[]);

if (buffer_size ~=0)
    S=sprintf('{{%d,%d}',1,buffer_size);
else
    S='{';
end

for i=1:zone_num;
    x=m(:,i);
    sub_string=sprintf(',{%d,%d}',x(1),x(end));
    if (buffer_size==0 && i==1);sub_string(1)=[];end %delete comma of 1st substring
    S=strcat(S,sub_string);
end

S=strcat(S,'}');




%%



%figure
fig1=figure;
set(fig1,  'units', 'inches', 'Position', [1, 1, 10, 2]);
set(gca,'LooseInset',get(gca,'TightInset'))



% LICK
%y2=max(run); 
y2=9; % position of lick marker, top
y1=y2-2; % position of lick marker, bottom
for i =1:lick_num
    x=tone_times(i);    
    line([x x],[y1 y2],'LineWidth',1,'LineStyle','-','Color',[0 0 0]);
end


%figure
box off;
set(gca,'Ylim',[0 10]); % reasonable for rpm
set(gca, 'XTick', []);
set(gca, 'YTick', []);
set(gca, 'XColor', [1,1,1]);
set(gca, 'YColor', [1,1,1]);