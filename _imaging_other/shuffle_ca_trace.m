%% shuffle ca
%
% PURPOSE
% To takes random slices of imaging data, and plot the result. Run some of
% my threshold crossings to test 

% data vars
F=pr_out.flouro{1};
cell=4;

% script vars
shuffle_num=100;
frame_num=60;

M=zeros(shuffle_num,frame_num);

long_trace=reshape(F(:,:,cell),1,[]);
len=length(long_trace);

a=randi([1 len-frame_num],1,shuffle_num);
b=a+frame_num-1;

for i=1:shuffle_num
    M(i,:)=long_trace(a(i):b(i));
end



%% plot shuffle

figure;

j=0;
lt=[]; ltc=[]; long_trace=[];
for k=1:8
 for i=1:3
    j=j+1;
    hold on;
    long_trace(j,:)=reshape(pr_out.flouro{k}(:,:,i),1,[]);
    
    plot(long_trace(j,:)+(50*(j)));
    
    %x corr
    lt(i,:)=long_trace(j,:);
    
 end
 
    ltc(:,:,k)=corr(lt');
end
figure; hold on;
for i=1:3
    
    a=reshape(ltc(1,2,:),1,[]);
    b=reshape(ltc(1,3,:),1,[]);
    c=reshape(ltc(2,3,:),1,[]);
    
    plot(a);
    plot(b);
    plot(c);
end
