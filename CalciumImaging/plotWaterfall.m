function plotWaterfall( M, labels )
%UNTITLED2 Summary of this function goes here
%   M is a matrix with R = time, and C = traces



% labels should be the same size as plot

vectorLen=size(M,1);

% h_shift= .01 * vectorLen;
% v_shift= .02* max(max(M))/2;

h_shift=0;
v_shift=2;
xLabel=20;

figure;
hold on;

for i=1:size(M,2)
    xvec=(1:vectorLen)+(i*h_shift);
    yvec=M(:,i)-(i*v_shift);
    plot(xvec,yvec,'b');
    
    if (nargin > 1); text(vectorLen+xLabel,median(yvec),labels{i}); end
end


axis off;

set(gca, 'LooseInset', [0,0,0,0]);
%great for 3 long traces
%set(gcf, 'Units', 'Inches', 'Position', [0, 0, 10.0, 3.0], 'PaperUnits', 'Inches', 'PaperSize', [10.0, 3.0])

end

