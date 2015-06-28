function [ T ] = period( src, Fs )
% �Ϲ������� ���� ���� ������ ������ �̸� ���� 
MAX_TEMPO = 300;
Tmin = 60 / MAX_TEMPO * Fs;

% LPF ��� : 100hz 
wc = 2*pi/Fs * 100;
M = 51;
w = ideal_lp(wc, M);
h = hamming(M)';
lpf = w .* h;
y = conv(src, lpf);

% Auto correlation ����
y = abs(xcorr(y, fliplr(y)));
plot(1:length(y), y);

% �ִ� Peak ����
[value, index] = max(y);   % Value, Index
peakMax  = [value, index];
peakNext = [y(length(y)), length(y)];

for i = [peakMax(2) + Tmin : length(y)] 
    if peakNext(1) < y(i)
        peakNext = [y(i), i];
    end
end
    
T = peakNext(2) - peakMax(2);
end

