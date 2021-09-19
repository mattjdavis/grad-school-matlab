% tone generator - tone freq vs volts
% this will give the min and max voltage from due, with changing panel
% values, helps determine which range to chose/

figure;
hold on;

panel=250:50:1500; %panel values
panel=727;
panel=panel';

%.55 is the minimum and 2.75 is max
for i=1:length(panel);
V=panel(i)*10*linspace(0.55,2.75,100);

minfreq(i,1)= min(V);
maxfreq(i,1)=max(V);
plot(1:100,V);
end

%plots
legend(num2str(panel));
set(gca,'YLim',[0 30000]);
set(gca,'FontSize',14,'FontWeight','bold');
ylabel('Tone Frequency (hz)','FontName','Arial','FontWeight','bold','FontSize',14 );
box off;

%table
T= table(panel,minfreq,maxfreq);

%% plot freq for new track
minf=4000;
maxf=20000;
nbeeps=17;

freq=exp(linspace(log(minf),log(maxf),nbeeps));

% bidi (delete if dont want bidi)
bfreq=fliplr(freq);
bfreq(1)=[]; % dont repeat top beep
bfreq(end)=[];
freq = [ freq bfreq ];
% bidi

%plot
figure;plot(freq,'Marker','o');
axis square;
xlabel('Beep position');
ylabel('Beep frequency (hz)');
% min and max differences
%min(diff(exp(linspace(log(minf),log(maxf),34))))
%max(diff(exp(linspace(log(minf),log(maxf),34))))


% caculate volts
panel=727;
mult=10;
volts=(freq/panel)/mult;

% volts to pin
pin=round(((volts-0.55)./2.2)*4095);

T2= table(freq',volts',pin');

%% step plot

z=repmat(freq,6,1);
z=[z ; NaN(6,nbeeps*2-2)];

zz=reshape(z,1,[]);

% two laps
zz=[zz zz];

figure;
plot(1:length(zz),zz,'LineWidth',3);
xlabel('Track position');
ylabel('Beep frequency (hz)');
set(gca,'XLim',[0 length(zz)]);
box off;



%% pin to volts
input=1;
2.2 * (input / 4095) + 0.56 ;



%% bidirectional before building pin string
%% build string

pin_string='';

for ii=1:length(pin)
    
    %start
    if(ii==1);
        pin_string='{';
    end
    
    % add to string
    p=strcat(num2str(pin(ii)),',');
    pin_string= [pin_string p];


    %end
    if(ii==length(pin));
        pin_string(end)=[];
        pin_string= [pin_string '}'];
    end

end

