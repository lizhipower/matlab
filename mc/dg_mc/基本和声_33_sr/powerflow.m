function [DS,V, flow] = powerflow(bus_temp,OP)
global bus branch
branch_temp = branch;

ii = 1;
for i = 1:length(branch_temp(:, 1))
      if OP(i) == 1
        branch_new(ii, :) = branch_temp(i, :);
        ii = ii + 1;
    end
end
branch_temp = branch_new;
bus_temp = bus_temp(1: 31, :);

[bus_temp,branch_temp,nodenum] = reordering(bus_temp,branch_temp);

Ybus = admittance_matrix(bus_temp,branch_temp)
NRloop;

end

