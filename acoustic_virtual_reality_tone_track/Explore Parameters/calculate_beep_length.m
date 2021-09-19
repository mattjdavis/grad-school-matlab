%%
% beep on position, there is a maximum beep length before beeps bleed into
% each other.


beep_on=[ 20 30 40 50 60 70];

rpm=1:60;
tpm=rpm*32; % 64 for every trans, 32 for every two
tpms=tpm/60;

figure;hold on;
for ii=1:length(beep_on)
total_on=beep_on(ii)*tpms;
total_off=1000-total_on;

plot(total_off,'LineWidth',2);
end;

set(gca,'YLim',[0 1000]);
title('Beep every 2 transitions');
set(gca,'FontSize',14,'FontWeight','bold');
xlabel('RPM','FontName','Arial','FontWeight','bold','FontSize',16 );
ylabel('Beep off time (ms)','FontName','Arial','FontWeight','bold','FontSize',16 );
box off;



lgd=legend({'20', '30', '40' ,'50', '60' ,'70'});
legend('boxoff');
lgd.title('Beep On Time (ms)')




