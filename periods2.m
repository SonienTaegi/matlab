function [ T ] = periods2( data, Fs, Tmax )
Fc_low  = 128;
Fc_high = 10000;
Mfilter = 501;

% 1. data �� Fc_low - Fc_hi BandStop ���͸� ������� ���̽��巳�� ���׾�巳�� �����Ѵ�.
wc_low  = 2*pi/Fs*Fc_low;
wc_high = 2*pi/Fs*Fc_high;
h_hp    = ideal_lp(pi, Mfilter) - ideal_lp(wc_high, Mfilter);
h_lp    = ideal_lp(wc_low, Mfilter);
h_bs    = h_lp + h_hp;
w       = blackman(Mfilter)';
hpf     = w .* h_hp;
lpf     = w .* h_lp;
bsf     = w .* h_bs;

% src     = conv(data, hpf);
% src     = conv(data, bsf);
src     = conv(data, lpf);
src     = src(1:length(data));

% 2. power �� ���Ѵ�.
src     = src .* src;

% 3. �ݺ������� �ֱ⸦ ���Ѵ�.
T       = zeros(1, length(data));
Tprev   = 0;
Mprev   = 0;
iprev   = 1;

index   = 1;
MT_max  = ceil(Tmax*2*Fs);
while index <= (length(data)-MT_max)
    isHit   = false;
    isEdge  = false;
    
    if Tprev > 0 
        % ���� �ֱ� �����Ϳ� ���� �ֱ� ������ �������. -5 ~ 5ms ���� �ѵ� ���� 
        offsetMax   = 0;
        offsetCoef  = 0;
        for offset = round([-5:5]*Fs*0.001)
            coef = sum(src([iprev:iprev+Mprev-1]) .* (src([index:index+Mprev-1] + offset)));
            if coef > offsetCoef
                offsetCoef = coef;
                offsetMax  = offset;
            end
        end

        if 2*coef > sum(src([iprev:iprev+Mprev-1]) .* src([iprev:iprev+Mprev-1])) 
            % �ֱ⼺ ���� Ȯ��
            isHit = true;
            if offsetMax > 0
                T(index:index+offsetMax-1) = Tprev;
                index = index+offsetMax;
            end
        else
            % �ֱ� ���� ��
            isEdge = true;
        end
    end
    
    if isHit 
        % �ֱ⼺�� �����ǰ� �ִ� ��� ���� �ֱ⸦ �״�� ����Ѵ�.
        Tnext = Tprev;
    else 
        % �ƴϸ� �ڱ��ֱ� Ȯ��
        Tnext = period(src(index:index+MT_max-1), Fs);
    end
    
    % �ֱ⼺�������ϰ�, ������ Ȯ���Ѵ�. 
    if Tnext < 0.5
        % �ֱ� ȹ�� ���� �� 10ms �������
        Tnext = 0;
        Mnext = 0.01 * Fs;
    else 
        Mnext = Tnext * Fs;
    end
    Mnext = round(Mnext);
        
    
    % �ֱ⼺�� �����Ѵ�.
    T(index:index+Mnext-1) = Tnext;
    
    % �׽�Ʈ �� ��Ŀ�� ����.
    if isHit
        T(index) = 0.1;     % Marker - Next block
    else
        T(index) = 0;       % Marger - This is new block
    end
    
    if isEdge
        T(index+ceil(Mnext/2)-1) = Tnext+0.5;
    end
    
    % �ֱⰡ �����Ǵ� ��� �ֱ� ������ ����Ѵ�.
    Tprev = Tnext;
    Mprev = Mnext;
    iprev = index;
    
    % ���� ���� �غ� 
    index = index + Mnext;
end