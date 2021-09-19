%% pie with eb_arc_3


x=[perNTom0 perNTomH perNTomL];
%x=[perTom0 perTomH perTomL];



figure;
h = pie(x); 
hText = findobj(h,'Type','text');
hText(1).FontSize=24; hText(1).FontWeight='bold';
hText(2).FontSize=24; hText(2).FontWeight='bold';
hText(3).FontSize=24; hText(3).FontWeight='bold';
set(gca,'LooseInset',get(gca,'TightInset'))
%%
hText = findobj(h,'Type','text')
hText(1).String='';
hText(2).String='';
%hText(3).String='';
