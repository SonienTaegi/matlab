function [ T ] = period( src, Fs )
% �Ϲ������� ���� ���� ������ ������ �̸� ���� 
MAX_TEMPO = 300;
Tmin = 60 / MAX_TEMPO * Fs;

% Auto correlation ����
y = xcorr(src, fliplr(src));
y = abs(y);
n = ([1:length(y)] - length(y)/2)/Fs;

plot(n, y);

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
T = T / Fs;
end

