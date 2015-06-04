clear;
clc
global bus branch


testof33();
op = [1 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1  1  1   1   1  0   0   0   0   0];

op(22) = 0;
op(32) = 0;


% [bus_temp,branch_temp,nodenum] = reordering(bus_temp,branch_temp)

[ds v flow] = powerflow(bus, op);
subplot(2,1,1);
bar(v(3: end));
axis([0 length(op) 0.9 1]);
subplot(2,1,2);
stem(real(flow(:, 3))* 1e4 );

