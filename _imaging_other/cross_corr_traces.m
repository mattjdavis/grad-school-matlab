% playing with corr and xcorr




% get two days (td01, td14); long row
a=reshape(out.flouro{1},60,12,[]);
b=reshape(out.flouro{2},60,12,[]);
%%
% similar neurons concatenated
aa=reshape(out.flouro{1},60*12,153)';
bb=reshape(out.flouro{2},60*12,153)';

figure; imagesc(aa,[0 100]); % take a look at them neurons all aligned
figure; imagesc(bb,[0 100]); % take a look at them neurons all aligned

%%
% add in some cr fun

%p= [11;16;21;26;31;36;41;46;51;56;61;66];
p=[12;13;14;15;17;18;19;20;22;23;24;25;27;28;29;30;32;33;34;35;37;38;39;40;42;43;44;45;47;48;49;50;52;53;54;55;57;58;59;60;62;63;64;65;67;68;69;70];

bc=data.md061.td14.Cr;
ac=data.md061.td08.Cr;

ac=ac(p);
bc=bc(p);


%%

figure;
subplot(2,1,1); imagesc(bb,[0 100]); 
subplot(2,1,2); imagesc(bc');

figure;
subplot(2,1,1); imagesc(aa,[0 100]); 
subplot(2,1,2); imagesc(ac');


%% corr
%figure;imagesc(aa(1:20,1:60));

%figure;imagesc(corr(aa(:,1:60)'));
figure;imagesc(xcorr(aa(1:2,1:60)')');