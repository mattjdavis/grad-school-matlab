%%
% seperated example traces
a=output1.F{1}(:,:,2); a=reshape(a,1,[]);a=a(2161:2880);
b=output2.F{1}(:,:,2); b=reshape(b,1,[]); b=b+200;


vLength=80;
nTraces=12;


figure; hold on;
for i=1:nTraces
    yvec=a((1:vLength)+((i-1)*vLength));
    yvec2=b((1:vLength)+((i-1)*vLength));
    xvec=(1:vLength)+(i*65);
    plot(xvec,yvec);
    
    plot(xvec, yvec2,'r');
end



% place 1 gray line (puff)
for i =1:nTraces
    x_line= [21 21] +(i*65);
    line(x_line,[250 275],'LineWidth',3,'LineStyle','-','Color',[.5 .5 .5]);
end

% place 1 gray line (puff) and 1 red (CS)
for i =1:nTraces
    x_line= [21 21] +(i*65);
    x_line2= [18 18] +(i*65);
    line(x_line,[50 75],'LineWidth',3,'LineStyle','-','Color',[.5 .5 .5]);
    line(x_line2,[50 75],'LineWidth',3,'LineStyle','-','Color',[1 0 0]);
end