%% plots waterfall files

% inputs: data (a matrix of blink traces)


% ex. of loading data; must run direct_load_eb to get 'eb_dataset' stuct
data=eb_dataset(1).td10.eb_data.WaterFall.raw_data;


num_frames=350;
% for eb
%h_shift=5;
%v_shift=.1;

% For waterfall
h_shift= 0.0143 * num_frames;
v_shift= .2 * max(max(data));


figure; 
hold on;
for i=1:size(data,2)
    xvec=(1:num_frames)+(i*h_shift);
    yvec=data(:,i)-(i*v_shift);
    plot(xvec,yvec);
end
hold off;

figure; imagesc(data',[0 .85])
figure;plot(data)
    


