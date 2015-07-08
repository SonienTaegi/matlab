function [ T ] = period( src, Fs )
% �Ϲ������� ���� ���� ������ ������ �̸� ���� 
MAX_TEMPO = 300;
Tmin = ceil(60 / MAX_TEMPO * Fs * 2);

% Auto correlation ����
y = xcorr(src);
nCenter = length(src);
% plot([-nCenter+1:nCenter-1]/Fs, y);

% High Pass Filter ���
y = hpf(y, 64, Fs, 1001);
y = y(501:length(y)-500);

% 2nd Peak ����
peakNext = [length(y), 0];
for i = nCenter+Tmin:length(y)
    if y(i) > peakNext(2)
        peakNext = [i, y(i)];
    end
end
T = peakNext(1) - nCenter;
T = T / Fs;
end

