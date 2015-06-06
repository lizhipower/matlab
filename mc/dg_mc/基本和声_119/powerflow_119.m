function [DS,V] = powerflow_119(bus_temp,OP)
global bus branch
%testof33();
%bus_temp = bus;
branch_temp = branch;
%%
length(branch_temp(:, 1))
ii = 1;
for i = 1:length(branch_temp(:, 1))
      if OP(i) == 1
        branch_new(ii, :) = branch_temp(i, :);
        ii = ii + 1;
    end
end
branch_temp = branch_new;
length(branch_temp(:, 1))

% branch_temp = branch_new;

[bus_temp,branch_temp,nodenum] = reordering(bus_temp,branch_temp);
% bus_temp
% nodenum
Ybus = admittance_matrix(bus_temp,branch_temp);
NRloop;

end

