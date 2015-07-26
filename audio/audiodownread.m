function [ y ] = audiodownread( filename, Fs )
[src, rate] = audioread(filename);
src = src';

sz = size(src);
channels = sz(1);
elements = sz(2);

% LPF �������Ѵ�.
M = 51;
wc = pi*Fs/rate/2;
h = ideal_lp(wc, M);
w = hamming(M)';
lpf = h .* w;

dst = zeros(channels, elements+M-1);
for k = 1:channels
    dst(k, :) = conv(src(k, :), lpf);
end 
dst = dst(:, 1:length(src));

% % Downsampling �� �Ѵ�.
y = downsamplef(dst, rate / Fs);
% y = zeros(channels, ceil(length(src) / ceil(rate / Fs)));
% for k = 1:channels
%     temp = downsamplef(dst(k, :), rate / Fs);
%     y(k, :) = temp;
% end

end

