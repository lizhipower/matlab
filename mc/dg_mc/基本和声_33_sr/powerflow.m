function [DS,V, flow , T] = powerflow(bus_temp,OP)
global bus branch
BUS = bus;
BRANCH = branch;
branch_temp = branch;

ii = 1;
for i = 1:length(branch_temp(:, 1))
      if OP(i) == 1
        branch_new(ii, :) = branch_temp(i, :);
        ii = ii + 1;
    end
end
branch_temp = branch_new;


T = formT(bus_temp, branch_temp);
isolated = findIsolated(T);
ii = 1;
for i = 1 : length(bus_temp( : ,1))
    if any(isolated == i) == 0
        bus_new(ii, :) = bus_temp(i, :);
        ii = ii + 1;
    end
end
bus_temp = bus_new;

branch_new = [];
ii = 1;
for i = 1 : length(branch_temp(: ,1 ))
    if any(isolated == branch_temp(i, 1)) == 0 && any(isolated == branch_temp(i, 2)) == 0
        branch_new(ii, :) = branch_temp(i , :);
        ii = ii + 1;
    end
end
% pause
branch_temp = branch_new;

[bus_temp,branch_temp,nodenum] = reordering(bus_temp,branch_temp);

Ybus = admittance_matrix(bus_temp,branch_temp);
% disp('Text');
NRloop;

end

