function [cr,lat_max,lat_crit,max_amp] = blink_extract_cr( S,blink_vec )

% vars
animal=char(fields(S));
num_load=size(S.(animal),2)
num_trials=length(blink_vec);

% cr
x=cell2mat(S.(animal)(2,:,1));
%num_trials=size(x,1)
x=reshape(x,[],3,num_load);
cr=sum((x(:,1,:))/num_trials);
cr=reshape(cr,1,[]);



% latency2max
lat_max=cell2mat(S.(animal)(2,:,2));
lat_max=reshape(lat_max,1,[]);

% latency2crit
lat_crit=cell2mat(S.(animal)(2,:,3));
lat_crit=reshape(lat_crit,1,[]);
% maxAmp
max_amp=cell2mat(S.(animal)(2,:,4));
max_amp=reshape(max_amp,1,[]);

% news.google.com


end

