clear;
clc
global bus branch


testof33();
op = [1 1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1   1  1  1   1   1  0   0   0   0   0];

op(25) = 0;
% op(32) = 0;

bus_temp = bus;
branch_temp = branch;

ii = 1;
for i = 1:length(branch_temp(:, 1))
      if op(i) == 1
        branch_new(ii, :) = branch_temp(i, :);
        ii = ii + 1;
    end
end
branch_temp = branch_new;

% ================
% % [bus_temp,branch_temp,nodenum] = reordering(bus_temp,branch_temp)

% [ds v flow] = powerflow(bus, op);

% stem(real(flow(:, 3))* 1e4 )

% =================

% bus = 1 : 8;
% bus = bus';
% branch = [
%     1 2;
%     2 3;
%     3 4;
%     4 5;
%     5 6;
%     % 2 7;
%     3 8;
% ];
T = formT(bus_temp, branch_temp);
isolated = findIsolated(T)