global bus branch
clc

testof33();
op = [1 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1  1  1   1   1  0   0   0   0   0];

op(7) = 0;

[ds v flow] = powerflow(bus, op);

% bar(real(flow(:, 3)) * 10000/ 5000)
stem(real(flow(:, 3))* 1e4 )

% bar(v(3: end))
