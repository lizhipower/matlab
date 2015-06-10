% clc
global bus branch
testof33();
op = ones(1, 37);
% open = [18 33 34 36 37];
% open = [ 11    14    19    26    29    33];
% open = [5 21 14 26 30];
% open = [19 10 12 37 15];
open = [4 8 14 27 32];

for i = 1 : length(open)
    op(open(i)) = 0;
end

branch_temp = branch;
bus_temp = bus;

ii = 1;
branch_new = [];
for i = 1 : length(branch_temp(:, 1))
    if op(i) == 1
        branch_new(ii, :) = branch_temp(i, :);
        ii = ii + 1;
    end
end
branch_temp = branch_new;

T = formT(bus_temp, branch_temp);

isolated = findIsolated(T)
