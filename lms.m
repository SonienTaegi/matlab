function [ h, y ] = lms( x, d, delta, N )
%     h = ������ FIR filter
%     y = ���
%     x = �Է�
%     d = ������. x �͵�����ũ��
% delta = Step size
%     N = FIR ���� ��� ����
M = length(x); 
y = zeros(1, M);
e = zeros(1, M); 
h = zeros(1, N);

for n = N:M
       x1 = x(n:-1:n-N+1);
       yt = h * x1';
     y(n) = yt;
       et = d(n) - yt;
     e(n) = et;
        h = h + delta*et*x1;
end
end

