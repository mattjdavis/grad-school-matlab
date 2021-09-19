%%
in.vars={'no_cr' 'bb' 'bt'};
nocr_out=process_fluor_data(in,dataset,0);
onsets_nocr=plot_onset(nocr_out.F,nocr_out.onsets,in.cell_choice,in.day_choice,in.vars);


in.vars={'cr' 'bb' 'bt'};
cr_out=process_fluor_data(in,dataset,0);
onsets_cr=plot_onset(cr_out.F,cr_out.onsets,in.cell_choice,in.day_choice,in.vars);

close all;
%% no tight subplot

x_vec=1:60;


 for i=1:length(in.day_choice);       
    figure;
    hist(onsets_cr{i},1:60);
    hold on;
    hist(onsets_nocr{i},1:60);
    h = findobj(gca,'Type','patch');

    %color histograms
    c1=[0.9047    0.1918    0.1988]
    set(h(2),'FaceColor',c1,'EdgeColor',c1,'facealpha',0.75);
    c2=[0.2941    0.5447    0.7494]
    set(h(1),'FaceColor',c2,'EdgeColor',c2,'facealpha',0.6);

    xlim([0 length(x_vec)]);
    ylim([0 40]);
 end


    



 


