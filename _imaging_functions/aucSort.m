a=md050.td08182014.RoiA.Data
aa=reshape(trapz(a),60,25);
[bv,bi]=sort(aa);
%%
tr=size(a,2);
for i=1:25
    p=bi(58:60,i);
    figure;
    plot(a(:,p,i));
end
    