function [ output_args ] = plot_events( dF, bin )

% dF = deltaF trace, vector
% bin = binary vector, 1's = event


% plot scatter
%figure;plot(dF);hold on;scatter(1:length(dF),bin)

% plot red & blue trace
ndF=dF;
ind=find(~bin);
ndF(ind)=NaN;

figure;
plot(dF,'b','LineWidth',1.5);
hold on;
plot(ndF,'r','LineWidth',1.5);


% figure clean up
end

