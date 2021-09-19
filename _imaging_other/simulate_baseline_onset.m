%% simulate imaging data
%
% NOTES
% 1) could have the noise apply to the whole matrix first

M=zeros(60,75);
for i=1:size(M,2)
    M(1:25,i)=randi([-10 10],25,1);
    
    slope=1.5+ randn(1,1); 
    if mod(i,2)
        slope=-slope;
    else
        slope=slope;
    end
    
    M(26:60,i)=((1:35)*slope)+randi([-10 10],1,35);
    
end
figure;
plot(M);

%% test simulated imaging data
%
% PURPOSE
% I wrote this to test if findOnset would count negative deflections in the
% transients. It does not. (5.15.2015)

on_thresh=2;
off_thresh=0.5;


bl=std(M(1:25,:),[],1);
%bl=reshape(no,60,[]);

onset_thresh=bl*on_thresh;
offset_thresh=bl*off_thresh;
[onsets, lengths]=findOnset(M,onset_thresh',2,offset_thresh');


%% get real data and output crossings.

% get avg bl
no=std(flouro{i}(data.(animal).V.BaselineFrames,:,:),1);
bl{i}=reshape(no,dim2,dim3,[]);

% threshold crossings
onset_thresh=bl{i}*on_thresh;
offset_thresh=bl{i}*off_thresh;
[onsets{i}, lengths{i}]=findOnset(flouro{i},onset_thresh,2,offset_thresh);
