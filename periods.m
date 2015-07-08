function [ P, output ] = periods( data, Fs, Tp_max )
Fc_low  = 128;
Fc_high = 8192;
Mfilter = 101;

% 1. data �� Fc_low - Fc_hi BandStop ���͸� ������� ���̽��巳�� ���׾�巳�� �����Ѵ�.
wc_low  = 2*pi/Fs*Fc_low;
wc_high = 2*pi/Fs*Fc_high;
h       = ideal_lp(pi, Mfilter) - ideal_lp(wc_high, Mfilter) + ideal_lp(wc_low, Mfilter);
w       = blackman(Mfilter)';
bpf     = w .* h;

src     = conv(data, bpf);
src     = src((Mfilter+1)/2:(Mfilter-1)/2+length(data));

% 2. power �� ���Ѵ�.
pow     = src .* src;

% 3. power �� windowing �Ͽ� ���������Ѵ�.
%pow     = conv(pow, w);
%pow     = pow((Mfilter+1)/2:(Mfilter-1)/2+length(data));

% 4. �ݺ������� �ֱ⸦ ���Ѵ�.
P       = zeros(1, length(data));
i       = 1;
Mp_block=Tp_max*2*Fs;
while i <= (length(data)-Mp_block)
    Tp = period(pow(i:i+Mp_block-1), Fs);
    if Tp < 0.5 || Tp > Tp_max
        Tp = 0;
        Mp = ceil(0.1 * Fs);
    else
        Mp = ceil(Tp * Fs / 2);
    end
    P(i:i+Mp-1) = Tp;
    i = i + Mp;
end
output = pow;
end

