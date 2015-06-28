function [ Y ] = ffts( x, N )
    if mod(N, 2) ~= 0
        error('N ���ݵ�� 2�� ������� �մϴ�');
    elseif N < 2
        error('N �� �ݵ�� 2 �̻��� �������մϴ�.');
    end
    
    t       = zeros(1, N);
    nx      = length(x);
    Y       = zeros(ceil(nx/N), N);
    k       = 1;
    index1   = 1;
    for index1 = 1:N:nx-N+1
        Y(k, 1:N) = fft(x(index1 : index1+N-1));
        k=k+1;
    end
    index1 = index1 + N;
    
    for index2 = 1:nx-index1+1
        t(index2) = x(index1+index2-1);
    end
    
    if index1 < nx
        Y(k, 1:N) = fft(t);
    end
end

    
    
    
    

    