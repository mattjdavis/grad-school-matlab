function output = medfilt(input,width)

% 1D moving median filter with specified width (odd number)
% NOTES: minimal error checking & no edge handling

n = length(input);
output = input; %modified this so zeros would not appear on the end, filter doesn't care about the end :( (md 6/12/2014)
%output = zeros(n,1);

if ~mod(width,2)
  error('width must be an odd number')
end

range = -(width-1)./2:(width-1)./2;

for j = (1+(width-1)./2):(n-(width-1)./2)
  output(j) = median(input(j+range));
end