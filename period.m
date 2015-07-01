function [ T ] = period( src, Fs )
% �Ϲ������� ���� ���� ������ ������ �̸� ���� 
MAX_TEMPO = 300;
Tmin = 60 / MAX_TEMPO * Fs * 2;

% Auto correlation ����
y = xcorr(src); %conv(src, fliplr(src));
nCenter = length(src);
plot([-nCenter+1:nCenter-1]/Fs, y);

% 2nd Peak ����
peakNext = [length(y), y(length(y))];
% valleyNext = [nCenter, 
for i = nCenter+Tmin:length(y)
    if y(i) > peakNext(2)
        peakNext = [i, y(i)];
    end
end
T = peakNext(1) - nCenter;
T = T / Fs;
end

