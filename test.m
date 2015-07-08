Tstart = 0;         % ���� �ð�
Tstop =  -1;         % ���� �ð�
Tperiod = 8;        % �ֱ� ���� ���� ����
Ht = 0.05;           % Power Hold �ð�
Mw = 101;            % TD Conv Window ũ��
Mfilter = 100;         % LPF ũ��
clf;


[src, Fs] = audioreadcut('music/nadia.flac', Tstart, Tstop);
src = src(1, :);
src = lpf(src, 128, Fs, Mfilter) + hpf(src, 10000, Fs, Mfilter);
sound(src, Fs);

Hs = Ht * Fs;
pow = src .* src;

% Time domain window convolution
w = blackman(Mw)';
fil = conv(pow, w);
fil = fil(Mw/2+1:Mw/2+length(pow));

% energy ����
energy = zeros(1, length(pow));
for i = 1:Hs:length(src)-Hs
    sop = sum(pow(i:i+Hs-1)) / Hs;
    energy(i:i+Hs-1) = sop;
end

T(1, :) = periods(src, Fs, Tperiod);
T(2, :) = periods(pow, Fs, Tperiod);
T(3, :) = periods(energy, Fs, Tperiod);
T(4, :) = periods(fil, Fs, Tperiod);

t = [1:length(src)] / Fs + Tstart;
subplot(5,1,1); plot(t, src);
subplot(5,1,2); plot(t, pow);
subplot(5,1,3); plot(t, energy);
subplot(5,1,4); plot(t, fil);
subplot(5,1,5); plot((0:length(T(1, :))-1) * Tperiod, T);
